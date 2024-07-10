import 'dart:ffi';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:spacesclub/pages/reservaciones/reserva1Widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Facility {
  final int id;
  final String name;
  final String image;
  final String description;
  final String type;
  final String status;
  final DateTime registerDate;

  Facility({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.type,
    required this.status,
    required this.registerDate,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['Id'] as int,
      name: json['Name'] ?? 'Nombre predeterminado',
      image: json['Image'] ?? 'Imagen predeterminada',
      description: json['Description'] ?? 'No hay descripción disponible',
      type: json['Type'] ?? 'Tipo no especificado',
      status: json['Status'] ?? 'Estado desconocido',
      registerDate: json['RegisterDate'] != null
          ? DateTime.parse(json['RegisterDate'])
          : DateTime.now(),
    );
  }
}

class Reservation {
  final int id;
  final DateTime dateStart;
  final DateTime dateFinish;
  final int time;
  final String description;
  final String status;
  final DateTime registerDate;
  final Facility facility;

  Reservation({
    required this.id,
    required this.dateStart,
    required this.dateFinish,
    required this.time,
    required this.description,
    required this.status,
    required this.registerDate,
    required this.facility,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['Id'] as int,
      dateStart: DateTime.parse(json['DateStart']),
      dateFinish: DateTime.parse(json['DateFinish']),
      time: json['Time'] as int,
      description: json['Description'] ?? 'Sin descripción',
      status: json['Status'] ?? 'Sin estado',
      registerDate: DateTime.parse(json['RegisterDate']),
      facility: Facility.fromJson(json['Facility']),
    );
  }
}

class ReservationsScreen extends StatefulWidget {
  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  late Future<List<Reservation>> _reservations;
  late Future<List<Facility>> _facilities;
  int _selectedFacilityId = 0; // ID del facility seleccionado
  List<Map<String, dynamic>>? _availability;

  Future<List<Reservation>> fetchReservations() async {
    // Carga las preferencias compartidas
    final prefs = await SharedPreferences.getInstance();

    // Obtén los valores de idUser y AssociationId
    String? idUser = prefs.getString('idUsuario');
    int? associationId = prefs.getInt('IdAssociation');
    print(associationId);
    print(idUser);
    // Asegúrate de que ambos valores no sean nulos
    if (idUser == null || associationId == null) {
      throw Exception(
          'No se pudo cargar el idUser o el AssociationId de SharedPreferences');
    }

    // Configura la solicitud HTTP
    var url = Uri.parse(
        'https://appaltea.azurewebsites.net/api/Mobile/GetReservations');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = 'idUser=$idUser&AssociationId=$associationId';
    var response = await http.post(url, headers: headers, body: body);

    // Procesa la respuesta
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return (json.decode(data['Data'][0]['Value']) as List)
          .map((item) => Reservation.fromJson(item))
          .toList();
    } else {
      throw Exception('Error al obtener reservas: ${response.reasonPhrase}');
    }
  }

  Future<List<Facility>> fetchFacilities() async {
    // Carga las preferencias compartidas
    final prefs = await SharedPreferences.getInstance();

    // Obtén los valores de idUser y AssociationId
    String? idUser = prefs.getString('idUsuario');
    int? associationId = prefs.getInt('IdAssociation');
    print(idUser);
    print(associationId);

    // Asegúrate de que ambos valores no sean nulos
    if (idUser == null || associationId == null) {
      throw Exception(
          'No se pudo cargar el idUser o el AssociationId de SharedPreferences');
    }

    // Configura la solicitud HTTP
    var url = Uri.parse(
        'https://appaltea.azurewebsites.net/api/Mobile/GetReservations');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = 'idUser=$idUser&AssociationId=$associationId';
    var response = await http.post(url, headers: headers, body: body);

    // Procesa la respuesta
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return (json.decode(data['Data'][1]['Value']) as List)
          .map((item) => Facility.fromJson(item))
          .toList();
    } else {
      throw Exception(
          'Error al obtener instalaciones: ${response.reasonPhrase}');
    }
  }

  @override
  void initState() {
    super.initState();
    _reservations = fetchReservations();
    _facilities = fetchFacilities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas e Instalaciones'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 3, 16, 145),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/FONDO_GENERAL.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(0.8), // Fondo blanco translúcido
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: FutureBuilder<List<Reservation>>(
                  future: _reservations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text(
                          "Error: ${snapshot.error.toString()}",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        );
                      }
                      var reservations = snapshot.data!;
                      return ListView.builder(
                        itemCount: reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = reservations[index];
                          final startDate = DateFormat('yyyy-MM-dd – kk:mm')
                              .format(reservation.dateStart);
                          final endDate = DateFormat('yyyy-MM-dd – kk:mm')
                              .format(reservation.dateFinish);
                          return Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(reservation.facility.image),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(
                                reservation.facility.name,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                "Desde: $startDate Hasta: $endDate\nEstado: ${reservation.status}",
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 3, 16, 145),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  var facilities = await _facilities;
                  var result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          FacilitySelectionScreen(facilities: facilities),
                    ),
                  );

                  if (result == 'updated') {
                    setState(() {
                      _reservations = fetchReservations();
                    });
                  }
                },
                child: Text(
                  'Crear Reservación',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReservationsScreen(),
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFF011D45),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black),
      ),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFF011D45),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.white),
      ),
    ),
    themeMode: ThemeMode.system,
  ));
}
