import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'models/collection.dart';
import 'models/topic.dart';
import 'pages/accounts/accounts_page.dart';
import 'pages/doulist/doulist_page.dart';
import 'pages/group/group.dart';
import 'pages/group/group_search.dart';
import 'pages/group/sections/group_info.dart';
import 'pages/group/sections/members.dart';
import 'pages/groups/groups.dart';
import 'pages/groups/my_groups_page.dart';
import 'pages/login/login_page.dart';
import 'pages/post_editor/post_editor.dart';
import 'pages/saved/saved_page.dart';
import 'pages/search/search_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/topic/topic.dart';
import 'pages/user/user_list_page.dart';
import 'pages/user/user_page.dart';
import 'widgets/root_scaffold.dart';

GoRoute _topicSubRoute(String paramName) => GoRoute(
      path: 'topic/:$paramName',
      parentNavigatorKey: _rootKey,
      builder: (_, state) => TopicPage(
        topicId: state.pathParameters[paramName]!,
        seed: state.extra is Topic ? state.extra as Topic : null,
      ),
    );

final _rootKey = GlobalKey<NavigatorState>();
final _groupsBranchKey = GlobalKey<NavigatorState>();
final _searchBranchKey = GlobalKey<NavigatorState>();
final _savedBranchKey = GlobalKey<NavigatorState>();
final _meBranchKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: '/my-groups',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const MyGroupsPage(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/accounts',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AccountsPage(),
      ),
      GoRoute(
        path: '/user/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => UserPage(
          key: ValueKey(state.pathParameters['id']),
          userId: state.pathParameters['id'],
        ),
        routes: [
          GoRoute(
            path: 'following',
            parentNavigatorKey: _rootKey,
            builder: (_, state) => UserListPage(
              userId: state.pathParameters['id']!,
              kind: UserListKind.following,
            ),
          ),
          GoRoute(
            path: 'followers',
            parentNavigatorKey: _rootKey,
            builder: (_, state) => UserListPage(
              userId: state.pathParameters['id']!,
              kind: UserListKind.followers,
            ),
          ),
        ],
      ),
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
                  _topicSubRoute('id'),
                  GoRoute(
                    path: 'group/:id',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => GroupPage(
                      key: ValueKey(state.pathParameters['id']),
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
                        path: 'post',
                        parentNavigatorKey: _rootKey,
                        builder: (_, state) => PostEditorPage(
                          groupId: state.pathParameters['id']!,
                          groupName: state.extra is String
                              ? state.extra as String
                              : null,
                        ),
                      ),
                      GoRoute(
                        path: 'info',
                        parentNavigatorKey: _rootKey,
                        builder: (_, state) => GroupInfoPage(
                          groupId: state.pathParameters['id']!,
                        ),
                      ),
                      GoRoute(
                        path: 'members',
                        parentNavigatorKey: _rootKey,
                        builder: (_, state) => GroupMembersPage(
                          groupId: state.pathParameters['id']!,
                        ),
                      ),
                      GoRoute(
                        path: 'topic/:topicId',
                        parentNavigatorKey: _rootKey,
                        builder: (_, state) => TopicPage(
                          topicId: state.pathParameters['topicId']!,
                          showGroupLink: false,
                          seed: state.extra is Topic
                              ? state.extra as Topic
                              : null,
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
                  _topicSubRoute('id'),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _savedBranchKey,
            routes: [
              GoRoute(
                path: '/saved',
                builder: (_, __) => const SavedPage(),
                routes: [
                  _topicSubRoute('id'),
                  GoRoute(
                    path: 'doulist/:id',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => DoulistPage(
                      doulistId: state.pathParameters['id']!,
                      seed: state.extra is Doulist
                          ? state.extra as Doulist
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _meBranchKey,
            routes: [
              GoRoute(
                path: '/me',
                builder: (_, __) => const UserPage(),
                routes: [
                  _topicSubRoute('id'),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
