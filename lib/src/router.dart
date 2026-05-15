import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pages/group/group.dart';
import 'pages/group/group_search.dart';
import 'pages/groups/groups.dart';
import 'pages/search/search_page.dart';
import 'pages/topic/topic.dart';
import 'widgets/root_scaffold.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _groupsBranchKey = GlobalKey<NavigatorState>();
final _searchBranchKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => RootScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _groupsBranchKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const GroupsPage(),
                routes: [
                  GoRoute(
                    path: 'group/:id',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => GroupPage(
                      groupId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'search',
                        parentNavigatorKey: _rootKey,
                        builder: (_, state) => GroupSearchPage(
                          groupId: state.pathParameters['id']!,
                        ),
                      ),
                      GoRoute(
                        path: 'topic/:topicId',
                        parentNavigatorKey: _rootKey,
                        builder: (_, state) => TopicPage(
                          topicId: state.pathParameters['topicId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _searchBranchKey,
            routes: [
              GoRoute(
                path: '/search',
                builder: (_, __) => const SearchPage(),
                routes: [
                  GoRoute(
                    path: 'topic/:id',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => TopicPage(
                      topicId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
