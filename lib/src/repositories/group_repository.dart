import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../api/json_utils.dart';
import '../models/author.dart';
import '../models/group.dart';
import '../models/paged.dart';
import '../models/topic.dart';
import '../utils/draft_content.dart';

class GroupRepository {
  GroupRepository(this._frodo, this._rexxar);

  final Dio _frodo;
  final Dio _rexxar;

  /// 推荐小组（无需登录）
  /// GET https://m.douban.com/rexxar/api/v2/group/rec_groups_for_newbies
  ///
  /// 响应嵌套：rec_groups[*].classified_groups[*].groups[*]
  /// 这里展平所有 classified_groups 下的 groups，并按 id 去重保持顺序。
  Future<List<Group>> fetchRecommended() async {
    final res = await _rexxar.get<Map<String, dynamic>>(
      '/rexxar/api/v2/group/rec_groups_for_newbies',
    );
    final data = asMap(res.data);

    final flat = <Group>[];
    final seen = <String>{};
    void absorb(dynamic raw) {
      if (raw is! List) return;
      for (final item in raw.whereType<Map<String, dynamic>>()) {
        final g = Group.fromJson(item);
        if (seen.add(g.id)) flat.add(g);
      }
    }

    final recGroups = data['rec_groups'];
    if (recGroups is List) {
      for (final block in recGroups.whereType<Map<String, dynamic>>()) {
        final classified = block['classified_groups'];
        if (classified is List) {
          for (final c in classified.whereType<Map<String, dynamic>>()) {
            absorb(c['groups']);
          }
        }
        // 兼容某些 banner 直接平铺 groups 的情况
        absorb(block['groups']);
      }
    }
    // 兜底：万一以后接口改回扁平结构
    absorb(data['groups']);
    absorb(data['items']);

    return List.unmodifiable(flat);
  }

