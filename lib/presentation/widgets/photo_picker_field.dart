import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/export.dart';
import '../../core/utils/image_utils.dart';
import '../../core/widgets/app_image.dart';

/// Selector de hasta [maxFotos] fotos (cámara o galería), comprimidas y
/// codificadas en base64 con [ImageUtils]. Se usa en los formularios de
/// administración para lugares, hosterías y emprendimientos.
class PhotoPickerField extends StatefulWidget {
  final List<String> fotos;
  final ValueChanged<List<String>> onChanged;
  final int maxFotos;

  const PhotoPickerField({
    super.key,
    required this.fotos,
    required this.onChanged,
    this.maxFotos = 3,
  });

  @override
  State<PhotoPickerField> createState() => _PhotoPickerFieldState();
}

class _PhotoPickerFieldState extends State<PhotoPickerField> {
  bool _cargando = false;

  Future<void> _agregar(ImageSource source) async {
    if (widget.fotos.length >= widget.maxFotos) return;
    setState(() => _cargando = true);
    try {
      final encoded = await ImageUtils.pickAndEncode(source);
      if (encoded != null) {
        widget.onChanged([...widget.fotos, encoded]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo procesar la imagen: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _quitar(int index) {
    final nuevas = [...widget.fotos]..removeAt(index);
    widget.onChanged(nuevas);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fotos (máx. ${widget.maxFotos})', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < widget.fotos.length; i++)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AppImage(path: widget.fotos[i], width: 88, height: 88),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => _quitar(i),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            if (widget.fotos.length < widget.maxFotos)
              InkWell(
                onTap: _cargando ? null : () => _mostrarOpciones(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColoresApp.borde),
                  ),
                  child: _cargando
                      ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.add_a_photo_outlined, color: ColoresApp.primario),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _mostrarOpciones(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(ctx);
                _agregar(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(ctx);
                _agregar(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
