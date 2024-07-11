import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hikvision',
      home: HikvisionScreen(),
    );
  }
}

class HikvisionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hikvision'),
        backgroundColor: Color.fromRGBO(3, 16, 145, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Acciones para el Botón 1
              },
              child: Text('Registrar usuario'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Acciones para el Botón 2
              },
              child: Text('Registrar codigo'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Acciones para el Botón 3
              },
              child: Text('Registrar rostro'),
            ),
          ],
        ),
      ),
    );
  }
}
