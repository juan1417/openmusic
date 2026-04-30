import '../../domain/entities/track.dart';
import '../../data/datasources/audio_service.dart';

class PlayTrackUseCase {
  final AudioService _audioService;

  PlayTrackUseCase(this._audioService);

  Future<void> execute(Track track) async {
    // The auro_service already implements the hybrid logic: local -> high quality -> standard.
    // Here we encapsulate it in a use case to allow for future business rules 
    // (e.g. checking for a subscription before high quality).
    await _audioService.playTrack(track);
  }
}
