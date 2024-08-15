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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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

  Future<void> enviarDatos(String firstName, String lastName) async {
    if (userNeighborId == null) {
      print('Error: UserNeighborId no está disponible');
      return;
    }

    String fullName = '$firstName $lastName';
    final String apiUrl6 =
        'http://4.151.55.143/ISAPI/AccessControl/UserInfo/Record?format=json&devIndex=8183A216-45CC-014D-946D-415764A1C0C7';
    final Map<String, dynamic> userInfo = {
      "UserInfo": [
        {
          "employeeNo": userNeighborId,
          "name": fullName,
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageUploadScreen()),
        );
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/fondop.png'), // Asegúrate de tener la imagen en tu carpeta assets
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'INGRESA LA INFORMACIÓN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF211E1F),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFF292C54), width: 2),
                ),
                child: TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: Color(0xFF292C54)),
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: Color(0xFF292C54)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFF292C54), width: 2),
                ),
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: Color(0xFF292C54)),
                    labelText: 'Apellido',
                    labelStyle: TextStyle(color: Color(0xFF292C54)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Ingresa tus datos',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF292C54),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  enviarDatos(
                      firstNameController.text, lastNameController.text);
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
            ],
          ),
        ),
      ),
    );
  }
}
