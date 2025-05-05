import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stuedic_app/model/app/overlay_text.dart';
import 'package:stuedic_app/utils/app_utils.dart';
Future<String?> exportEditedVideo({
  required String videoPath,
  required List<TextOverlay> overlays,
  double zoom = 1.0,
  ColorFilter? colorFilter,
}) async {
  try {
    final directory = await getTemporaryDirectory();
    final outputPath = '${directory.path}/edited_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Build FFmpeg filter string
    String filter = '';

 

    // Add overlays (drawtext)
    for (final overlay in overlays) {
      // Convert color to hex (ARGB to RGBA)
      String hexColor = overlay.color.value.toRadixString(16).padLeft(8, '0');
      String rgba = '0x${hexColor.substring(2)}'; // skip alpha
      filter += "drawtext=text='${overlay.text}':fontcolor=${rgba}:fontsize=32:x=${overlay.offset.dx}:y=${overlay.offset.dy},";
    }

    // Remove trailing comma
    if (filter.endsWith(',')) filter = filter.substring(0, filter.length - 1);

    // Compose ffmpeg command
    final cmd = "-i \"$videoPath\" -vf \"$filter\" -codec:a copy \"$outputPath\"";

    await FFmpegKit.execute(cmd);

    if (File(outputPath).existsSync()) {
      return outputPath;
    }
  } catch (e) {
    log('Error exporting video: $e');
    AppUtils.showToast(msg: 'Error exporting video: $e');
  }
  return null;
}
