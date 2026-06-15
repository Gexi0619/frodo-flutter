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
    @JsonKey(name: 'edit_time') String? editTime,
    @JsonKey(name: 'ip_location') String? ipLocation,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'collections_count') int? collectionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    @JsonKey(name: 'reaction_type') @Default(0) int reactionType,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'image_layout') String? imageLayout,
    @Default(<TopicPhoto>[]) List<TopicPhoto> photos,
    @JsonKey(name: 'video_info') TopicVideoInfo? videoInfo,
    Author? author,
    Group? group,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}

@freezed
class TopicPhoto with _$TopicPhoto {
  const factory TopicPhoto({
    String? id,
    String? title,
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
    @JsonKey(name: 'is_live') @Default(false) bool isLive,
    @JsonKey(name: 'is_animated') @Default(false) bool isAnimated,
    TopicVideo? video,
  }) = _TopicPhotoImages;

  factory TopicPhotoImages.fromJson(Map<String, dynamic> json) =>
      _$TopicPhotoImagesFromJson(json);
}

/// 讨论自带的上传视频（顶层 `video_info`）。区别于 live 图 / 动图（[TopicVideo]）
/// 与 B 站外链（content 内的 `video-wrapper`）：这是豆瓣 CDN 上的原生 mp4，
/// 带封面、时长与审核状态。
@freezed
class TopicVideoInfo with _$TopicVideoInfo {
  const factory TopicVideoInfo({
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    String? duration,
    @JsonKey(name: 'video_width') int? width,
    @JsonKey(name: 'video_height') int? height,
    /// 审核/播放状态：0 表示尚不可公开播放（配合 [alertText] 提示）。
    @JsonKey(name: 'play_status') @Default(0) int playStatus,
    @JsonKey(name: 'alert_text') String? alertText,
    @JsonKey(name: 'is_aigc') @Default(false) bool isAigc,
  }) = _TopicVideoInfo;

  factory TopicVideoInfo.fromJson(Map<String, dynamic> json) =>
      _$TopicVideoInfoFromJson(json);
}

/// Live 图 / 动图对应的 mp4 视频源。
@freezed
class TopicVideo with _$TopicVideo {
  const factory TopicVideo({
    String? url,
    int? width,
    int? height,
    @JsonKey(name: 'has_audio') @Default(false) bool hasAudio,
  }) = _TopicVideo;

  factory TopicVideo.fromJson(Map<String, dynamic> json) =>
      _$TopicVideoFromJson(json);
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
