import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';
import '../../domain/entities/track.dart';

class AudioService {
  AudioService._internal();
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final _yt = YoutubeExplode();
  
  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;
  
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  Future<void> playTrack(Track track) async {
    try {
      _currentTrack = track;
      String? url;

      // Hybrid playback logic: Local File -> High-Quality Stream -> Standard Stream
      if (track.localPath != null && await File(track.localPath!).exists()) {
        url = track.localPath;
      } else if (track.source == 'YouTube') {
        // Extract stream URL from YouTube
        final manifest = await _yt.videos.streamsClient.getManifest(track.id);
        final audioStream = manifest.audioOnly.withHighestBitrate();
        url = audioStream.url.toString();
      } else {
        throw Exception('Source ${track.source} not supported for real playback yet');
      }

      if (url == null) throw Exception('Could not resolve audio source');

      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print('Error playing track: $e');
      rethrow;
    }
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);

  void dispose() {
    _player.dispose();
    _yt.close();
  }
}
