import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/audio_service.dart';
import '../../data/datasources/download_service.dart';
import '../../data/datasources/audio_processor.dart';
import '../../data/datasources/persistence_service.dart';
import '../../domain/usecases/play_track_usecase.dart';
import '../../domain/usecases/download_track_usecase.dart';
import '../../domain/entities/track.dart';

// --- Services Providers ---

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});

final downloadServiceProvider = Provider<DownloadService>((ref) {
  return DownloadService();
});

final audioProcessorProvider = Provider<AudioProcessor>((ref) {
  return AudioProcessor();
});

final persistenceProvider = Provider<LibraryPersistence>((ref) {
  return LibraryPersistence();
});

// --- Use Case Providers ---

final playTrackUseCaseProvider = Provider<PlayTrackUseCase>((ref) {
  return PlayTrackUseCase(ref.watch(audioServiceProvider));
});

final downloadTrackUseCaseProvider = Provider<DownloadTrackUseCase>((ref) {
  return DownloadTrackUseCase(
    ref.watch(downloadServiceProvider),
    ref.watch(audioProcessorProvider),
    ref.watch(persistenceProvider),
  );
});

// --- State Providers ---

final currentTrackProvider = StateProvider<Track?>((ref) {
  return null;
});
