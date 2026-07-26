import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

/// Fotos generadas por el usuario (comentarios, fotos de admin, perfil) no se
/// suben a Firebase Storage (sin plan de pago); se comprimen y se guardan
/// como data URI base64 directamente en el documento de Firestore.
class ImageUtils {
  static const int _maxDimension = 800;
  static const int _jpegQuality = 60;

  static final ImagePicker _picker = ImagePicker();

  /// Abre la cámara o la galería, comprime la foto elegida y devuelve un
  /// data URI listo para guardar en Firestore. Retorna null si el usuario
  /// cancela la selección.
  static Future<String?> pickAndEncode(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) return null;
    return encodeFile(File(picked.path));
  }

  static Future<String> encodeFile(File file) async {
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const FormatException('No se pudo procesar la imagen seleccionada.');
    }
    final resized = decoded.width > _maxDimension
        ? img.copyResize(decoded, width: _maxDimension)
        : decoded;
    final jpg = img.encodeJpg(resized, quality: _jpegQuality);
    return 'data:image/jpeg;base64,${base64Encode(jpg)}';
  }
}
