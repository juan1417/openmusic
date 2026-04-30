import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../presentation/providers/library_providers.dart';
import '../../domain/entities/track.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioService = ref.watch(audioServiceProvider);
    final currentTrack = audioService.currentTrack;

    if (currentTrack == null) {
      return const Scaffold(
        body: Center(child: Text('No track selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Now Playing'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Options like add to playlist, view artist, etc.
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album Art
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: currentTrack.thumbnailUrl != null
                    ? Image.network(currentTrack.thumbnailUrl!, fit: BoxFit.cover)
                    : Container(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: const Icon(Icons.music_note, size: 100),
                      ),
              ),
            ),
            const SizedBox(height: 40),
            // Track Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTrack.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentTrack.artist,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white70,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    currentTrack.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: currentTrack.isSaved ? Colors.green : null,
                  ),
                  onPressed: () {
                    // Save/Unsave logic
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Seek Bar
            StreamBuilder<Duration>(
              stream: audioService.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: audioService.durationStream,
                  builder: (context, durationSnapshot) {
                    final duration = durationSnapshot.data ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          value: position.inMilliseconds.toDouble(),
                          max: duration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            audioService.seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(position)),
                              Text(_formatDuration(duration)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle, size: 28),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 48),
                  onPressed: () {},
                ),
                StreamBuilder<PlayerState>(
                  stream: audioService.playerStateStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data?.playing ?? false;
                    return IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 80,
                      ),
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
                  icon: const Icon(Icons.skip_next, size: 48),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.repeat, size: 28),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
