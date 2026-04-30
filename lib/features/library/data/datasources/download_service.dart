import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../domain/entities/track.dart';

class DownloadService {
  DownloadService._internal();
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;

  final Dio _dio = Dio();
  final YoutubeExplode _yt = YoutubeExplode();

  Future<String> downloadTrack(Track track, {Function(double progress)? onProgress}) async {
    try {
      // 1. Get the audio stream URL from YouTube
      final manifest = await _yt.videos.streamsClient.getManifest(track.id);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      final url = audioStream.url.toString();

      // 2. Prepare local storage path
      final directory = await getApplicationDocumentsDirectory();
      final folder = Directory('${directory.path}/music');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final fileName = '${track.id}_${track.title.replaceAll(RegExp(r'[^\w\s]+'), '_')}.m4a';
      final filePath = p.join(folder.path, fileName);

      // 3. Download file using Dio
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      return filePath;
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }
}
