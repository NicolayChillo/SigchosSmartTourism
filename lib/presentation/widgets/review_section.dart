import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/export.dart';
import '../../core/utils/image_utils.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/lugar.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/lugares_viewmodel.dart';
import '../../core/widgets/app_image.dart';

/// Sección de comentarios + calificación reutilizada en el detalle de
/// lugares, hosterías y emprendimientos. `tipoColeccion` debe coincidir con
/// el nombre de la colección Firestore ('lugares' | 'hosterias' |
/// 'emprendimientos') porque así lo espera LugaresRepository.
class ReviewSection extends StatefulWidget {
  final String id;
  final String tipoColeccion;

  const ReviewSection({
    super.key,
    required this.id,
    required this.tipoColeccion,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final _comentarioController = TextEditingController();
  int _estrellasSeleccionadas = 0;
  String? _fotoAdjunta;
  bool _enviandoComentario = false;
  bool _enviandoCalificacion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LugaresViewModel>(context, listen: false)
          .fetchComentarios(widget.id, widget.tipoColeccion);
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _adjuntarFoto(ImageSource source) async {
    try {
      final encoded = await ImageUtils.pickAndEncode(source);
      if (encoded != null) setState(() => _fotoAdjunta = encoded);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo procesar la foto: $e')),
        );
      }
    }
  }

  Future<void> _enviarCalificacion(int estrellas) async {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final user = authVm.currentUser;
    if (user == null) {
      _mostrarLoginRequerido();
      return;
    }
    setState(() {
      _estrellasSeleccionadas = estrellas;
      _enviandoCalificacion = true;
    });
    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final ok = await vm.addCalificacion(
      widget.id,
      widget.tipoColeccion,
      Calificacion(uid: user.uid, valor: estrellas, fecha: DateTime.now()),
    );
    if (mounted) {
      setState(() => _enviandoCalificacion = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? '¡Gracias por tu calificación!' : 'No se pudo registrar la calificación'),
          backgroundColor: ok ? ColoresApp.exito : ColoresApp.error,
        ),
      );
    }
  }

  Future<void> _enviarComentario() async {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final user = authVm.currentUser;
    if (user == null) {
      _mostrarLoginRequerido();
      return;
    }
    if (Validators.validateComment(_comentarioController.text) != null) return;

    setState(() => _enviandoComentario = true);
    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final ok = await vm.addComentario(
      widget.id,
      widget.tipoColeccion,
      Comentario(
        id: '',
        uid: user.uid,
        nombreUsuario: user.nombre,
        fotoUsuario: user.fotoPerfil,
        texto: _comentarioController.text.trim(),
        fecha: DateTime.now(),
        fotos: _fotoAdjunta != null ? [_fotoAdjunta!] : null,
      ),
    );
    if (mounted) {
      setState(() {
        _enviandoComentario = false;
        if (ok) {
          _comentarioController.clear();
          _fotoAdjunta = null;
        }
      });
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo publicar el comentario'), backgroundColor: ColoresApp.error),
        );
      }
    }
  }

  void _mostrarLoginRequerido() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inicia sesión para comentar o calificar.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LugaresViewModel>(context);
    final comentarios = vm.comentarios;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        Text('Califica este lugar', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (i) {
            final filled = i < _estrellasSeleccionadas;
            return IconButton(
              onPressed: _enviandoCalificacion ? null : () => _enviarCalificacion(i + 1),
              icon: Icon(
                filled ? Icons.star_rounded : Icons.star_border_rounded,
                color: Colors.amber,
                size: 32,
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text('Comentarios (${comentarios.length})',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16)),
        const SizedBox(height: 12),
        TextField(
          controller: _comentarioController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Comparte tu experiencia...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (_fotoAdjunta != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppImage(path: _fotoAdjunta!, width: 48, height: 48),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _fotoAdjunta = null),
              ),
            ] else ...[
              IconButton(
                tooltip: 'Tomar foto',
                icon: const Icon(Icons.camera_alt_outlined, color: ColoresApp.primario),
                onPressed: () => _adjuntarFoto(ImageSource.camera),
              ),
              IconButton(
                tooltip: 'Elegir de galería',
                icon: const Icon(Icons.photo_library_outlined, color: ColoresApp.primario),
                onPressed: () => _adjuntarFoto(ImageSource.gallery),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _enviandoComentario ? null : _enviarComentario,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.primario,
                foregroundColor: Colors.white,
              ),
              child: _enviandoComentario
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Publicar'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (vm.isLoading && comentarios.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
        else if (comentarios.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Sé el primero en comentar.', style: Theme.of(context).textTheme.bodyMedium),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comentarios.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final c = comentarios[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: ColoresApp.primario.withValues(alpha: 0.1),
                      child: c.fotoUsuario != null
                          ? ClipOval(
                              child: AppImage(path: c.fotoUsuario!, width: 36, height: 36),
                            )
                          : const Icon(Icons.person, color: ColoresApp.primario, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(c.nombreUsuario, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Text(
                                '${c.fecha.day}/${c.fecha.month}/${c.fecha.year}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(c.texto),
                          if (c.fotos != null && c.fotos!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 72,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: c.fotos!.length,
                                separatorBuilder: (_, _) => const SizedBox(width: 8),
                                itemBuilder: (context, i) => ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AppImage(path: c.fotos![i], width: 72, height: 72),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
