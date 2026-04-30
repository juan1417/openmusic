import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/library_providers.dart';
import '../../domain/entities/track.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    // We can trigger a refresh here if needed
  }

  @override
  Widget build(BuildContext context) {
    final persistence = ref.watch(persistenceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Library'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Track>>(
        future: persistence.getSavedTracks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error loading library: ${snapshot.error}'));
          }
          
          final tracks = snapshot.data ?? [];
          
          if (tracks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_music, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Your library is empty',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Text('Save some songs to see them here'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tracks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: track.thumbnailUrl != null
                      ? Image.network(track.thumbnailUrl!, width: 50, height: 50, fit: BoxFit.cover)
                      : Container(width: 50, height: 50, color: Colors.grey, child: const Icon(Icons.music_note)),
                ),
                title: Text(track.title),
                subtitle: Text(track.artist),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (track.localPath != null)
                      const Icon(Icons.download_done, color: Colors.green, size: 20),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        ref.read(playTrackUseCaseProvider).execute(track);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
