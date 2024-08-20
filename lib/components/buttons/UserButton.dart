import 'package:flutter/material.dart';

class UserButton extends StatelessWidget {
  final String nombre;
  final String cargo;
  final String direccion;
  final VoidCallback  onTap;

  UserButton({
    required this.nombre,
    required this.cargo,
    required this.direccion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(191, 255, 255, 255),
              Color.fromARGB(191, 255, 255, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              nombre,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 8, 28, 154),
              ),
            ),
            Text(
              cargo,
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              direccion,
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(137, 96, 96, 96),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