  /// 按分类 tag 推荐小组
  /// GET https://frodo.douban.com/api/v2/group/rec_groups_by_tag?tag=...
  Future<List<Group>> fetchByTag(String tag) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/rec_groups_by_tag',
      queryParameters: {'tag': tag},
    );
    final data = asMap(res.data);
    final list = asList(data['groups'] ?? data['items']);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Group.fromJson)
        .toList(growable: false);
  }

  /// 当前用户加入/关注的小组
  /// GET https://frodo.douban.com/api/v2/group/user/{user_id}/joined_groups
  ///
  /// page=''   只返回加入的小组
  /// page=home 返回加入 + 关注的小组（需较新的 user-agent）
  Future<Paged<Group>> fetchJoinedGroups(
    String userId, {
    int start = 0,
    String page = '',
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/$userId/joined_groups',
      queryParameters: {
        'page': page,
        'start': start,
      },
    );
    return parsePagedList<Group>(
      asMap(res.data),
      itemsKeys: const ['groups'],
      fromJson: Group.fromJson,
      fallbackStart: start,
    );
  }

  /// 用户主页的小组信息（自己 / 别人通用，无需区分）
  /// GET https://frodo.douban.com/api/v2/group/user/{user_id}/profile_group_info
  ///
  /// 返回扁平的 `groups` 列表（不带「创建/加入/关注」角色区分）加 `groups_total`
  /// 总数；列表本身是截断的（如 total=15 只回十余条）。`similar_groups` 是推荐
  /// 的相似小组，这里不展示，忽略。
  Future<({List<Group> groups, int total})> fetchProfileGroups(
    String userId, {
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/$userId/profile_group_info',
      queryParameters: {'count': count},
    );
    final data = asMap(res.data);
    final groups = asList(data['groups'])
        .whereType<Map<String, dynamic>>()
        .map(Group.fromJson)
        .toList(growable: false);
    final total = (data['groups_total'] as num?)?.toInt() ?? groups.length;
    return (groups: groups, total: total);
  }

  /// 小组详情
  /// GET https://frodo.douban.com/api/v2/group/{group_id}
  Future<Group> fetchDetail(String groupId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId',
    );
    final data = res.data ??
        (throw StateError('empty response for group $groupId'));
    return Group.fromJson(data);
  }

  /// 小组讨论列表
  /// GET https://frodo.douban.com/api/v2/group/{group_id}/topics
  Future<Paged<Topic>> fetchTopics(
    String groupId, {
    int start = 0,
    int count = 30,
    String sortBy = 'new',
    String? groupTabId,
  }) async {
    // openapi 标 sortby 为 required；
    // detail 响应里的 `group_tabs[].id` 作为 query 时使用 `topic_tag_id` key。
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId/topics',
      queryParameters: {
        'start': start,
        'count': count,
        'sortby': sortBy,
        if (groupTabId != null) 'topic_tag_id': groupTabId,
      },
    );
    return parsePagedList<Topic>(
      asMap(res.data),
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }

  /// 用户小组的推荐 feed
  /// GET https://frodo.douban.com/api/v2/group/user/recent_topics_feed
  Future<Paged<Topic>> fetchRecentTopicsFeed({
    int start = 0,
    int count = 30,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/recent_topics_feed',
      queryParameters: {'start': start, 'count': count},
    );
    final data = asMap(res.data);
    // feed item 多包了一层 `topic`，先抽出来再走通用解析。
    final topics = asList(data['feeds'])
        .whereType<Map<String, dynamic>>()
        .map((e) => e['topic'])
        .whereType<Map<String, dynamic>>()
        .map(Topic.fromJson)
        .toList(growable: false);
    return Paged<Topic>(
      items: topics,
      start: start,
      count: topics.length,
      hasMore: data['has_more'] as bool?,
    );
  }

  /// 首页"推荐的混合物" feed，只挑出其中的小组讨论贴。
  /// GET https://frodo.douban.com/api/v2/elendil/recommend_feed
  ///
  /// 这是个小组讨论 / 个人动态 / 日记 混排的 feed（实测一批约 9 条、小组讨论占
  /// 小半），靠 [_recommendFeedTopic] 只挑出小组讨论。响应无 has_more，是无限
  /// 推荐流，故默认 hasMore=true。
  ///
  /// 因为过滤掉了非小组项，游标必须按服务端返回的**原始**条数推进（[nextStart]），
  /// 不能用过滤后的帖子数。单批过滤后可能一条小组讨论都没有，所以内部最多翻
  /// 几页凑够一屏，避免分页器因"空页"停住。
  Future<({List<Topic> topics, int nextStart, bool hasMore})>
      fetchRecommendFeed({int start = 0, int count = 20}) async {
    final collected = <Topic>[];
    var cursor = start;
    var hasMore = true;
    for (var i = 0; i < 5 && hasMore && collected.length < count; i++) {
      final res = await _frodo.get<Map<String, dynamic>>(
        '/api/v2/elendil/recommend_feed',
        queryParameters: {'start': cursor, 'count': count},
      );
      final data = asMap(res.data);
      final raw = asList(data['items'] ?? data['feeds'])
          .whereType<Map<String, dynamic>>()
          .toList();
      if (raw.isEmpty) {
        hasMore = false;
        break;
      }
      cursor += raw.length;
      hasMore = (data['has_more'] as bool?) ?? true;
      for (final item in raw) {
        final t = _recommendFeedTopic(item);
        if (t != null) collected.add(t);
      }
    }
    return (topics: collected, nextStart: cursor, hasMore: hasMore);
  }

  /// 当前用户发布的帖子
  /// GET https://frodo.douban.com/api/v2/group/user/posted_topics
  Future<Paged<Topic>> fetchPostedTopics({int start = 0, int count = 20}) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/posted_topics',
      queryParameters: {'start': start, 'count': count},
    );
    return parsePagedList<Topic>(
      asMap(res.data),
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }

  /// 当前用户回复过的帖子
  /// GET https://frodo.douban.com/api/v2/group/user/replied_topics
  Future<Paged<Topic>> fetchRepliedTopics({int start = 0, int count = 20}) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/replied_topics',
      queryParameters: {'start': start, 'count': count},
    );
    return parsePagedList<Topic>(
      asMap(res.data),
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }

  /// 综合搜索：同一次请求同时返回小组和讨论贴（group_tab 接口）。
  /// start=0 时两者都有；start>0 时 groups 为空，仅翻讨论贴。
  Future<({List<Group> groups, Paged<Topic> topics})> searchGroupTab(
    String keyword, {
    int start = 0,
    int count = 20,
    String sort = 'relevance',
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/search/group_tab',
      queryParameters: {
        'q': keyword,
        'sort': sort,
        'start': start,
        'count': count,
      },
    );
    final data = asMap(res.data);

    final groups = asList(asMap(data['groups'])['items'])
        .whereType<Map<String, dynamic>>()
        .map((e) => Group.fromJson(asMap(e['target']).isNotEmpty
            ? e['target'] as Map<String, dynamic>
            : e))
        .toList(growable: false);

    final topicsBlock = asMap(data['topics']);
    final topics = parsePagedList<Topic>(
      topicsBlock,
      fromJson: _parseSearchTopic,
      fallbackStart: start,
    );

    return (groups: groups, topics: topics);
  }

  /// 搜索小组
  /// GET /api/v2/search/group?q=...&start=0&count=20
  Future<Paged<Group>> searchGroups(
    String keyword, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/search/group',
      queryParameters: {'q': keyword, 'start': start, 'count': count},
    );
    return parsePagedList<Group>(
      asMap(res.data),
      fromJson: (e) => Group.fromJson(asMap(e['target']).isNotEmpty
          ? e['target'] as Map<String, dynamic>
          : e),
      fallbackStart: start,
    );
  }

  /// 搜索用户
  /// GET /api/v2/search/user?q=...&start=0&count=20
  Future<Paged<Author>> searchUsers(
    String keyword, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/search/user',
      queryParameters: {'q': keyword, 'start': start, 'count': count},
    );
    return parsePagedList<Author>(
      asMap(res.data),
      fromJson: (e) => Author.fromJson(asMap(e['target']).isNotEmpty
          ? e['target'] as Map<String, dynamic>
          : e),
      fallbackStart: start,
    );
  }

  /// 小组成员列表
  /// GET https://frodo.douban.com/api/v2/group/{group_id}/members
  Future<Paged<Author>> fetchMembers(
    String groupId, {
    int start = 0,
    int count = 30,
    String sortBy = 'new',
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId/members',
      queryParameters: {'start': start, 'count': count, 'sortby': sortBy},
    );
    return parsePagedList<Author>(
      asMap(res.data),
      itemsKeys: const ['members'],
      fromJson: Author.fromJson,
      fallbackStart: start,
    );
  }

  /// 申请/加入小组
  /// POST https://frodo.douban.com/api/v2/group/{group_id}/join
  ///
  /// `reason` 仅在 join_type='R'（需申请）时被服务端使用，但 openapi 标为必填，
  /// 故 join_type='A'（直接加入）时也传空串。
  Future<void> joinGroup(String groupId, {String reason = ''}) async {
    await _frodo.post<dynamic>(
      '/api/v2/group/$groupId/join',
      data: FormData.fromMap({
        'type': 'request_join',
        'reason': reason,
      }),
    );
  }

  /// 在小组里发表讨论
  /// POST https://frodo.douban.com/api/v2/group/{group_id}/post
  ///
  /// `content` 是 DraftJS JSON 字符串（见 [encodeDraftContent]）；签名字段
  /// apikey/_sig/_ts 由 [AuthInterceptor] 自动塞进 multipart body。
  /// [images] 预留给后续发图：每张图先经 [uploadGroupImage] 拿到 id，再按
  /// `序号_图片id` 拼进 image_ids，描述按序进 image_titles。
  Future<Topic> createPost(
    String groupId, {
    required String title,
    required String content,
    List<DraftImage> images = const [],
  }) async {
    final form = FormData();
    form.fields.addAll([
      MapEntry('title', title),
      MapEntry('content', encodeDraftContent(content, images: images)),
      MapEntry('original', '0'),
      MapEntry(
        'image_ids',
        [for (var i = 0; i < images.length; i++) '${i + 1}_${images[i].id}']
            .join(','),
      ),
      for (final img in images) MapEntry('image_titles', img.caption),
    ]);
    final res = await _frodo.post<Map<String, dynamic>>(
      '/api/v2/group/$groupId/post',
      queryParameters: const {'timezone': 'GMT'},
      data: form,
    );
    return Topic.fromJson(asMap(res.data));
  }

  /// 上传一张图片到小组（发图前置步骤）
  /// POST https://frodo.douban.com/api/v2/group/{group_id}/upload
  ///
  /// multipart 字段 `image` 是文件本体，返回 `{id, src, width, height, ...}`，
  /// 据此构造 [DraftImage] 再交给 [createPost]。
  Future<DraftImage> uploadGroupImage(
    String groupId,
    String filePath, {
    String caption = '',
  }) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });
    final res = await _frodo.post<Map<String, dynamic>>(
      '/api/v2/group/$groupId/upload',
      data: form,
    );
    final data = asMap(res.data);
    return DraftImage(
      id: (data['id'] ?? '').toString(),
      src: (data['src'] ?? data['raw_src'] ?? '') as String,
      width: (data['width'] as num?)?.toInt() ?? 0,
      height: (data['height'] as num?)?.toInt() ?? 0,
      caption: caption,
      isAnimated: data['is_animated'] == true,
    );
  }

  /// 小组内搜索讨论
  /// GET /api/v2/group/{group_id}/search/topic?q=...&sortby=relevance&cat=1013
  Future<Paged<Topic>> searchGroupTopics(
    String groupId,
    String keyword, {
    int start = 0,
    int count = 30,
    String sortBy = 'relevance',
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId/search/topic',
      queryParameters: {
        'q': keyword,
        'cat': 1013,
        'sortby': sortBy,
        'start': start,
        'count': count,
      },
    );
    return parsePagedList<Topic>(
      asMap(res.data),
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }
}

