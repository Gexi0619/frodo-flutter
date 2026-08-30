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
    final data =
        await _rexxar.getMap('/rexxar/api/v2/group/rec_groups_for_newbies');

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
    final data = await _frodo.getMap(
      '/api/v2/group/rec_groups_by_tag',
      query: {'tag': tag},
    );
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
    final data = await _frodo.getMap(
      '/api/v2/group/user/$userId/joined_groups',
      query: {
        'page': page,
        'start': start,
      },
    );
    return parsePagedList<Group>(
      data,
      itemsKeys: const ['groups'],
      fromJson: Group.fromJson,
      fallbackStart: start,
    );
  }

  /// 用户主页的小组信息（自己 / 别人通用，无需区分）
  /// GET https://frodo.douban.com/api/v2/group/user/{user_id}/profile_group_info
  ///
  /// 返回扁平的 `groups` 列表（不带「创建/加入/关注」角色区分），支持 start/count
  /// 翻页。总数字段不统一：首页（start=0）回 `groups_total`，翻页后回标准 `total`，
  /// 两个都认，避免后续页落回 items.length 导致提前判定到底。
  /// `similar_groups` 是推荐的相似小组，这里不展示，忽略。
  Future<Paged<Group>> fetchProfileGroups(
    String userId, {
    int start = 0,
    int count = 20,
  }) async {
    final data = await _frodo.getMap(
      '/api/v2/group/user/$userId/profile_group_info',
      query: {'start': start, 'count': count},
    );
    final groups = asList(data['groups'])
        .whereType<Map<String, dynamic>>()
        .map(Group.fromJson)
        .toList(growable: false);
    final total = (data['total'] as num?)?.toInt() ??
        (data['groups_total'] as num?)?.toInt() ??
        groups.length;
    return Paged<Group>(
      items: groups,
      total: total,
      start: start,
      count: count,
    );
  }

  /// 小组详情
  /// GET https://frodo.douban.com/api/v2/group/{group_id}
  ///
  /// [markVisited] 为 true 时带上 `access=1`：服务端据此认为用户进入过该小组，
  /// 会把小组的未读消息数清零。进入小组详情页即视为已访问，故默认开启。
  Future<Group> fetchDetail(String groupId, {bool markVisited = true}) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId',
      queryParameters: {if (markVisited) 'access': '1'},
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
    final data = await _frodo.getMap(
      '/api/v2/group/$groupId/topics',
      query: {
        'start': start,
        'count': count,
        'sortby': sortBy,
        if (groupTabId != null) 'topic_tag_id': groupTabId,
      },
    );
    return parsePagedList<Topic>(
      data,
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
    final data = await _frodo.getMap(
      '/api/v2/group/user/recent_topics_feed',
      query: {'start': start, 'count': count},
    );
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
      final data = await _frodo.getMap(
        '/api/v2/elendil/recommend_feed',
        query: {'start': cursor, 'count': count},
      );
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
    final data = await _frodo.getMap(
      '/api/v2/group/user/posted_topics',
      query: {'start': start, 'count': count},
    );
    return parsePagedList<Topic>(
      data,
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }

  /// 当前用户回复过的帖子
  /// GET https://frodo.douban.com/api/v2/group/user/replied_topics
  Future<Paged<Topic>> fetchRepliedTopics({int start = 0, int count = 20}) async {
    final data = await _frodo.getMap(
      '/api/v2/group/user/replied_topics',
      query: {'start': start, 'count': count},
    );
    return parsePagedList<Topic>(
      data,
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
    final data = await _frodo.getMap(
      '/api/v2/search/group_tab',
      query: {
        'q': keyword,
        'sort': sort,
        'start': start,
        'count': count,
      },
    );

    final groups = asList(asMap(data['groups'])['items'])
        .whereType<Map<String, dynamic>>()
        .map((e) => Group.fromJson(unwrapTarget(e)))
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
    final data = await _frodo.getMap(
      '/api/v2/search/group',
      query: {'q': keyword, 'start': start, 'count': count},
    );
    return parsePagedList<Group>(
      data,
      fromJson: (e) => Group.fromJson(unwrapTarget(e)),
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
    final data = await _frodo.getMap(
      '/api/v2/search/user',
      query: {'q': keyword, 'start': start, 'count': count},
    );
    return parsePagedList<Author>(
      data,
      fromJson: (e) => Author.fromJson(unwrapTarget(e)),
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
    final data = await _frodo.getMap(
      '/api/v2/group/$groupId/members',
      query: {'start': start, 'count': count, 'sortby': sortBy},
    );
    return parsePagedList<Author>(
      data,
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

  /// 关注小组（订阅更新但不成为成员，独立于「加入」）
  /// POST https://frodo.douban.com/api/v2/group/{group_id}/subscribe
  ///
  /// body 仅有签名字段 apikey/_sig/_ts，由 [AuthInterceptor] 自动塞进 multipart
  /// （故传一个空 [FormData] 让拦截器有 body 可写）。成功返回空对象。
  Future<void> subscribeGroup(String groupId) async {
    await _frodo.post<dynamic>(
      '/api/v2/group/$groupId/subscribe',
      data: FormData(),
    );
  }

  /// 取消关注小组
  /// POST https://frodo.douban.com/api/v2/group/{group_id}/unsubscribe
  Future<void> unsubscribeGroup(String groupId) async {
    await _frodo.post<dynamic>(
      '/api/v2/group/$groupId/unsubscribe',
      data: FormData(),
    );
  }

  /// 设置当前用户的置顶小组（全量覆盖）
  /// POST https://frodo.douban.com/api/v2/group/user/{user_id}/set_sticky_groups
  ///
  /// 注意：`group_ids` 不是增量，而是**每次都要传全部需要置顶的 id**。
  /// 因此「置顶」「取消置顶」都通过提交一份新的完整列表实现。
  /// 签名字段 apikey/_sig/_ts 由 [AuthInterceptor] 自动塞进 body。
  Future<void> setStickyGroups(String userId, List<String> groupIds) async {
    await _frodo.post<dynamic>(
      '/api/v2/group/user/$userId/set_sticky_groups',
      data: FormData.fromMap({'group_ids': groupIds.join(',')}),
    );
  }

  /// 在小组里发表讨论
  /// POST https://frodo.douban.com/api/v2/group/{group_id}/post
  ///
  /// `content` 是 DraftJS JSON 字符串（见 [encodeDraftBlocks]）；签名字段
  /// apikey/_sig/_ts 由 [AuthInterceptor] 自动塞进 multipart body。
  /// [blocks] 是**按显示顺序**排好的正文块（文字 / 图片 / 投票）：图片先经
  /// [uploadGroupImage] 拿到 id 再包成 [DraftImageBlock]，投票先经
  /// [TopicRepository.createPoll] 建好再包成 [DraftPollBlock]。`image_ids` /
  /// `image_titles` 由 [draftImageFields] 按同一套编号抽出。
  Future<Topic> createPost(
    String groupId, {
    required String title,
    required List<DraftBlock> blocks,
  }) async {
    final images = draftImageFields(blocks);
    final form = FormData();
    form.fields.addAll([
      MapEntry('title', title),
      MapEntry('content', encodeDraftBlocks(blocks)),
      MapEntry('original', '0'),
      MapEntry('image_ids', images.imageIds.join(',')),
      for (final t in images.imageTitles) MapEntry('image_titles', t),
    ]);
    final data = await _frodo.postMap(
      '/api/v2/group/$groupId/post',
      query: const {'timezone': 'GMT'},
      data: form,
    );
    return Topic.fromJson(data);
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
    final data = await _frodo.postMap(
      '/api/v2/group/$groupId/upload',
      data: form,
    );
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
    final data = await _frodo.getMap(
      '/api/v2/group/$groupId/search/topic',
      query: {
        'q': keyword,
        'cat': 1013,
        'sortby': sortBy,
        'start': start,
        'count': count,
      },
    );
    return parsePagedList<Topic>(
      data,
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
