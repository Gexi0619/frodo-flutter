import 'package:flutter/material.dart';

import 'sections/doulists.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  static const _tabs = [
    Tab(text: '豆列'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('收藏'),
          bottom: const TabBar(tabs: _tabs),
        ),
        body: const TabBarView(
          children: [
            SavedDoulists(),
          ],
        ),
      ),
    );
  }
}