/// 从混排 recommend_feed 的一个 item 里抽出小组讨论贴；不是讨论贴返回 null。
///
/// item 结构（实测，openapi 没给）：外层是 feed 包装，帖子正文在 `content`
/// （含 author / photos / title / abstract / id），转评赞计数在**外层** item 上，
/// `owner` 才是所属小组。`content.subtype` 区分类型：group=小组讨论、
/// personal=个人动态。这里只要小组讨论，并把外层计数 + owner 合并进 content。
Topic? _recommendFeedTopic(Map<String, dynamic> item) {
  final content = item['content'];
  if (content is! Map<String, dynamic>) return null;
  if (content['subtype'] != 'group') return null;
  return Topic.fromJson(<String, dynamic>{
    ...content,
    if (item['owner'] is Map) 'group': item['owner'],
    if (item['comments_count'] != null) 'comments_count': item['comments_count'],
    if (item['reactions_count'] != null) 'reactions_count': item['reactions_count'],
    if (item['collections_count'] != null)
      'collections_count': item['collections_count'],
    if (item['reshares_count'] != null) 'reshares_count': item['reshares_count'],
    if (item['reaction_type'] != null) 'reaction_type': item['reaction_type'],
    if (item['sharing_url'] != null) 'sharing_url': item['sharing_url'],
  });
}

