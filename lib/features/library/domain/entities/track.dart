import 'package:json_annotation/json_annotation.dart';
import 'audio_quality.dart';

part 'track.g.dart';

@JsonSerializable()
class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.source,
    required this.duration,
    required this.isSaved,
    required this.availableQualities,
    this.thumbnailUrl,
    this.localPath,
  });

  final String id;
  final String title;
  final String artist;
  final String source;
  final Duration duration;
  final bool isSaved;
  final List<AudioQuality> availableQualities;
  final String? thumbnailUrl;
  final String? localPath;

  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? source,
    Duration? duration,
    bool? isSaved,
    List<AudioQuality>? availableQualities,
    String? thumbnailUrl,
    String? localPath,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      source: source ?? this.source,
      duration: duration ?? this.duration,
      isSaved: isSaved ?? this.isSaved,
      availableQualities: availableQualities ?? this.availableQualities,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      localPath: localPath ?? this.localPath,
    );
  }

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
  Map<String, dynamic> toJson() => _$TrackToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'source': source,
      'duration_ms': duration.inMilliseconds,
      'isSaved': isSaved ? 1 : 0,
      'thumbnailUrl': thumbnailUrl,
      'localPath': localPath,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      source: map['source'] as String,
      duration: Duration(milliseconds: map['duration_ms'] as int),
      isSaved: (map['isSaved'] as int) == 1,
      availableQualities: [], // Defaults to empty as we don't store qualities in SQLite for now
      thumbnailUrl: map['thumbnailUrl'] as String?,
      localPath: map['localPath'] as String?,
    );
  }
}
