import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import '../hikvisionreg/hikvisionreg_widget.dart';
import '../hikvisionface/hikvisionface_widget.dart';

Future<void> enviarDatospuerta() async {
  final String apiUrl7 =
      'http://4.151.55.143/ISAPI/AccessControl/RemoteControl/door/1?format=json&devIndex=37623F1A-7D9D-6940-9D7D-DC6F69245789';
  final Map<String, dynamic> remoteControlDoor = {
    "RemoteControlDoor": {"cmd": "open"}
  };

  var client =
      DigestAuthClient('admin', 'Airton2023'); // Reemplaza con tus credenciales

  try {
    final response = await client.put(
      Uri.parse(apiUrl7),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(remoteControlDoor),
    );

    if (response.statusCode == 200) {
      print("Datos enviados exitosamente");
      print(response.body);
    } else {
      print("Error al enviar los datos: ${response.statusCode}");
      print(response.body);
    }
  } catch (e) {
    print('Error al realizar la solicitud: $e');
  }
}

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HikvisionRegScreen()),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageUploadScreen()),
                );

                // Acciones para el Botón 3
              },
              child: Text('Registrar rostro'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                enviarDatospuerta();
              },
              child: Text('Abrir Puerta'),
            ),
          ],
        ),
      ),
    );
  }
}
