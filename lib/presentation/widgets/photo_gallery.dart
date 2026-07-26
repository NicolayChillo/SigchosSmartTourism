import 'package:flutter/material.dart';
import '../../core/theme/export.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/photo_viewer_screen.dart';

/// Carrusel de fotos con indicador de página, usado en los detalles de
/// lugares, hosterías y emprendimientos. Toca una foto para verla a
/// pantalla completa con zoom.
class PhotoGallery extends StatefulWidget {
  final List<String> fotos;
  final double height;

  const PhotoGallery({super.key, required this.fotos, this.height = 260});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.fotos.isEmpty) {
      return Container(
        height: widget.height,
        color: ColoresApp.primario.withValues(alpha: 0.08),
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined, size: 56, color: ColoresApp.primario),
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            itemCount: widget.fotos.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhotoViewerScreen(fotos: widget.fotos, initialIndex: i),
                  ),
                ),
                child: AppImage(path: widget.fotos[i], width: double.infinity, height: widget.height),
              );
            },
          ),
        ),
        if (widget.fotos.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.fotos.length, (i) {
                final selected = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: selected ? 10 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
