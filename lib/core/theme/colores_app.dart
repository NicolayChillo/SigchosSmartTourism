import 'package:flutter/material.dart';

class ColoresApp {
  // COLORES PRINCIPALES (basados en la bandera)
  static const Color primario = Color(0xFF027333);   // Verde oscuro
  static const Color secundario = Color(0xFF038C3E); // Verde medio
  static const Color acento = Color(0xFFF2D129);     // Amarillo

  // ESTADOS (se mantienen)
  static const Color exito = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color advertencia = Color(0xFFF59E0B);

  // TEMA CLARO
  static const Color fondo = Color(0xFFF2F2F2);      // Blanco roto
  static const Color superficie = Colors.white;
  static const Color textoOscuro = Color(0xFF1F2937);
  static const Color textoClaro = Color(0xFF6B7280);
  static const Color textoHint = Color(0xFF9CA3AF);
  static const Color borde = Color(0xFFE5E7EB);

  // TEMA OSCURO (se mantienen, pero puedes ajustarlos si quieres)
  static const Color fondoOscuro = Color(0xFF121212);
  static const Color superficieOscura = Color(0xFF1E1E1E);
  static const Color textoBlanco = Color(0xFFF9FAFB);
  static const Color textoGrisClaro = Color(0xFFE5E7EB);
  static const Color bordeOscuro = Color(0xFF2C2C2C);
}