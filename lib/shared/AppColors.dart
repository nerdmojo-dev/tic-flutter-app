import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Colors
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF3B82F6);

  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  static const Color heading = Color(0xFF0F172A);
  static const Color text = Color(0xFF475569);

  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  static const LinearGradient greenBlueGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFF051937),
      Color(0xFF004D7A),
      Color(0xFF008793),
      Color(0xFF00BF72),
      Color(0xFFA8EB12),
    ],
  );


  static const LinearGradient lightPinkGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFF051937),
      Color(0xFF004D7A),
      Color(0xFF008793),
      Color(0xFF00BF72),
      Color(0xFFA8EB12),
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0], // Optional
  );


  // Shadows
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
  static const BoxShadow shadowSm = BoxShadow(
    color: Color.fromRGBO(15, 23, 42, 0.04),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow shadowMd = BoxShadow(
    color: Color.fromRGBO(15, 23, 42, 0.08),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const BoxShadow shadowLg = BoxShadow(
    color: Color.fromRGBO(37, 99, 235, 0.15),
    blurRadius: 25,
    offset: Offset(0, 10),
  );
}
