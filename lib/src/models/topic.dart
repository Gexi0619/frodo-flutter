import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';
import 'group.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

/// 小组讨论贴。
@freezed
class Topic with _$Topic {
  const factory Topic({
    required String id,
    required String title,
    String? abstract,
    String? content,
    @JsonKey(name: 'create_time') String? createTime,
    @JsonKey(name: 'update_time') String? updateTime,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'collections_count') int? collectionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @Default(<TopicPhoto>[]) List<TopicPhoto> photos,
    Author? author,
    Group? group,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}

@freezed
class TopicPhoto with _$TopicPhoto {
  const factory TopicPhoto({
    String? id,
    @JsonKey(name: 'image') TopicPhotoImages? images,
  }) = _TopicPhoto;

  factory TopicPhoto.fromJson(Map<String, dynamic> json) =>
      _$TopicPhotoFromJson(json);
}

@freezed
class TopicPhotoImages with _$TopicPhotoImages {
  const factory TopicPhotoImages({
    TopicImage? large,
    TopicImage? normal,
    TopicImage? raw,
  }) = _TopicPhotoImages;

  factory TopicPhotoImages.fromJson(Map<String, dynamic> json) =>
      _$TopicPhotoImagesFromJson(json);
}

@freezed
class TopicImage with _$TopicImage {
  const factory TopicImage({
    String? url,
    int? width,
    int? height,
    int? size,
  }) = _TopicImage;

  factory TopicImage.fromJson(Map<String, dynamic> json) =>
      _$TopicImageFromJson(json);
}
