import 'dart:convert';

/// 把编辑器内容编码成豆瓣讨论所需的 DraftJS 富文本 JSON 字符串。
///
/// 接口 `POST /api/v2/group/{group_id}/post` 的 `content` 字段不是纯文本，而是
/// 一段 DraftJS 结构（`blocks` + `entityMap`）的 JSON 字符串：
/// - 正文按换行拆成多个 `unstyled` 段落块；
/// - 每张图片是一个 `atomic` 块（text 固定为单个空格），其 `entityRanges`
///   指向 `entityMap` 里同名的 `IMAGE` 实体；
/// - 投票同样是一个 `atomic` 块，指向 `entityMap` 里的 `POLL` 实体
///   （`data` 只含 `{id, title}`，投票本体先经 `createPoll` 建好拿到 id）。
class DraftImage {
  const DraftImage({
    required this.id,
    required this.src,
    required this.width,
    required this.height,
    this.caption = '',
    this.isAnimated = false,
  });

  /// 上传接口返回的图片 id（如 "734483314"）。
  final String id;

  /// 图片地址（上传返回的 src / raw_src）。
  final String src;
  final int width;
  final int height;

  /// 图片描述，可空串。
  final String caption;
  final bool isAnimated;
}

/// 正文内嵌投票的引用。投票本体先经 `TopicRepository.createPoll` 建好，
/// 拿到 [id] / [title] 后再以 `POLL` 实体嵌进正文。
class DraftPoll {
  const DraftPoll({required this.id, required this.title});

  /// createPoll 返回的投票 id。
  final String id;

  /// 投票标题（展示用，DraftJS 实体里也要带上）。
  final String title;
}

/// 正文里一个**按顺序**排列的块。DraftJS 的 `blocks` 数组顺序 = 页面上从上到下
/// 的显示顺序，所以块编辑器里怎么拖，这里就怎么排。
sealed class DraftBlock {
  const DraftBlock();
}

/// 一段文字（内部可含 `\n`，会再拆成多个 `unstyled` 段落块）。
class DraftText extends DraftBlock {
  const DraftText(this.text);
  final String text;
}

/// 一张图片（`atomic` + `IMAGE` 实体）。
class DraftImageBlock extends DraftBlock {
  const DraftImageBlock(this.image);
  final DraftImage image;
}

/// 一个投票（`atomic` + `POLL` 实体）。
class DraftPollBlock extends DraftBlock {
  const DraftPollBlock(this.poll);
  final DraftPoll poll;
}

/// 把有序块列表编码成 `content` 字段的 JSON 字符串。
///
/// 按 [blocks] 顺序逐个 emit：文字块拆成若干 `unstyled` 段落；图片/投票块各是
/// 一个 `atomic` 块，其 `entityRanges` 指向 `entityMap` 里同名 key。key 按遇到的
/// **atomic 块**（图片或投票）顺序从 1 递增——[createPost] 拼 `image_ids` 时用
/// 的是同一套编号，二者必须一致。
String encodeDraftBlocks(List<DraftBlock> blocks) {
  final out = <Map<String, dynamic>>[];
  final entityMap = <String, dynamic>{};
  var entityKey = 0;
  for (final block in blocks) {
    switch (block) {
      case DraftText(:final text):
        for (final line in text.split('\n')) {
          out.add(_textBlock(line));
        }
      case DraftImageBlock(:final image):
        final key = '${++entityKey}';
        out.add(_atomicBlock(key));
        entityMap[key] = _imageEntity(image);
      case DraftPollBlock(:final poll):
        final key = '${++entityKey}';
        out.add(_atomicBlock(key));
        entityMap[key] = _pollEntity(poll);
    }
  }
  return jsonEncode(<String, dynamic>{
    'blocks': out,
    'entityMap': entityMap,
  });
}

/// 与 [encodeDraftBlocks] 用同一套编号，抽出图片块的 `image_ids`（`序号_图片id`）
/// 与 `image_titles`（描述），供 [createPost] 拼 multipart 字段。
({List<String> imageIds, List<String> imageTitles}) draftImageFields(
  List<DraftBlock> blocks,
) {
  final ids = <String>[];
  final titles = <String>[];
  var entityKey = 0;
  for (final block in blocks) {
    if (block is DraftImageBlock || block is DraftPollBlock) entityKey++;
    if (block is DraftImageBlock) {
      ids.add('${entityKey}_${block.image.id}');
      titles.add(block.image.caption);
    }
  }
  return (imageIds: ids, imageTitles: titles);
}

Map<String, dynamic> _textBlock(String text) => <String, dynamic>{
      'data': null,
      'depth': 0,
      'entityRanges': const [],
      'inlineStyleRanges': const [],
      'key': '',
      'text': text,
      'type': 'unstyled',
    };

Map<String, dynamic> _atomicBlock(String entityKey) => <String, dynamic>{
      'data': null,
      'depth': 0,
      'entityRanges': [
        {'key': entityKey, 'length': 1, 'offset': 0},
      ],
      'inlineStyleRanges': const [],
      'key': '',
      'text': ' ',
      'type': 'atomic',
    };

Map<String, dynamic> _imageEntity(DraftImage img) => <String, dynamic>{
      'data': {
        'caption': img.caption,
        'height': img.height,
        'id': img.id,
        'is_animated': img.isAnimated,
        'origin': false,
        'raw_src': img.src,
        'src': img.src,
        'water_mark': '',
        'width': img.width,
      },
      'mutability': 'MUTABLE',
      'type': 'IMAGE',
    };

Map<String, dynamic> _pollEntity(DraftPoll poll) => <String, dynamic>{
      'data': {'id': poll.id, 'title': poll.title},
      'mutability': 'MUTABLE',
      'type': 'POLL',
    };
