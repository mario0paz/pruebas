import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String category;

  const CategoryIcon({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí defines los iconos asociados a cada categoría
    final Map<String, String> categoryIcons = {
      'motor': 'assets/icons/motor.png',
      'neumatico': 'assets/icons/tire.png',
      'aceite': 'assets/icons/engine.png',
      'frenos': 'assets/icons/brake.png',
    };

    return Image.asset(
      categoryIcons[category] ??
          'assets/icons/what.png', // Icono por defecto si no se encuentra la categoría
      width: 32,
      height: 32,
    );
  }
}
