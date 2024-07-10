import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PantallaReporte extends StatefulWidget {
  @override
  _PantallaReporteState createState() => _PantallaReporteState();
}

class _PantallaReporteState extends State<PantallaReporte> {
  TextEditingController _descripcionController = TextEditingController();

  Future<void> _sendReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPropertyId = prefs.getString('idPropiedad') ??
        '1'; // Asume '1' si no se encuentra el valor
    String nombre = prefs.getString('nombre') ?? '';
    String apellido = prefs.getString('lastname') ?? '';
    String descripcion = _descripcionController.text;

    var response = await http.post(
      Uri.parse('https://jaus.azurewebsites.net/save_report.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'UserProperty_Id': userPropertyId,
        'Name_report': nombre,
        'LastName_report': apellido,
        'Descripcion_report': descripcion,
        'Status_report': 'standby',
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        // Mostrar diálogo de éxito
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Reporte enviado'),
              content: Text('Tu reporte ha sido enviado exitosamente.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Manejar error en la respuesta
        print('Error: ${jsonResponse['message']}');
      }
    } else {
      // Manejar error en la solicitud
      print('Error en la solicitud: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 16, 145, 1),
        title: Text('Reportar', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/FONDO_GENERAL.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Describe el problema que tuviste',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _descripcionController,
                      maxLines: 5,
                      style: TextStyle(color: Colors.black), // Letras en negro
                      decoration: InputDecoration(
                        labelText: 'Descripción del problema',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(
                                3, 16, 145, 1), // Color del borde
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(
                                3, 16, 145, 1), // Color del borde
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(
                                3, 16, 145, 1), // Color del borde
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: _sendReport,
                    child: Text('Reportar'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(screenWidth * 0.5, 40),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
