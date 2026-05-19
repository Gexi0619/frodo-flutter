abstract class AppRoutes {
  static String settings() => '/settings';
  static String topic(String id) => '/topic/$id';
  static String group(String id) => '/group/$id';
  static String groupInfo(String id) => '/group/$id/info';
  static String groupMembers(String id) => '/group/$id/members';
  static String groupSearch(String groupId) => '/group/$groupId/search';
  static String groupTopic(String groupId, String topicId) =>
      '/group/$groupId/topic/$topicId';
  static String search() => '/search';
  static String searchTopic(String id) => '/search/topic/$id';
  static String savedTopic(String id) => '/saved/topic/$id';
  static String doulist(String id) => '/saved/doulist/$id';
}
