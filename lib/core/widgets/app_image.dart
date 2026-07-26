import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/export.dart';

/// Renderiza una foto sin importar su origen: asset local del catálogo
/// (`assets/...`), foto de usuario codificada en base64 (`data:image/...`)
/// o, si algún día se vuelve a usar, una URL de red.
class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return _placeholder();

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (path.startsWith('data:image')) {
      try {
        final base64Part = path.substring(path.indexOf(',') + 1);
        final bytes = base64Decode(base64Part);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      } catch (_) {
        return _placeholder();
      }
    }

    return Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: ColoresApp.primario.withValues(alpha: 0.08),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: ColoresApp.primario,
        ),
      ),
    );
  }
}
