// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      source: json['source'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      isSaved: json['isSaved'] as bool,
      availableQualities: (json['availableQualities'] as List<dynamic>)
          .map((e) => $enumDecode(_$AudioQualityEnumMap, e))
          .toList(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      localPath: json['localPath'] as String?,
    );

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'source': instance.source,
      'duration': instance.duration.inMicroseconds,
      'isSaved': instance.isSaved,
      'availableQualities': instance.availableQualities
          .map((e) => _$AudioQualityEnumMap[e]!)
          .toList(),
      'thumbnailUrl': instance.thumbnailUrl,
      'localPath': instance.localPath,
    };

const _$AudioQualityEnumMap = {
  AudioQuality.flac: 'flac',
  AudioQuality.aac: 'aac',
  AudioQuality.wav: 'wav',
};
