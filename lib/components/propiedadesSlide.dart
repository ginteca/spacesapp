import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../pages/inicio/inicio_widget.dart';
import '../pages/dashvigilante/dash_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class propiedadesSlide extends StatefulWidget {
  final responseJson;
  const propiedadesSlide({Key? key, required this.responseJson})
      : super(key: key);

  @override
  _propiedadesSlideState createState() => _propiedadesSlideState();
}

class _propiedadesSlideState extends State<propiedadesSlide> {
  List<dynamic> propiedades = [];
  late SharedPreferences prefs;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    getListaDePropiedades();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'Cargando Clubs',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return buildPropiedadesListView();
  }

  Widget buildPropiedadesListView() {
    return Container(
      width: 350,
      height: 250,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView.builder(
        itemCount: propiedades.length,
        itemBuilder: (BuildContext context, int index) {
          final propiedad = propiedades[index];
          final idPropiedadLiu = propiedad['Id'];
          final nombrePropiedad = propiedad['Name'] as String;
          final imagen = propiedad['Image'] as String;

          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                color: Color.fromARGB(167, 255, 255, 255),
              ),
              child: ExpansionTile(
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(33),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () async {
                              print('activar/desactivar $index');
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              // Guardar todas las variables necesarias
                              prefs.setString(
                                  'idPropiedad', idPropiedadLiu.toString());
                              prefs.setString(
                                  'nombrePropiedad', nombrePropiedad);
                              prefs.setString('imagenPropiedad', imagen);
                              prefs.setString('financialStatus',
                                  propiedad['FinancialStatus'] ?? 'N/A');
                              prefs.setInt('IdAssociation',
                                  propiedad['Assocation']['Id']);
                              prefs.setString('nombreFracc',
                                  propiedad['Assocation']['Name'] ?? 'N/A');
                              prefs.setString('asociacionTipo',
                                  propiedad['Assocation']['Type'] ?? 'N/A');
                              prefs.setString('asociacionCiudad',
                                  propiedad['Assocation']['City'] ?? 'N/A');
                              prefs.setString('asociacionProvincia',
                                  propiedad['Assocation']['Province'] ?? 'N/A');
                              prefs.setString('asociacionPais',
                                  propiedad['Assocation']['Country'] ?? 'N/A');

                              // Imprimir todas las variables guardadas
                              print(
                                  'idPropiedad: ${prefs.getString('idPropiedad')}');
                              print(
                                  'nombrePropiedad: ${prefs.getString('nombrePropiedad')}');
                              print(
                                  'imagenPropiedad: ${prefs.getString('imagenPropiedad')}');
                              print(
                                  'financialStatus: ${prefs.getString('financialStatus')}');
                              print(
                                  'IdAssociation: ${prefs.getInt('IdAssociation')}');
                              print(
                                  'asociacionNombre: ${prefs.getString('asociacionNombre')}');
                              print(
                                  'asociacionTipo: ${prefs.getString('asociacionTipo')}');
                              print(
                                  'asociacionCiudad: ${prefs.getString('asociacionCiudad')}');
                              print(
                                  'asociacionProvincia: ${prefs.getString('asociacionProvincia')}');
                              print(
                                  'asociacionPais: ${prefs.getString('asociacionPais')}');

                              // Verificar el rol del usuario
                              List<dynamic> rolesUser = propiedad['RolesUser'];
                              if (rolesUser.contains('Vecino')) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InicioWidget(
                                        responseJson: widget.responseJson),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IniciovigWidget(
                                        responseJson: widget.responseJson),
                                  ),
                                );
                              }
                            },
                            icon: idPropiedadLiu ==
                                    int.parse(
                                        prefs.getString('idPropiedad') ?? '-1')
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.blueAccent,
                                    size: 55,
                                  )
                                : Icon(
                                    Icons.circle,
                                    color: Colors.blueAccent,
                                    size: 55,
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                        child: Text(
                          '$nombrePropiedad',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 6, 3, 49),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Elige la propiedad que deseas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 6, 3, 49),
                            fontSize: 13,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> getListaDePropiedades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUsuario = prefs.getString('idUsuario');
    String? idPropiedadk = prefs.getString('idPropiedad');
    print('ejecutando propiedades');

    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetPropertiesNeighborByUser/';
    final body = {
      'idUser': idUsuario,
      'idProperty': idPropiedadk,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    print(idUsuario);
    print(idPropiedadk);
    if (response.statusCode == 200) {
      print('Entro a la Api de tags');
      final parsedJson = json.decode(response.body);
      print(parsedJson);
      final dataList = parsedJson['Data'] as List<dynamic>;
      final propiedadesList =
          json.decode(dataList[0]['Value']) as List<dynamic>;

      String financialStatus = propiedadesList.firstWhere(
          (prop) => prop['FinancialStatus'] != null)['FinancialStatus'];

      await prefs.setString('FinancialStatus', financialStatus);
      print(financialStatus);

      setState(() {
        propiedades = propiedadesList;
        isLoading = false; // Detener la pantalla de carga
      });
    } else {
      print('No entro a la Api');
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
      setState(() {
        isLoading =
            false; // Detener la pantalla de carga incluso en caso de error
      });
    }
  }
}
