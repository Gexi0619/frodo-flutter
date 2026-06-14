import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/topic_card.dart';

final searchKeywordProvider = StateProvider<String>((_) => '');

// 综合 tab 里讨论列表的展示模式（切换器在「讨论」分区标题右侧）
final searchTopicsViewModeProvider =
    StateProvider<TopicFeedViewMode>((_) => TopicFeedViewMode.compact);

// 实时 tab 的展示模式，切换器收进 TabBar 的「实时」tab 下拉里。
// 默认动态视图（卡片模式）。
final searchRealtimeViewModeProvider =
    StateProvider<TopicFeedViewMode>((_) => TopicFeedViewMode.card);
