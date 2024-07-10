import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HikvisionReg',
      home: HikvisionRegScreen(),
    );
  }
}

class HikvisionRegScreen extends StatefulWidget {
  @override
  _HikvisionRegScreenState createState() => _HikvisionRegScreenState();
}

class _HikvisionRegScreenState extends State<HikvisionRegScreen> {
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController aliasController = TextEditingController();

  Future<void> enviarDatos(String token, String alias) async {
    final String apiUrl6 =
        'http://4.151.55.143/ISAPI/AccessControl/UserInfo/Record?format=json&devIndex=37623F1A-7D9D-6940-9D7D-DC6F69245789';
    final Map<String, dynamic> userInfo = {
      "UserInfo": [
        {
          "employeeNo": token,
          "name": alias,
          "userType": "normal",
          "Valid": {
            "beginTime": "2017-01-01T00:00:00",
            "endTime": "2027-12-31T23:59:59",
            "timeType": "local"
          },
          "RightPlan": [
            {"doorNo": 1, "planTemplateNo": "1"}
          ],
          "password": "123456"
        }
      ]
    };

    var client = DigestAuthClient(
        'admin', 'Airton2023'); // Reemplaza con tus credenciales

    try {
      final response = await client.post(
        Uri.parse(apiUrl6),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userInfo),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HikvisionReg'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: tokenController,
              decoration: InputDecoration(labelText: 'Token'),
            ),
            TextField(
              controller: aliasController,
              decoration: InputDecoration(labelText: 'Alias'),
            ),
            ElevatedButton(
              onPressed: () {
                enviarDatos(tokenController.text, aliasController.text);
              },
              child: Text('Enviar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}
