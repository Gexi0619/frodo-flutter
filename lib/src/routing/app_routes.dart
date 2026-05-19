abstract class AppRoutes {
  static String settings() => '/settings';
  static String topic(String id) => '/topic/$id';
  static String group(String id) => '/group/$id';
  static String groupSearch(String groupId) => '/group/$groupId/search';
  static String groupTopic(String groupId, String topicId) =>
      '/group/$groupId/topic/$topicId';
  static String search() => '/search';
  static String searchTopic(String id) => '/search/topic/$id';
  static String savedTopic(String id) => '/saved/topic/$id';
}