/// `group_tab` 搜索返回的讨论结构：target 里嵌着 Topic 字段，但 id 在外层
/// `target_id`，owner 是 group，封面藏在 photos[0].normal.url。
/// `card_subtitle` 形如 "Reco 48赞 · 10回复"，是唯一携带评论数的字段。
Topic _parseSearchTopic(Map<String, dynamic> e) {
  final target = e['target'];
  if (target is! Map<String, dynamic>) return Topic.fromJson(e);

  final rawPhotos = asList(target['photos']).whereType<Map<String, dynamic>>().toList();

  // 搜索结果的 photos 结构扁平：{ large, normal, raw }
  // TopicPhoto.fromJson 期望：{ image: { large, normal, raw } }
  final mappedPhotos = rawPhotos.map((p) => <String, dynamic>{'image': p}).toList();

  String? coverUrl;
  if (rawPhotos.isNotEmpty) {
    final normal = rawPhotos.first['normal'];
    if (normal is Map) coverUrl = normal['url'] as String?;
  }

  // card_subtitle 格式固定为 "{作者名} {n}赞 · {n}回复"
  final subtitle = target['card_subtitle'] as String?;
  final subtitleMatch = subtitle != null
      ? RegExp(r'^(.+?)\s+(\d+)赞\s*·\s*(\d+)回复$').firstMatch(subtitle)
      : null;
  final authorName = subtitleMatch?.group(1);
  final reactionsCount =
      subtitleMatch != null ? int.tryParse(subtitleMatch.group(2)!) : null;
  final commentsCount =
      subtitleMatch != null ? int.tryParse(subtitleMatch.group(3)!) : null;

  return Topic.fromJson(<String, dynamic>{
    ...target,
    'id': e['target_id'] ?? '',
    'group': target['owner'],
    'photos': mappedPhotos,
    if (coverUrl != null) 'cover_url': coverUrl,
    if (authorName != null) 'author': {'id': '', 'name': authorName},
    if (reactionsCount != null) 'reactions_count': reactionsCount,
    if (commentsCount != null) 'comments_count': commentsCount,
  });
}

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    ref.watch(dioProvider),
    ref.watch(rexxarDioProvider),
  );
});
