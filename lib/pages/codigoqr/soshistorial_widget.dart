import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Alert {
  final int id;
  final String emergency;
  final String description;
  final String registerDate;
  final String placeName;
  final String image;
  final String userName;
  final String street;
  final int numExt;
  final int numInt;

  Alert({
    required this.id,
    required this.emergency,
    required this.description,
    required this.registerDate,
    required this.placeName,
    required this.image,
    required this.userName,
    required this.street,
    required this.numExt,
    required this.numInt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['Id'],
      emergency: json['Emergency'],
      description: json['Description'],
      registerDate: json['RegisterDate'],
      placeName: json['Place']['Name'],
      image: json['UserNeighbor']['ImageProfile'],
      userName: json['UserNeighbor']['Name'],
      street: json['Property']['Street'],
      numExt: json['Property']['NumExt'],
      numInt: json['Property']['NumInt'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vecino Vigilante',
      home: AlertHistoryScreen1(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class AlertHistoryScreen1 extends StatefulWidget {
  @override
  _AlertHistoryScreen1State createState() => _AlertHistoryScreen1State();
}

class _AlertHistoryScreen1State extends State<AlertHistoryScreen1> {
  late Future<List<Alert>> futureAlerts;

  @override
  void initState() {
    super.initState();
    futureAlerts = _fetchAlertHistory1();
  }

  Future<List<Alert>> _fetchAlertHistory1() async {
    String url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetAlertHistory';
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'idUser': '10173',
        'AssociationId': '1',
        'Type': 'sos',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['Type'] == 'Success') {
        var value = data['Data'][0]['Value'];
        if (value != "[]") {
          List<dynamic> listAlerts = json.decode(value);
          return listAlerts
              .map((alertJson) => Alert.fromJson(alertJson))
              .toList();
        }
      }
    }
    throw Exception(
        'Failed to load alerts'); // Lanzar una excepción si no hay datos o hay un error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFF780000), // Fondo rojo según la imagen proporcionada
      appBar: AppBar(
        title: Text('Vecino Vigilante'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Alert>>(
        future: futureAlerts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Sin alertas',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            );
          } else {
            List<Alert> alerts = snapshot.data!;
            return ListView(
              children: alerts.map((alert) => buildAlertCard1(alert)).toList(),
            );
          }
        },
      ),
    );
  }
}

Widget buildAlertCard1(Alert alert) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: Color(0xFF780000), // Fondo rojo para la tarjeta
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Hora de reporte: ${alert.registerDate}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '${alert.userName} . en ${alert.street} #${alert.numExt}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(alert.image),
            ),
            SizedBox(height: 20),
            Text(
              'REQUIERE ASISTENCIA EN:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              alert.placeName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, color: Colors.amber),
                SizedBox(width: 10),
                Text(
                  alert.emergency,
                  style: TextStyle(color: Colors.amber, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para llenar el reporte
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent, // Botón de color rojo
              ),
              child: Text(
                'Llenar Reporte',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
