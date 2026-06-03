import 'dart:convert';

/// 把编辑器内容编码成豆瓣讨论所需的 DraftJS 富文本 JSON 字符串。
///
/// 接口 `POST /api/v2/group/{group_id}/post` 的 `content` 字段不是纯文本，而是
/// 一段 DraftJS 结构（`blocks` + `entityMap`）的 JSON 字符串：
/// - 正文按换行拆成多个 `unstyled` 段落块；
/// - 每张图片是一个 `atomic` 块（text 固定为单个空格），其 `entityRanges`
///   指向 `entityMap` 里同名的 `IMAGE` 实体。
///
/// 现在只用到纯文本；[images] 预留给后续"发图"功能。
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

/// 生成 `content` 字段的 JSON 字符串。
String encodeDraftContent(String text, {List<DraftImage> images = const []}) {
  final blocks = <Map<String, dynamic>>[
    for (final line in text.split('\n')) _textBlock(line),
  ];

  final entityMap = <String, dynamic>{};
  for (var i = 0; i < images.length; i++) {
    final key = '${i + 1}';
    blocks.add(_atomicBlock(key));
    entityMap[key] = _imageEntity(images[i]);
  }

  return jsonEncode(<String, dynamic>{
    'blocks': blocks,
    'entityMap': entityMap,
  });
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
