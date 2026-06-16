abstract class AppRoutes {
  static String settings() => '/settings';
  static String myGroups() => '/my-groups';
  static String user(String id) => '/user/$id';
  static String userFollowing(String id) => '/user/$id/following';
  static String userFollowers(String id) => '/user/$id/followers';
  static String topic(String id) => '/topic/$id';
  static String group(String id) => '/group/$id';
  static String groupInfo(String id) => '/group/$id/info';
  static String groupMembers(String id) => '/group/$id/members';
  static String groupSearch(String groupId) => '/group/$groupId/search';
  static String groupPost(String groupId) => '/group/$groupId/post';
  static String groupTopic(String groupId, String topicId) =>
      '/group/$groupId/topic/$topicId';
  static String chat(String cid) => '/messages/chat/$cid';
  static String search() => '/search';
  static String searchTopic(String id) => '/search/topic/$id';
  static String doulist(String id) => '/doulist/$id';
  static String meDoulists() => '/me/doulists';
  static String meCollections() => '/me/collections';
  static String mePosted() => '/me/posted';
  static String meReplied() => '/me/replied';
}
