import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../api/json_utils.dart';
import '../models/author.dart';
import '../models/group.dart';
import '../models/lifestream.dart';
import '../models/topic.dart';
import '../models/user.dart';

class UserRepository {
  UserRepository(this._frodo);

  final Dio _frodo;

  /// 用户信息
  /// GET https://frodo.douban.com/api/v2/user/{user_id}
  ///
  /// `basic_only=false`（默认）才返回关注/被关注数、广播数、IP 属地、头图等
  /// header 需要的字段；`basic_only=true` 只回账号身份基础信息。
  Future<User> fetchUser(String userId, {bool basicOnly = false}) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId',
      queryParameters: {'basic_only': basicOnly ? 'true' : 'false'},
    );
    return User.fromJson(asMap(res.data));
  }

  /// 用户创建的小组
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/owned_groups
  ///
  /// 与 joined_groups 不同，这里的列表项在 `items` 下，且是 Group 本体（无 target
  /// 包裹）。`popular` 控制排序，0 即默认。
  Future<List<Group>> fetchOwnedGroups(
    String userId, {
    int start = 0,
    int count = 50,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/owned_groups',
      queryParameters: {'popular': 0, 'start': start, 'count': count},
    );
    final data = asMap(res.data);
    return asList(data['items'] ?? data['groups'])
        .whereType<Map<String, dynamic>>()
        .map(Group.fromJson)
        .toList(growable: false);
  }

  /// 用户动态的时间分片列表
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/lifestream/timeslices
  ///
  /// 返回形如 `recent-2025-7` / `month-2025-6` / `year-2017` 的分片游标，按时间
  /// 从新到旧。空分片（`empty=true`，那段时间没内容）直接剔除，避免翻页空转。
  Future<List<String>> fetchLifestreamTimeslices(
    String userId, {
    bool articleOnly = false,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/lifestream/timeslices',
      queryParameters: {'article_only': articleOnly ? 'true' : 'false'},
    );
    final data = asMap(res.data);
    return asList(data['timeslices'])
        .whereType<Map<String, dynamic>>()
        .where((s) => s['empty'] != true)
        .map((s) => s['slice'] as String?)
        .whereType<String>()
        .toList(growable: false);
  }

  /// 某个时间分片内的用户动态
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/lifestream
  ///
  /// 分片内再用 `filter_after` 翻页：首次留空，之后取上一页返回的
  /// `next_filter_after`（unix 秒级时间戳）。返回 null 表示该分片已到底。
  Future<({List<LifestreamItem> items, String? nextFilterAfter})> fetchLifestream(
    String userId, {
    required String slice,
    String filterAfter = '',
    int count = 20,
    bool hot = false,
    bool articleOnly = false,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/lifestream',
      queryParameters: {
        'slice': slice,
        'count': count,
        'filter_after': filterAfter,
        'hot': hot ? 'true' : 'false',
        'article_only': articleOnly ? 'true' : 'false',
      },
    );
    final data = asMap(res.data);
    final items = <LifestreamItem>[];
    for (final raw in asList(data['items']).whereType<Map<String, dynamic>>()) {
      // 动态混排多种类型，个别项结构可能异于预期；单条解析失败就跳过，
      // 不连累整页。
      try {
        items.add(_parseLifestreamItem(raw));
      } catch (_) {
        continue;
      }
    }
    final next = data['next_filter_after']?.toString();
    return (
      items: items,
      nextFilterAfter: (next == null || next.isEmpty) ? null : next,
    );
  }

  /// 用户的关注列表
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/following
  ///
  /// 接口用一个大 `count` 一次返回整张列表（官方示例 count=2000），这里不分页，
  /// 直接全量取回交给列表懒加载渲染。
  Future<List<Author>> fetchFollowing(String userId, {int count = 2000}) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/following',
      queryParameters: {
        'count': count,
        'is_include_official_account': 'true',
        'start': 0,
      },
    );
    return _parseUsers(res.data);
  }

  /// 用户的被关注列表
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/followers
  Future<List<Author>> fetchFollowers(String userId, {int count = 2000}) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/followers',
      queryParameters: {'count': count, 'start': 0},
    );
    return _parseUsers(res.data);
  }

  List<Author> _parseUsers(Map<String, dynamic>? data) {
    return asList(asMap(data)['users'])
        .whereType<Map<String, dynamic>>()
        .map(Author.fromJson)
        .toList(growable: false);
  }
}

/// 把一条 lifestream item 拍平成可喂给 [TopicCard] 的 [LifestreamItem]。
///
/// 帖子正文在 `content`（含 author / photos / title / abstract），转评赞计数和
/// 类型在**外层**。没有标题的类型（广播等）用 abstract 兜标题，避免标题/正文重复。
LifestreamItem _parseLifestreamItem(Map<String, dynamic> item) {
  final content = asMap(item['content']);
  final title = (content['title'] as String?)?.trim();
  final abstract = (content['abstract'] as String?)?.trim();
  final hasTitle = title != null && title.isNotEmpty;

  final topic = Topic.fromJson(<String, dynamic>{
    ...content,
    'id': (content['id'] ?? item['id'] ?? '').toString(),
    'title': hasTitle ? title : (abstract ?? ''),
    'abstract': hasTitle ? abstract : null,
    'create_time': item['created_time'],
    'comments_count': item['comments_count'],
    'reactions_count': item['reactions_count'],
    'collections_count': item['collections_count'],
    'reshares_count': item['reshares_count'],
    'reaction_type': item['reaction_type'],
    'sharing_url': item['sharing_url'],
  });

  return LifestreamItem(
    topic: topic,
    type: item['type'] as String?,
    typeCn: item['type_cn'] as String?,
    uri: item['uri'] as String?,
    url: item['url'] as String?,
  );
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(dioProvider));
});
