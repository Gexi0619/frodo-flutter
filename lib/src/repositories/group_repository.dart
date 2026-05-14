import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../models/group.dart';
import '../models/topic.dart';

List<dynamic> _asList(dynamic v) => v is List ? v : const [];

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
    final data = res.data ?? const <String, dynamic>{};

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
    final data = res.data ?? const <String, dynamic>{};
    final list = _asList(data['groups'] ?? data['items']);
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
    final data = res.data ?? const <String, dynamic>{};
    final groupsRaw = _asList(data['groups']);
    final groups = groupsRaw
        .whereType<Map<String, dynamic>>()
        .map(Group.fromJson)
        .toList(growable: false);
    return Paged<Group>(
      items: groups,
      total: (data['total'] as int?) ?? groups.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? groups.length,
    );
  }

  /// 小组详情
  /// GET https://frodo.douban.com/api/v2/group/{group_id}
  Future<Group> fetchDetail(String groupId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId',
    );
    final data = res.data ?? (throw StateError('empty response for group $groupId'));
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
    final data = res.data ?? const <String, dynamic>{};
    final topicsRaw = _asList(data['topics']);
    final topics = topicsRaw
        .whereType<Map<String, dynamic>>()
        .map(Topic.fromJson)
        .toList(growable: false);
    return Paged<Topic>(
      items: topics,
      total: (data['total'] as int?) ?? topics.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? topics.length,
    );
  }

  /// 搜索小组讨论
  /// GET /api/v2/search/group_tab?q=...&start=0&count=30
  Future<Paged<Topic>> searchTopics(
    String keyword, {
    int start = 0,
    int count = 30,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/search/group_tab',
      queryParameters: {
        'q': keyword,
        'start': start,
        'count': count,
      },
    );
    final data = res.data ?? const <String, dynamic>{};
    // 响应中讨论结果在 topics 节点的 items 里
    final topicsRaw = data['topics'];
    final topicsBlock = topicsRaw is Map<String, dynamic> ? topicsRaw : const <String, dynamic>{};
    final itemsRaw = _asList(topicsBlock['items']);
    final topics = itemsRaw
        .whereType<Map<String, dynamic>>()
        .map((e) {
          // search_group_tab 把 topic 包在 target 字段里
          final target = e['target'];
          if (target is Map<String, dynamic>) {
            return Topic.fromJson(target);
          }
          return Topic.fromJson(e);
        })
        .toList(growable: false);
    return Paged<Topic>(
      items: topics,
      total: (topicsBlock['total'] as int?) ?? topics.length,
      start: (topicsBlock['start'] as int?) ?? start,
      count: (topicsBlock['count'] as int?) ?? topics.length,
    );
  }
}

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    ref.watch(dioProvider),
    ref.watch(rexxarDioProvider),
  );
});
