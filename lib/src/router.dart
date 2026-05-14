import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pages/group/group.dart';
import 'pages/groups/groups.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/topic/topic.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomePage(),
        routes: [
          GoRoute(
            path: 'search',
            builder: (_, __) => const SearchPage(),
          ),
          GoRoute(
            path: 'groups',
            builder: (_, __) => const GroupsPage(),
          ),
          GoRoute(
            path: 'group/:id',
            builder: (_, state) => GroupPage(
              groupId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'topic/:topicId',
                builder: (_, state) => TopicPage(
                  topicId: state.pathParameters['topicId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'topic/:id',
            builder: (_, state) => TopicPage(
              topicId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
  );
});
