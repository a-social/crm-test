import 'package:flutter/material.dart';

class UnitElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final IconData icon;

  const UnitElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color, // Renk dışarıdan opsiyonel olarak alınabilir
    this.icon = Icons.person_add, // Varsayılan ikon kişi ekleme
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.green, // Varsayılan yeşil renk
            foregroundColor: Colors.white, // İkon ve metin beyaz
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Yuvarlatılmış köşeler
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          icon: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
          label: Text(text, style: const TextStyle(fontSize: 16)),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
