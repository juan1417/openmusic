import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/mock_catalog.dart';
import '../../data/datasources/persistence_service.dart';
import '../../data/datasources/audio_service.dart';
import 'search_screen.dart';
import '../../domain/entities/audio_quality.dart';
import '../../domain/entities/track.dart';
import '../providers/library_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String query = '';
  AudioQuality selectedQuality = AudioQuality.aac;
  List<Track> _savedTracks = [];
  bool _isLoadingSaved = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedTracks();
    });
  }

  Future<void> _loadSavedTracks() async {
    final persistence = ref.read(persistenceProvider);
    final saved = await persistence.getSavedTracks();
    if (mounted) {
      setState(() {
        _savedTracks = saved;
        _isLoadingSaved = false;
      });
    }
  }

  List<Track> get filteredTracks {
    final baseTracks = query.isEmpty ? mockTracks : mockTracks; // We could combine with saved later
    return baseTracks.where((track) {
      final search = query.trim().toLowerCase();
      if (search.isEmpty) {
        return true;
      }
      return (track.title).toLowerCase().contains(search) ||
          (track.artist).toLowerCase().contains(search) ||
          (track.source).toLowerCase().contains(search);
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final tracks = filteredTracks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Openmusic'),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
              _loadSavedTracks(); // Refresh when coming back
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            'Mix YouTube discovery with a private high-quality library.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: 'Search songs, artists, sources...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Audio quality',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AudioQuality.values.map((quality) {
              final isSelected = quality == selectedQuality;
              return ChoiceChip(
                label: Text('${quality.label} • ${quality.description}'),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => selectedQuality = quality);
                },
              );
            }).toList(growable: false),
          ),
          const SizedBox(height: 24),
          if (_savedTracks.isNotEmpty) ...[
            Text(
              'Your Library',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _savedTracks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final track = _savedTracks[index];
                  return GestureDetector(
                    onTap: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Loading audio for ${track.title}...'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        await AudioService().playTrack(track);
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error playing audio: $e')),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: track.thumbnailUrl != null
                              ? Image.network(
                                  track.thumbnailUrl!,
                                  height: 100,
                                  width: 140,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 100,
                                  width: 140,
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  child: const Icon(Icons.music_note),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                track.artist,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
            const SizedBox(height: 24),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured tracks',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                '${tracks.length} results',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tracks.map(
            (track) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TrackCard(
                track: track,
                selectedQuality: selectedQuality,
              ),
            ),
          ),
          if (tracks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Center(
                child: Text(
                  'No tracks match your search.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TrackCard extends StatelessWidget {
  const _TrackCard({
    required this.track,
    required this.selectedQuality,
  });

  final Track track;
  final AudioQuality selectedQuality;

  @override
  Widget build(BuildContext context) {
    return _PlayableTrackCard(track: track, selectedQuality: selectedQuality);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _PlayableTrackCard extends StatefulWidget {
  const _PlayableTrackCard({
    required this.track,
    required this.selectedQuality,
  });

  final Track track;
  final AudioQuality selectedQuality;

  @override
  State<_PlayableTrackCard> createState() => _PlayableTrackCardState();
}

class _PlayableTrackCardState extends State<_PlayableTrackCard> {
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _saved = widget.track.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.track;
    final qualifiesForSelection = track.availableQualities.contains(widget.selectedQuality);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                image: track.thumbnailUrl != null
                    ? DecorationImage(image: NetworkImage(track.thumbnailUrl!), fit: BoxFit.cover)
                    : null,
                gradient: track.thumbnailUrl == null
                    ? LinearGradient(
                        colors: qualifiesForSelection
                            ? [const Color(0xFF1DB954), const Color(0xFF0F766E)]
                            : [const Color(0xFF4B5563), const Color(0xFF1F2937)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(16),
              ),
              child: track.thumbnailUrl == null
                  ? const Icon(Icons.graphic_eq, color: Colors.white)
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${track.artist} • ${track.source}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Tag(label: _formatDuration(track.duration)),
                      _Tag(label: _saved ? 'Saved' : 'Not saved'),
                      _Tag(label: qualifiesForSelection ? widget.selectedQuality.label : 'Stream quality only'),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  tooltip: 'Play',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Playing ${track.title}')),
                    );
                  },
                  icon: const Icon(Icons.play_circle_fill, size: 32),
                ),
                IconButton(
                  tooltip: _saved ? 'Unsave' : 'Save',
                  onPressed: () {
                    setState(() => _saved = !_saved);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_saved ? 'Saved ${track.title}' : 'Removed ${track.title}')),
                    );
                  },
                  icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border),
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

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
