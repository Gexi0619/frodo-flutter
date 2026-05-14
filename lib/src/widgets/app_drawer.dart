import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _destinations = <_DrawerDestination>[
    _DrawerDestination(path: '/', icon: Icons.home_outlined, selectedIcon: Icons.home, label: '首页'),
    _DrawerDestination(path: '/groups', icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: '小组'),
    _DrawerDestination(path: '/search', icon: Icons.search_outlined, selectedIcon: Icons.search, label: '搜索'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selected = _destinations.indexWhere((d) => _isSelected(location, d.path));

    return NavigationDrawer(
      selectedIndex: selected < 0 ? null : selected,
      onDestinationSelected: (i) {
        Navigator.of(context).pop();
        final target = _destinations[i].path;
        if (!_isSelected(location, target)) context.go(target);
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
          child: Text('Frodo', style: Theme.of(context).textTheme.titleLarge),
        ),
        for (final d in _destinations)
          NavigationDrawerDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: Text(d.label),
          ),
      ],
    );
  }

  static bool _isSelected(String location, String path) {
    if (path == '/') return location == '/';
    return location == path || location.startsWith('$path/');
  }
}

class _DrawerDestination {
  const _DrawerDestination({
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
