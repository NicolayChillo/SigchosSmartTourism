import 'package:flutter/material.dart';
import 'app_image.dart';

/// Visor de fotos a pantalla completa con zoom (pinch) y swipe entre fotos.
class PhotoViewerScreen extends StatefulWidget {
  final List<String> fotos;
  final int initialIndex;

  const PhotoViewerScreen({super.key, required this.fotos, this.initialIndex = 0});

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_index + 1} / ${widget.fotos.length}'),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.fotos.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, i) {
          return InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: AppImage(path: widget.fotos[i], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
