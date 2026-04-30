import '../../domain/entities/track.dart';
import '../../data/datasources/download_service.dart';
import '../../data/datasources/audio_processor.dart';
import '../../data/datasources/persistence_service.dart';

class DownloadTrackUseCase {
  final DownloadService _downloadService;
  final AudioProcessor _audioProcessor;
  final LibraryPersistence _persistence;

  DownloadTrackUseCase(
    this._downloadService,
    this._audioProcessor,
    this._persistence,
  );

  Future<void> execute(Track track, {Function(double progress)? onProgress}) async {
    try {
      // 1. Download the raw file from YouTube
      final rawPath = await _downloadService.downloadTrack(
        track, 
        onProgress: onProgress,
      );

      // 2. Optimize the audio (Transcode to FLAC/High Quality)
      final optimizedPath = await _audioProcessor.optimizeAudio(rawPath, format: 'flac');
      
      if (optimizedPath == null) {
        throw Exception('Optimization failed. Keeping original format.');
      }

      // 3. Update track entity with local path
      final updatedTrack = track.copyWith(localPath: optimizedPath);

      // 4. Persist the update in the database
      await _persistence.saveTrack(updatedTrack);
    } catch (e) {
      throw Exception('Download and optimization failed: $e');
    }
  }
}
