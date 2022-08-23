import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  final color;
  final textColor;
  final String buttonText;
  final presionado;

  Boton(
      {this.color, this.textColor, required this.buttonText, this.presionado});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: presionado,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            color: color,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
