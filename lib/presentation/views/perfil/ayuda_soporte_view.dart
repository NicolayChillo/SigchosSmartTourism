import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/export.dart';

// TODO: reemplaza estos datos por el correo/teléfono de soporte real del
// equipo antes de publicar la app.
const String _correoSoporte = 'soporte@sigchossmarttourist.ec';
const String _telefonoSoporte = '+593999999999';

const List<({String pregunta, String respuesta})> _preguntasFrecuentes = [
  (
    pregunta: '¿Cómo guardo un lugar en mis favoritos?',
    respuesta:
        'Toca el ícono de corazón en la esquina de cualquier tarjeta de atractivo, hostería o emprendimiento. '
        'Puedes verlos luego en Perfil → Mis Favoritos.',
  ),
  (
    pregunta: 'El mapa no carga o aparece en blanco',
    respuesta:
        'Verifica tu conexión a internet y que la ubicación (GPS) esté activada. Si el problema persiste, '
        'cierra y vuelve a abrir la app.',
  ),
  (
    pregunta: '¿Cómo dejo una calificación o comentario?',
    respuesta:
        'Entra al detalle de un atractivo, hostería o emprendimiento y desplázate hasta la sección '
        '"Califica este lugar" al final de la pantalla.',
  ),
  (
    pregunta: '¿Puedo usar la app sin conexión?',
    respuesta:
        'Podrás seguir viendo el último catálogo que se cargó mientras tenías internet, pero para '
        'fotos nuevas, mapas y guardar favoritos necesitas conexión.',
  ),
  (
    pregunta: '¿Cómo me convierto en administrador?',
    respuesta:
        'El rol de administrador lo asigna el equipo del cantón Sigchos manualmente por seguridad. '
        'Escríbenos si necesitas gestionar el catálogo.',
  ),
];

class AyudaSoporteView extends StatelessWidget {
  const AyudaSoporteView({super.key});

  Future<void> _enviarCorreo(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _correoSoporte,
      queryParameters: {'subject': 'Soporte - Sigchos Smart Tourist'},
    );
    final abierto = await launchUrl(uri);
    if (!abierto && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir tu app de correo. Escríbenos a $_correoSoporte')),
      );
    }
  }

  Future<void> _llamar(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: _telefonoSoporte);
    final abierto = await launchUrl(uri);
    if (!abierto && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el marcador. Llámanos al $_telefonoSoporte')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda & Soporte')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Preguntas frecuentes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: ColoresApp.fondo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: ColoresApp.borde),
            ),
            child: Column(
              children: [
                for (final faq in _preguntasFrecuentes)
                  ExpansionTile(
                    title: Text(faq.pregunta, style: const TextStyle(fontWeight: FontWeight.w600)),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(faq.respuesta, style: Theme.of(context).textTheme.bodyMedium)],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('¿Necesitas más ayuda?', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: ColoresApp.primario.withValues(alpha: 0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined, color: ColoresApp.primario),
                  title: const Text('Escríbenos por correo'),
                  subtitle: const Text(_correoSoporte),
                  onTap: () => _enviarCorreo(context),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_outlined, color: ColoresApp.primario),
                  title: const Text('Llámanos'),
                  subtitle: const Text(_telefonoSoporte),
                  onTap: () => _llamar(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
