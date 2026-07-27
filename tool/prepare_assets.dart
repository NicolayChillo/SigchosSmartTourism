// One-off build tool: copies the best photos from data_source/Galeria into
// assets/images/, resized and compressed, so they can be bundled locally and
// uploaded to Firebase Storage (see lib/core/data/seed_data.dart).
// Run with: dart run tool/prepare_assets.dart
import 'dart:io';
import 'package:image/image.dart' as img;

const int maxWidth = 1280;
const int jpegQuality = 82;
const int maxPhotosPerPlace = 4;

final Map<String, String> categoryFolders = {
  'Atractivos': 'atractivos',
  'Hospedaje': 'hosterias',
  'Emprendimientos': 'emprendimientos',
  'Rutas': 'rutas',
};

String slugify(String input) {
  const accents = 'áéíóúÁÉÍÓÚñÑüÜ';
  const plain = 'aeiouAEIOUnNuU';
  var out = input;
  for (var i = 0; i < accents.length; i++) {
    out = out.replaceAll(accents[i], plain[i]);
  }
  out = out.toLowerCase();
  out = out.replaceAll(RegExp(r"[^a-z0-9]+"), '-');
  out = out.replaceAll(RegExp(r'-+'), '-');
  out = out.replaceAll(RegExp(r'^-|-$'), '');
  return out;
}

bool isSupportedImage(String path) {
  final lower = path.toLowerCase();
  return lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.png') ||
      lower.endsWith('.webp');
}

void main() {
  final sourceRoot = Directory('data_source/Galeria');
  if (!sourceRoot.existsSync()) {
    stderr.writeln('No se encontró data_source/Galeria');
    exit(1);
  }

  final summary = <String, List<String>>{};

  for (final entry in categoryFolders.entries) {
    final sourceCategoryDir = Directory('${sourceRoot.path}/${entry.key}');
    if (!sourceCategoryDir.existsSync()) continue;
    final destCategory = entry.value;

    final placeDirs = sourceCategoryDir
        .listSync()
        .whereType<Directory>()
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    for (final placeDir in placeDirs) {
      final placeName = placeDir.uri.pathSegments
          .where((s) => s.isNotEmpty)
          .last;
      final slug = slugify(placeName);

      final files = placeDir
          .listSync()
          .whereType<File>()
          .where((f) => isSupportedImage(f.path))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

      if (files.isEmpty) {
        stdout.writeln('AVISO: sin fotos soportadas para "$placeName"');
        continue;
      }

      final chosen = files.take(maxPhotosPerPlace).toList();
      final destDir = Directory('assets/images/$destCategory/$slug');
      destDir.createSync(recursive: true);

      final assetPaths = <String>[];
      for (var i = 0; i < chosen.length; i++) {
        final bytes = chosen[i].readAsBytesSync();
        img.Image? decoded;
        try {
          decoded = img.decodeImage(bytes);
        } catch (_) {
          decoded = null;
        }
        if (decoded == null) {
          stdout.writeln('  saltada (no se pudo decodificar): ${chosen[i].path}');
          continue;
        }
        final resized = decoded.width > maxWidth
            ? img.copyResize(decoded, width: maxWidth)
            : decoded;
        final jpg = img.encodeJpg(resized, quality: jpegQuality);
        final destFile = File('${destDir.path}/${i + 1}.jpg');
        destFile.writeAsBytesSync(jpg);
        assetPaths.add(destFile.path.replaceAll('\\', '/'));
      }

      summary['$destCategory/$slug'] = assetPaths;
      stdout.writeln('OK $destCategory/$slug -> ${assetPaths.length} fotos');
    }
  }

  stdout.writeln('\nListo. ${summary.length} carpetas generadas en assets/images/.');
}
