import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/audio_quality.dart';

class YouTubeSearchResult {
  YouTubeSearchResult(this.items, {this.nextPageToken});

  final List<Track> items;
  final String? nextPageToken;
}

class YouTubeService {
  final _yt = YoutubeExplode();

  Future<YouTubeSearchResult> search(
    String query, {
    int maxResults = 10,
    String? pageToken,
  }) async {
    try {
      // In youtube_explode_dart 3.x, search returns a Future<VideoSearchList>
      // VideoSearchList implements Iterable<Video>
      final searchResult = await _yt.search.search(query);
      
      final tracks = <Track>[];
      int count = 0;

      for (var video in searchResult) {
        if (count >= maxResults) break;

        tracks.add(Track(
          id: video.id.value,
          title: video.title,
          artist: video.author,
          source: 'YouTube',
          duration: video.duration ?? Duration.zero,
          isSaved: false,
          availableQualities: const <AudioQuality>[],
          thumbnailUrl: video.thumbnails.mediumResUrl,
        ));
        
        count++;
      }

      return YouTubeSearchResult(tracks);
    } catch (e) {
      throw Exception('YouTube extraction failed: $e');
    }
  }

  void dispose() {
    _yt.close();
  }
}
