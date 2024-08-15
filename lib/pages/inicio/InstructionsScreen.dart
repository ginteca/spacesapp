import 'package:flutter/material.dart';

import '../hikvisionface/hikvisionface_widget.dart';

class InstructionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/fondop.png'), // Asegúrate de tener la imagen en tu carpeta assets
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Spacer(flex: 2),
              Text(
                'SIGUE LAS INSTRUCCIONES',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF211E1F),
                ),
              ),
              Spacer(),
              Text(
                'Toma una foto con las siguientes características:',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF292C54),
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Icon(
                Icons.account_circle,
                size: 100,
                color: Color(0xFF292C54),
              ),
              Spacer(),
              InstructionItem(
                icon: Icons.check_circle,
                iconColor: Colors.green,
                text: 'Encuadra de la cabeza al pecho.',
              ),
              InstructionItem(
                icon: Icons.check_circle,
                iconColor: Colors.green,
                text: 'Elige un fondo claro.',
              ),
              InstructionItem(
                icon: Icons.cancel,
                iconColor: Colors.red,
                text: 'No cubras tu rostro.',
              ),
              InstructionItem(
                icon: Icons.cancel,
                iconColor: Colors.red,
                text: 'No utilices gorra ni gafas.',
              ),
              Spacer(flex: 2),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ImageUploadScreen()), // Página específica
                  );
                  // Navegar a la siguiente pantalla o acción
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF7E57C2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text(
                    'SIGUIENTE',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class InstructionItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  InstructionItem(
      {required this.icon, required this.iconColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF292C54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
