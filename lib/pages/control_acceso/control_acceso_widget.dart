import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../inicio/inicio_widget.dart';
import '../permanente/permanente_widget.dart';
import '../accesentrega/accesentrega_widget.dart';
import '../accesfiesta/accesfiesta_widget.dart';
import '../accesobra/accesobra_widget.dart';
import '../accesservicio/accesservicio_widget.dart';
import '../accespersonal/accespersonal_widget.dart';
import 'package:http/http.dart' as http;
import 'contolpage.dart'; // Asegúrate de que el nombre del archivo es correcto

class ControlAccesoWidget extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const ControlAccesoWidget({
    Key? key,
    required this.responseJson,
    required this.idPropiedad,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _ControlAccesoWidgetState createState() => _ControlAccesoWidgetState();
}

bool dispo = true;

class _ControlAccesoWidgetState extends State<ControlAccesoWidget> {
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/GetAccessCodeProfile/';
  late String _IdUsuario = widget.idUsuario;
  late String _IdPropiedad = widget.idPropiedad;
  bool _switchValue = true;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  Future<String> generarCodigo() async {
    String usuarioData = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> dataUsuario = jsonDecode(usuarioData);
    String PropertyData = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> dataProperty = jsonDecode(PropertyData);
    String idUser = (dataUsuario['Id']);
    String PropertyId = (dataProperty['Id']);

    Map<String, String> data = {'idUser': idUser, 'PropertyId': PropertyId};

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var codeApiResponse = jsonDecode(response.body);
      return codeApiResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  void _onDispoChanged(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dispo', newValue);
    setState(() {
      dispo = newValue;
    });
  }

  void _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dispo = prefs.getBool('dispo') ?? true; // Valor predeterminado como true
    });
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el color de la barra de notificaciones en blanco
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    final responseJson = widget.responseJson;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/FONDO_GENERAL.jpg'),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Color.fromRGBO(44, 255, 226, 1),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: FaIcon(FontAwesomeIcons.arrowLeft),
                  ),
                  Text(
                    'MI ACCESO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InicioWidget(
                            responseJson: widget.responseJson,
                          ),
                        ),
                      );
                    },
                    icon: Image.asset('assets/images/ICONOP.png'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15,
                      ),
                      child: Text(
                        'Disponibilidad para visita',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Column(
                        children: [
                          Switch(
                            value: dispo,
                            onChanged: (bool newValue) {
                              _onDispoChanged(newValue);
                            },
                          ),
                          Text(
                            dispo ? 'Sí' : 'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Text(
                        'Selecciona el tipo de visita:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Wrap(
                        spacing: MediaQuery.of(context).size.width * 0.05,
                        runSpacing: MediaQuery.of(context).size.height * 0.02,
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PermanenteWidget(
                                    responseJson: responseJson,
                                    idUsuario: _IdUsuario,
                                    idPropiedad: _IdPropiedad,
                                    AccessCode: _ControlAccesoWidgetState,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.check_circle),
                            label: Text('Visita Permanente'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF011D45),
                              foregroundColor: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccespersonalWidget(
                                    responseJson: responseJson,
                                    idUsuario: _IdUsuario,
                                    idPropiedad: _IdPropiedad,
                                    AccessCode: _ControlAccesoWidgetState,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.person),
                            label: Text('Visita Personal'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF011D45),
                              foregroundColor: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccesservicioWidget(
                                    responseJson: responseJson,
                                    idUsuario: _IdUsuario,
                                    idPropiedad: _IdPropiedad,
                                    AccessCode: _ControlAccesoWidgetState,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.house),
                            label: Text('Visita de Servicio'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF011D45),
                              foregroundColor: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccesfiestaWidget(
                                    responseJson: responseJson,
                                    idUsuario: _IdUsuario,
                                    idPropiedad: _IdPropiedad,
                                    AccessCode: _ControlAccesoWidgetState,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.celebration),
                            label: Text('Fiesta o Reunión'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF011D45),
                              foregroundColor: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccesentregaWidget(
                                    responseJson: responseJson,
                                    idUsuario: _IdUsuario,
                                    idPropiedad: _IdPropiedad,
                                    AccessCode: _ControlAccesoWidgetState,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.local_shipping),
                            label: Text('Aviso de Entrega'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF011D45),
                              foregroundColor: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccesobraWidget(
                                    responseJson: responseJson,
                                    idUsuario: _IdUsuario,
                                    idPropiedad: _IdPropiedad,
                                    AccessCode: _ControlAccesoWidgetState,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.construction),
                            label: Text('Personal de Obra'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF011D45),
                              foregroundColor: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            iconSize: 50,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ControlAccesoPage(
                                    responseJson: widget.responseJson,
                                    idPropiedad: widget.idPropiedad,
                                    idUsuario: widget.idUsuario,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.save, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ControlAccesoPage(
                                    responseJson: widget.responseJson,
                                    idPropiedad: widget.idPropiedad,
                                    idUsuario: widget.idUsuario,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Códigos Guardados",
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
