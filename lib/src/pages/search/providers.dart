import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/topic_card.dart';

final searchKeywordProvider = StateProvider<String>((_) => '');

// 搜索结果中讨论的展示模式（综合和实时两个 tab 共用）
final searchTopicsViewModeProvider =
    StateProvider<TopicFeedViewMode>((_) => TopicFeedViewMode.compact);
