import '../../domain/entities/audio_quality.dart';
import '../../domain/entities/track.dart';

const mockTracks = <Track>[
  Track(
    id: '1',
    title: 'Midnight City',
    artist: 'Atlas Echo',
    source: 'YouTube',
    duration: Duration(minutes: 3, seconds: 42),
    isSaved: true,
    availableQualities: [AudioQuality.aac],
    thumbnailUrl: null,
  ),
  Track(
    id: '2',
    title: 'Blue Horizon',
    artist: 'Nova Lane',
    source: 'Owned library',
    duration: Duration(minutes: 4, seconds: 18),
    isSaved: false,
    availableQualities: [AudioQuality.flac, AudioQuality.aac, AudioQuality.wav],
    thumbnailUrl: null,
  ),
  Track(
    id: '3',
    title: 'Afterglow',
    artist: 'Neon Harbor',
    source: 'YouTube',
    duration: Duration(minutes: 2, seconds: 57),
    isSaved: false,
    availableQualities: [AudioQuality.aac],
    thumbnailUrl: null,
  ),
  Track(
    id: '4',
    title: 'Signal Fade',
    artist: 'Luma Grid',
    source: 'Owned library',
    duration: Duration(minutes: 5, seconds: 4),
    isSaved: true,
    availableQualities: [AudioQuality.flac, AudioQuality.aac],
    thumbnailUrl: null,
  ),
];
