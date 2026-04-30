import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'dart:io';

class AudioProcessor {
  AudioProcessor._internal();
  static final AudioProcessor _instance = AudioProcessor._internal();
  factory AudioProcessor() => _instance;

  /// Optimizes an audio file to FLAC or AAC High Quality
  Future<String?> optimizeAudio(String inputPath, {String format = 'flac'}) async {
    final outputExtension = format == 'flac' ? '.flac' : '.m4a';
    final outputPath = inputPath.replaceAll(RegExp(r'\.[^.]+$'), outputExtension);

    // FFmpeg command for high quality transcoding
    // -i: input
    // -vn: disable video
    // -ab 320k: audio bitrate
    // -ar 44100: sample rate
    final String command = '-i "$inputPath" -vn -ab 320k -ar 44100 "$outputPath"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      // Delete original file to save space
      final originalFile = File(inputPath);
      if (await originalFile.exists()) {
        await originalFile.delete();
      }
      return outputPath;
    } else {
      return null;
    }
  }

  /// Normalizes audio volume to a target level
  Future<String?> normalizeVolume(String inputPath) async {
    final outputPath = inputPath.replaceAll(RegExp(r'\.[^.]+$'), '_norm.m4a');
    
    // Loudnorm filter is used for professional volume normalization
    final String command = '-i "$inputPath" -filter:a loudnorm "$outputPath"';
    
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return outputPath;
    }
    return null;
  }
}
