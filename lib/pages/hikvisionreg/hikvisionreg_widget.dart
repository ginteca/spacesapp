import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../hikvisionface/hikvisionface_widget.dart';

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
  final TextEditingController aliasController = TextEditingController();
  String? userNeighborId;

  @override
  void initState() {
    super.initState();
    _loadUserNeighborId();
  }

  Future<void> _loadUserNeighborId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userNeighborId = prefs.getString('idUsuario');
    });
  }

  Future<void> enviarDatos(String alias) async {
    if (userNeighborId == null) {
      print('Error: UserNeighborId no está disponible');
      return;
    }

    final String apiUrl6 =
        'http://4.151.55.143/ISAPI/AccessControl/UserInfo/Record?format=json&devIndex=8183A216-45CC-014D-946D-415764A1C0C7';
    final Map<String, dynamic> userInfo = {
      "UserInfo": [
        {
          "employeeNo": userNeighborId,
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageUploadScreen()),
        );
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
        title: Text('Bienvenido al registro de Hikvision'),
        backgroundColor: Color.fromRGBO(3, 16, 145, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ingresa tu nombre completo',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: aliasController,
              decoration: InputDecoration(labelText: 'Nombre completo'),
            ),
            ElevatedButton(
              onPressed: () {
                enviarDatos(aliasController.text);
              },
              child: Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
