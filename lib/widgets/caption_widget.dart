import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';

class CaptionWidget extends StatelessWidget {
  const CaptionWidget({super.key, required this.caption});
  final String caption;

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<AppContoller>();
    final proread = context.read<AppContoller>();

    final bool isExpanded = prowatch.maxLines == null;

    // Use LayoutBuilder to measure text overflow
    return LayoutBuilder(
      builder: (context, constraints) {
        // Create a TextPainter to check if text overflows
        final textSpan = TextSpan(
          text: caption,
          style: DefaultTextStyle.of(context).style,
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: prowatch.maxLines ?? 1000,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        // Check if text is overflowing when maxLines is 2
        final isOverflowing = () {
          if (prowatch.maxLines == null) return false;
          final tp = TextPainter(
            text: textSpan,
            maxLines: 2,
            textDirection: TextDirection.ltr,
          );
          tp.layout(maxWidth: constraints.maxWidth);
          return tp.didExceedMaxLines;
        }();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              caption,
              maxLines: prowatch.maxLines ?? 1000, // fallback
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            const SizedBox(height: 4),
            if (isOverflowing || isExpanded)
              GestureDetector(
                onTap: () {
                  proread.changeMaxLines(); // Toggles the maxLines
                },
                child: Text(
                  isExpanded ? 'Read Less' : 'Read More',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
