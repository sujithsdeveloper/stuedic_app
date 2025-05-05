import 'package:flutter/material.dart';
import 'package:stuedic_app/model/app/overlay_text.dart';

class TextoverlayWidget extends StatefulWidget {
  const TextoverlayWidget({super.key, required this.overlay});
final TextOverlay overlay;
  @override
  State<TextoverlayWidget> createState() => _TextoverlayWidgetState();
}


class _TextoverlayWidgetState extends State<TextoverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
                        left:widget. overlay.offset.dx,
                        top:widget. overlay.offset.dy,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                             widget. overlay.offset += details.delta;
                            });
                          },
                          child: Text(
                           widget. overlay.text,
                            style: TextStyle(
                              color:widget. overlay.color,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 2, color: Colors.black)
                              ],
                            ),
                          ),
                        ),
                      );
  }
}