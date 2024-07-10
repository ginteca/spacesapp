import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spacesclub/pages/codigoqr/soshistorial_widget.dart';

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
      title: 'S.O.S Screen',
      home: AlertHistoryScreen(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class AlertHistoryScreen extends StatefulWidget {
  @override
  _AlertHistoryScreenState createState() => _AlertHistoryScreenState();
}

class _AlertHistoryScreenState extends State<AlertHistoryScreen> {
  late Future<List<Alert>> futureAlerts;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    futureAlerts = _fetchAlertHistory();
  }

  Future<List<Alert>> _fetchAlertHistory() async {
    String url = 'https://appaltea.azurewebsites.net/api/Mobile/GetActiveAlert';
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
      // Cambia el color de fondo basado en si hay datos o no, y si hay un error.
      backgroundColor: hasError
          ? Colors.red // Rojo si hay error
          : Colors.red, // Azul oscuro si no hay alertas
      appBar: AppBar(
        title: Text('S.O.S'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Alert>>(
        future: futureAlerts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            hasError = true; // Indica que hay un error
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Sin alertas',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 20), // Espaciado entre el texto y el botón
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AlertHistoryScreen1()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Fondo blanco para el botón
                      onPrimary: Color(0xFF780000), // Texto rojo para el botón
                    ),
                    child: Text('Historial'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            hasError = false; // No hay error y la lista está vacía
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Sin alertas',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 20), // Espaciado entre el texto y el botón
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AlertHistoryScreen1()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Fondo blanco para el botón
                      onPrimary: Color(0xFF780000), // Texto rojo para el botón
                    ),
                    child: Text('Historial'),
                  ),
                ],
              ),
            );
          } else {
            hasError = false; // Hay datos, entonces no hay error
            List<Alert> alerts = snapshot.data!;
            return ListView(
              children: alerts.map((alert) => buildAlertCard(alert)).toList(),
            );
          }
        },
      ),
    );
  }

  void _showReportDialog(int idVigilantAlert) {
    // Controlador para el TextField
    final _reportController = TextEditingController();

    // Muestra el cuadro de diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reporte'),
          content: TextField(
            controller: _reportController,
            decoration: InputDecoration(hintText: "Ingrese su reporte"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                // Aquí llamas a tu función para enviar el reporte
                _sendReport(idVigilantAlert, _reportController.text);
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
          ],
        );
      },
    );
  }

  void _sendReport(int idVigilantAlert, String report) async {
    String url =
        'https://appaltea.azurewebsites.net/api/Mobile/SaveReportVigilantAlert';
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'idUser': '10173',
        'PropertyId':
            '9410', // Reemplaza con el PropertyId correcto si es necesario
        'IdVigilantAlert': idVigilantAlert.toString(),
        'Report': report,
      },
    );

    if (response.statusCode == 200) {
      // Si la API responde con éxito, maneja la respuesta aquí
      print('Reporte enviado con éxito');
    } else {
      // Si la API responde con error, maneja el error aquí
      print('Error al enviar el reporte');
    }
  }

  Widget buildAlertCard(Alert alert) {
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
              SizedBox(height: 50),
              Text(
                '${alert.userName} . en ${alert.street} #${alert.numExt}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(alert.image),
              ),
              SizedBox(height: 50),
              Text(
                'REQUIERE ASISTENCIA EN:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 50),
              Text(
                alert.placeName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
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
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: () {
                  _showReportDialog(alert.id);
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
}
