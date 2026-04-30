import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../library/data/datasources/audio_service.dart';
import '../../library/domain/entities/track.dart';
import '../../library/presentation/providers/library_providers.dart';
import '../../library/presentation/pages/player_screen.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioService = ref.watch(audioServiceProvider);

    return StreamBuilder<void>(
      stream: audioService.playerStateStream,
      builder: (context, _) {
        final track = audioService.currentTrack;
        if (track == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            );
          },
          child: Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: track.thumbnailUrl != null
                    ? Image.network(track.thumbnailUrl!, width: 50, height: 50, fit: BoxFit.cover)
                    : Container(width: 50, height: 50, color: Colors.grey, child: const Icon(Icons.music_note)),
              ),
              title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(track.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<bool>(
                    stream: audioService.playerStateStream.map((state) => state.playing),
                    builder: (context, playingSnapshot) {
                      final isPlaying = playingSnapshot.data ?? false;
                      return IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          if (isPlaying) {
                            audioService.pause();
                          } else {
                            audioService.resume();
                          }
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: () => audioService.stop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
