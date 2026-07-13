import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización de Firebase con try/catch para evitar caídas
  // si el archivo google-services.json o similar aún no ha sido cargado.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Advertencia: No se pudo conectar con Firebase. Asegúrate de configurar los servicios correspondientes. Detalles: $e');
  }

  runApp(const MyApp());
}

