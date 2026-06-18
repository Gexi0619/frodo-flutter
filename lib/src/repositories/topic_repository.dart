import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../api/json_utils.dart';
import '../models/collection.dart';
import '../models/comment.dart';
import '../models/doulist_post.dart';
import '../models/paged.dart';
import '../models/poll.dart';
import '../models/reaction.dart';
import '../models/reshare.dart';
import '../models/topic.dart';

class TopicRepository {
  TopicRepository(this._frodo);

  final Dio _frodo;

  /// 讨论详情
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}
  Future<Topic> fetchTopic(String topicId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId',
    );
    final data = res.data ??
        (throw StateError('empty response for topic $topicId'));
    return Topic.fromJson(data);
  }

  /// 讨论评论列表
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/comments
  /// [opOnly] = true 时改走 /op_comments，只看楼主；该接口不支持 nested。
  /// 返回的 [popular] 仅在 start=0 时由服务端附带（最多 5 条热评），
  /// 其余情况为空列表。
  Future<({Paged<Comment> page, List<Comment> popular})> fetchComments(
    String topicId, {
    int start = 0,
    int count = 30,
    String? orderBy,
    bool opOnly = false,
  }) async {
    // ── 正序 vs 倒序的关键区别（经实测确认）──────────────────────────────
    // 正序 (nested=1)：
    //   服务端把楼中楼回复嵌入各自父评论的 replies[] 字段，主列表只含顶层评论。
    //   回复的 ref_comment.id == parent_comment_id（因为直接回复父楼），
    //   楼中楼内容需用户点击后通过 /replies 接口单独获取。
    //
    // 倒序 (order_by=time_desc)：
    //   服务端返回扁平列表，顶层评论和回复混排，回复作为独立 Comment 出现，
    //   携带 ref_comment 但 parent_comment_id 为 null，引用块可直接显示。
    //
    // nested=1 与 order_by 互斥，带 nested=1 时服务端会忽略 order_by。
    // 只看楼主模式不支持 nested，正/倒序统一用 order_by。
    final isDesc = orderBy == 'time_desc';
    final path = opOnly
        ? '/api/v2/group/topic/$topicId/op_comments'
        : '/api/v2/group/topic/$topicId/comments';
    final res = await _frodo.get<Map<String, dynamic>>(
      path,
      queryParameters: {
        'start': start,
        'count': count,
        if (opOnly)
          'order_by': isDesc ? 'time_desc' : 'time_asc'
        else if (isDesc)
          'order_by': 'time_desc'
        else
          'nested': 1,
      },
    );
    final data = asMap(res.data);
    final page = parsePagedList<Comment>(
      data,
      itemsKeys: const ['comments', 'items'],
      fromJson: Comment.fromJson,
      fallbackStart: start,
    );
    final popular = asList(data['popular_comments'])
        .whereType<Map<String, dynamic>>()
        .map(Comment.fromJson)
        .toList(growable: false);
    return (page: page, popular: popular);
  }

  /// 发表评论 / 回复评论
  /// POST https://frodo.douban.com/api/v2/group/topic/{topic_id}/create_comment
  /// 传 [refCid] 为回复，传 [imagePath] 为带图（自动切 multipart，并放宽超时）。
  Future<Comment> createComment(
    String topicId,
    String text, {
    String? refCid,
    String? imagePath,
  }) async {
    final fields = <String, dynamic>{
      'text': text,
      'nested': '1',
      'is_origin': '0',
      if (refCid != null && refCid.isNotEmpty) 'ref_cid': refCid,
    };

    final Object data;
    final Options options;
    if (imagePath case final String path when path.isNotEmpty) {
      data = FormData.fromMap({
        ...fields,
        'image': await MultipartFile.fromFile(
          path,
          filename: path.split('/').last,
          contentType: DioMediaType.parse(_mimeFromPath(path)),
        ),
      });
      // 图片上传放宽 send/receiveTimeout；服务端处理图片耗时较长。
      options = Options(
        sendTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      );
    } else {
      data = fields;
      options = Options(contentType: Headers.formUrlEncodedContentType);
    }

    final res = await _frodo.post<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/create_comment',
      data: data,
      options: options,
    );
    return Comment.fromJson(asMap(res.data));
  }

  /// 点赞 / 取消点赞
  /// POST https://frodo.douban.com/api/v2/group/topic/{topic_id}/react
  /// reactionType: 1 = 点赞，0 = 取消点赞
  Future<({int reactionType, int reactionsCount})> reactTopic(
    String topicId,
    int reactionType,
  ) async {
    final res = await _frodo.post<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/react',
      data: {'reaction_type': reactionType},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    final data = asMap(res.data);
    return (
      reactionType: (data['reaction_type'] as int?) ?? reactionType,
      reactionsCount: (data['reactions_count'] as int?) ?? 0,
    );
  }

  /// 讨论点赞列表
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/reactions
  Future<Paged<Reaction>> fetchReactions(
    String topicId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/reactions',
      queryParameters: {
        'start': start,
        'count': count,
        'reaction_type': 1,
      },
    );
    return parsePagedList<Reaction>(
      asMap(res.data),
      fromJson: Reaction.fromJson,
      fallbackStart: start,
    );
  }

  /// 讨论收藏列表
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/collections
  Future<Paged<Collection>> fetchCollections(
    String topicId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/collections',
      queryParameters: {'start': start, 'count': count},
    );
    return parsePagedList<Collection>(
      asMap(res.data),
      fromJson: Collection.fromJson,
      fallbackStart: start,
    );
  }

  /// 用户自己创建的豆列
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/owned_doulists
  Future<List<Doulist>> fetchOwnedDoulists(String userId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/owned_doulists',
      queryParameters: {'start': 0, 'count': 100},
    );
    final list = asList(asMap(res.data)['doulists']);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Doulist.fromJson)
        .toList(growable: false);
  }

  /// 用户关注的豆列
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/following_doulists
  Future<List<Doulist>> fetchFollowingDoulists(String userId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/following_doulists',
      queryParameters: {'start': 0, 'count': 100},
    );
    final list = asList(asMap(res.data)['doulists']);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Doulist.fromJson)
        .toList(growable: false);
  }

  /// 豆列动态（用户收录的帖子流）
  /// GET https://frodo.douban.com/api/v2/doulist/user/{user_id}/posts?sub_type=others
  Future<Paged<DoulistPost>> fetchDoulistPosts(
    String userId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/doulist/user/$userId/posts',
      queryParameters: {'sub_type': 'others', 'start': start, 'count': count},
    );
    return parsePagedList<DoulistPost>(
      asMap(res.data),
      fromJson: DoulistPost.fromJson,
      fallbackStart: start,
    );
  }

  /// 搜索收藏的豆列条目（「我的收藏」内搜索）
  /// GET https://frodo.douban.com/api/v2/search/doulist_items?q=...
  Future<Paged<DoulistPost>> searchDoulistItems(
    String query, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/search/doulist_items',
      queryParameters: {'q': query, 'start': start, 'count': count},
    );
    return parsePagedList<DoulistPost>(
      asMap(res.data),
      fromJson: DoulistPost.fromJson,
      fallbackStart: start,
    );
  }

  /// 编辑帖子的收藏语
  /// POST https://frodo.douban.com/api/v2/doulist/{doulist_id}/item/{item_id}/comment
  /// 返回更新后的收藏语。
  Future<String> editDoulistItemComment(
    String doulistId,
    String itemId,
    String comment,
  ) async {
    final res = await _frodo.post<Map<String, dynamic>>(
      '/api/v2/doulist/$doulistId/item/$itemId/comment',
      data: {'comment': comment},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return (asMap(res.data)['comment'] as String?) ?? comment;
  }

  /// 用户可将该帖子收录的豆列（即当前用户自己的小组豆列）
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/available_doulists
  Future<Paged<Doulist>> fetchAvailableDoulists(
    String topicId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/available_doulists',
      queryParameters: {'start': start, 'count': count},
    );
    return parsePagedList<Doulist>(
      asMap(res.data),
      itemsKeys: const ['doulists'],
      fromJson: Doulist.fromJson,
      fallbackStart: start,
    );
  }

  /// 豆列详情
  /// GET https://frodo.douban.com/api/v2/doulist/{doulist_id}
  Future<Doulist> fetchDoulistDetail(String doulistId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/doulist/$doulistId',
    );
    return Doulist.fromJson(asMap(res.data));
  }

  /// 豆列下的帖子列表
  /// GET https://frodo.douban.com/api/v2/doulist/{doulist_id}/posts
  Future<Paged<DoulistPost>> fetchDoulistItems(
    String doulistId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/doulist/$doulistId/posts',
      queryParameters: {'start': start, 'count': count, 'undone': 'false'},
    );
    return parsePagedList<DoulistPost>(
      asMap(res.data),
      fromJson: DoulistPost.fromJson,
      fallbackStart: start,
    );
  }

  /// 评论楼中楼列表
  /// GET https://frodo.douban.com/api/v2/group/topic/comment/{comment_id}/replies
  Future<Paged<Comment>> fetchCommentReplies(
    String commentId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/comment/$commentId/replies',
      queryParameters: {'start': start, 'count': count},
    );
    final data = asMap(res.data);
    final raw = asList(data['replies']);
    final items = raw
        .whereType<Map<String, dynamic>>()
        .map(Comment.fromJson)
        .toList(growable: false);
    return Paged<Comment>(
      items: items,
      start: (data['start'] as int?) ?? start,
      count: count,
      total: 0,
      // 接口不返回 total，以收到满页为依据判断是否还有更多。
      hasMore: items.length >= count,
    );
  }

  /// 点赞评论
  /// POST https://frodo.douban.com/api/v2/group/topic/{topic_id}/vote_comment
  /// 返回 true 表示成功；false 表示评论已删除或已点赞（接口不区分）。
  Future<bool> voteComment(String topicId, String commentId) async {
    final res = await _frodo.post<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/vote_comment',
      data: {'comment_id': commentId},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return (asMap(res.data)['result'] as bool?) ?? false;
  }

  /// 收藏讨论到豆列
  /// POST https://frodo.douban.com/api/v2/group/topic/{topic_id}/collect
  Future<void> collectTopic(String topicId, String doulistId) async {
    await _frodo.post<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/collect',
      data: {'doulist_id': doulistId},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  /// 取消收藏讨论
  /// POST https://frodo.douban.com/api/v2/group/topic/{topic_id}/uncollect
  Future<void> uncollectTopic(String topicId, String doulistId) async {
    await _frodo.post<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/uncollect',
      data: {'doulist_id': doulistId},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  /// 投票详情
  /// GET https://frodo.douban.com/api/v2/ceorl/poll/{poll_id}
  /// 即便未投票也会返回各选项票数与正确答案。
  Future<Poll> fetchPoll(String pollId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/ceorl/poll/$pollId',
    );
    return Poll.fromJson(asMap(res.data));
  }

  /// 执行投票
  /// POST https://frodo.douban.com/api/v2/ceorl/poll/{poll_id}/vote
  /// 多选时 option_ids 用逗号隔开。返回投票后的最新详情。
  Future<Poll> votePoll(String pollId, List<String> optionIds) async {
    final res = await _frodo.post<Map<String, dynamic>>(
      '/api/v2/ceorl/poll/$pollId/vote',
      data: {'option_ids': optionIds.join(',')},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return Poll.fromJson(asMap(res.data));
  }

  /// 讨论转发列表
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/resharers_statuses
  Future<Paged<Reshare>> fetchResharers(
    String topicId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/resharers_statuses',
      queryParameters: {'start': start, 'count': count},
    );
    return parsePagedList<Reshare>(
      asMap(res.data),
      fromJson: Reshare.fromJson,
      fallbackStart: start,
    );
  }
}

final topicRepositoryProvider = Provider<TopicRepository>((ref) {
  return TopicRepository(ref.watch(dioProvider));
});

String _mimeFromPath(String path) =>
    switch (path.toLowerCase().split('.').last) {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'heic' || 'heif' => 'image/heic',
      _ => 'image/jpeg',
    };
