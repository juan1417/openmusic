import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:openmusic/config.dart' as app_config;

import '../../data/datasources/mock_catalog.dart';
import '../../data/datasources/youtube_service.dart';
import '../../data/datasources/persistence_service.dart';
import '../../data/datasources/audio_service.dart';
import '../../domain/entities/track.dart';
import '../../presentation/providers/library_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  static const int _maxRemoteResults = 60;
  static const int _initialPageSize = 50;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, YouTubeSearchResult> _cache = <String, YouTubeSearchResult>{};
  Timer? _debounce;

  String _query = '';
  bool _useYouTube = true;
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  List<Track> _remoteResults = <Track>[];
  String? _nextPageToken;

  List<Track> get _localResults {
    final search = _query.trim().toLowerCase();
    if (search.isEmpty) return <Track>[];

    return mockTracks.where((track) {
      return (track.title).toLowerCase().contains(search) ||
          (track.artist).toLowerCase().contains(search) ||
          (track.source).toLowerCase().contains(search);
    }).toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController
      ..removeListener(_maybeLoadMore)
      ..dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_useYouTube || _loadingMore || _nextPageToken == null || _query.isEmpty) {
      return;
    }

    if (_remoteResults.length >= _maxRemoteResults) {
      return;
    }

    if (!_scrollController.hasClients) return;
    final remaining = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
    if (remaining < 200) {
      unawaited(_loadMore());
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (_useYouTube) {
        unawaited(_performYouTubeSearch(value));
      } else {
        setState(() => _query = value);
      }
    });
  }

  String _cacheKey(String query, [String? pageToken]) {
    final normalized = query.trim().toLowerCase();
    return '$normalized|${pageToken ?? 'first'}';
  }

  Future<void> _performYouTubeSearch(String value, {String? pageToken, bool forceRefresh = false}) async {
    final query = value.trim();
    if (query.isEmpty) {
      setState(() {
        _query = '';
        _remoteResults = <Track>[];
        _nextPageToken = null;
        _error = null;
        _loading = false;
        _loadingMore = false;
      });
      return;
    }

    final cacheKey = _cacheKey(query, pageToken);
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      final cached = _cache[cacheKey]!;
      setState(() {
        _remoteResults = cached.items;
        _nextPageToken = cached.nextPageToken;
        _query = query;
        _error = null;
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = pageToken == null;
      _loadingMore = pageToken != null;
      _error = null;
    });

    try {
      final service = YouTubeService();
      final remaining = pageToken == null
          ? _initialPageSize
          : (_maxRemoteResults - _remoteResults.length).clamp(1, 10);
      final result = await service.search(query, maxResults: remaining, pageToken: pageToken);
      _cache[cacheKey] = result;
      setState(() {
        if (pageToken == null) {
          _remoteResults = result.items;
        } else {
          final availableSlots = _maxRemoteResults - _remoteResults.length;
          final appended = result.items.take(availableSlots).toList(growable: false);
          _remoteResults = <Track>[..._remoteResults, ...appended];
        }
        _nextPageToken = result.nextPageToken;
        _query = query;
      });


      if (pageToken == null && _nextPageToken != null && _remoteResults.length < _maxRemoteResults) {
        unawaited(_loadMore());
      }
    } catch (error) {
      setState(() {
        _error = error.toString();
        if (pageToken == null) {
          _remoteResults = <Track>[];
        }
      });
    } finally {
      setState(() {
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_nextPageToken == null || _query.isEmpty || _remoteResults.length >= _maxRemoteResults) return;
    await _performYouTubeSearch(_query, pageToken: _nextPageToken);
  }

  @override
  Widget build(BuildContext context) {
    final results = _useYouTube ? _remoteResults : _localResults;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Use YouTube'),
                Switch(
                  value: _useYouTube,
                  onChanged: (value) {
                    setState(() => _useYouTube = value);
                    if (value && _controller.text.isNotEmpty) {
                      unawaited(_performYouTubeSearch(_controller.text));
                    }
                  },
                ),
              ],
            ),
            if (_useYouTube)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Showing up to $_maxRemoteResults YouTube songs to keep things light.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              autofocus: true,
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
            const SizedBox(height: 12),
             if (_useYouTube && _loading)
               const Expanded(child: Center(child: CircularProgressIndicator()))
             else if (_error != null && _remoteResults.isEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 50),
                      const SizedBox(height: 16),
                      Text(
                        'Search Failed',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!.contains('API Key missing')
                            ? '🔴 API Key Error: Please set the YOUTUBE_API_KEY in your configuration file and re-run to enable YouTube search.'
                            : _error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
             else if (_useYouTube && results.isEmpty && _query.isNotEmpty)
               Expanded(
                 child: Center(
                   child: Text(
                     'No results found for "$_query"',
                     style: Theme.of(context).textTheme.bodyMedium,
                   ),
                 ),
               )
             else if (!_useYouTube && _query.isEmpty)
               Expanded(
                 child: Center(
                   child: Text(
                     'Type to search the local catalog',
                     style: Theme.of(context).textTheme.bodyMedium,
                   ),
                 ),
               )
             else
               Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: results.length + (_loadingMore ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index >= results.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return _SearchResultTile(track: results[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultTile extends ConsumerStatefulWidget {
  const _SearchResultTile({required this.track});

  final Track track;

  @override
  ConsumerState<_SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends ConsumerState<_SearchResultTile> {
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _saved = widget.track.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.track;
    final durationLabel = track.duration == Duration.zero
        ? 'Live / unknown length'
        : '${track.duration.inMinutes}:${(track.duration.inSeconds % 60).toString().padLeft(2, '0')}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 56,
          height: 56,
          child: track.thumbnailUrl != null
              ? Image.network(track.thumbnailUrl!, fit: BoxFit.cover)
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: track.source == 'YouTube'
                          ? [const Color(0xFF1DB954), const Color(0xFF0F766E)]
                          : [const Color(0xFF4B5563), const Color(0xFF1F2937)],
                    ),
                  ),
                  child: const Icon(Icons.graphic_eq, color: Colors.white),
                ),
        ),
      ),
      title: Text(track.title),
      subtitle: Text('${track.artist} • ${track.source} • $durationLabel'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Download',
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Downloading ${track.title}...')),
                              );
                              await ref.read(downloadTrackUseCaseProvider).execute(track);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Downloaded ${track.title} successfully!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Download failed: $e')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          tooltip: 'Play',
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Loading audio for ${track.title}...'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                              await ref.read(playTrackUseCaseProvider).execute(track);
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error playing audio: $e')),
                                );
                              }
                            }
                          },
                        ),
                        IconButton(
                          tooltip: _saved ? 'Unsave' : 'Save',
                          icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border),
                          onPressed: () async {
                            setState(() => _saved = !_saved);
                            final persistence = ref.read(persistenceProvider);
                            if (_saved) {
                              await persistence.saveTrack(track);
                            } else {
                              await persistence.removeTrack(track.id);
                            }
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_saved ? 'Saved ${track.title}' : 'Removed ${track.title}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
    );
  }
}
