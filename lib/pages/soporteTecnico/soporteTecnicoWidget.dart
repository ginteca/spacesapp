import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacesclub/pages/soporteTecnico/preguntas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../control_acceso/control_acceso_widget.dart';
import '../inicio/carrito_widget.dart';
import '../mi_acceso/mi_acceso_widget.dart';
import '../mi_acceso/mi_cobro_widget.dart';
import '../reservaciones/reservaWidget.dart';
import '../seguridad_home_page/view_SOS.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../pages/inicio/inicio_widget.dart';
import 'contacto.dart';
import 'fallas.dart';
import 'introduccionApp.dart';

class soportePage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const soportePage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _soportePage createState() => _soportePage();
}

class _soportePage extends State<soportePage> {
  late String _accessCode;

  @override
  void initState() {
    super.initState();
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    _accessCode = data['AccessCode'].toString();
  }

  @override
  Widget build(BuildContext context) {
    final responseJson = widget.responseJson;
    final _idPropiedad = widget.idPropiedad;
    final _idUsuario = widget.idUsuario;
    return Container(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BotonFlotante(
        responseJson: responseJson,
        accessCode: '',
        idPropiedad: widget.idPropiedad,
        idUsuario: widget.idUsuario,
      ),
      bottomNavigationBar: barranavegacion(
        responseJson: responseJson,
        idPropiedad: _idPropiedad,
        idUsuario: _idUsuario,
        accessCode: _accessCode,
      ),
      body: Builder(
          builder: (context) => SafeArea(
                  child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        height: MediaQuery.of(context).size.height * 1.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.asset(
                              'assets/images/FONDO_GENERAL.jpg',
                            ).image,
                          ),
                        ),
                        child: Column(
                          children: [
                            buttonsBackHome(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07),
                            contentSoporte(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    ));
  }

  Widget buttonsBackHome() {
    final responseJson = widget.responseJson;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
          child: IconButton(
              //rgba(44, 255, 226, 1)
              color: Color.fromRGBO(255, 255, 255, 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'AVISOS Y REPORTES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
          child: IconButton(
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
        )
      ],
    );
  }

  contentSoporte() {
    final responseJson = widget.responseJson;
    final _idUsuario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;

    return Container(
        child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.11,
          width: MediaQuery.of(context).size.width * 0.21,
          child: Image.asset('assets/images/charlyLogo.png'),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.02,
            bottom: MediaQuery.of(context).size.width * 0.03,
          ),
          child: Container(
            child: Text(
              '¡Hola soy Charly!',
              style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 47, 134, 255)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.0,
            bottom: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Container(
            child: Text(
              '¿Tienes un problema?',
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          child: Text(
            '¿COMO TE PUEDO AYUDAR?',
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 50, 120, 1)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03,
                left: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.width * 0.09,
                bottom: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.38,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(66, 1, 29, 69),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.01,
                          left: MediaQuery.of(context).size.width * 0.01,
                          top: MediaQuery.of(context).size.width * 0.01,
                          bottom: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    iconSize: 70,
                                    icon: Image.asset(
                                        'assets/images/induccionApp.png',
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                introduccionPage(
                                                  responseJson: responseJson,
                                                  idUsuario: _idUsuario,
                                                  idPropiedad: _idPropiedad,
                                                )),
                                      );
                                    }),
                                Text(
                                  'Inducción a la App',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03,
                left: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.width * 0.09,
                bottom: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.38,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(66, 1, 29, 69),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.01,
                          left: MediaQuery.of(context).size.width * 0.01,
                          top: MediaQuery.of(context).size.width * 0.04,
                          bottom: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    iconSize: 50,
                                    icon: Image.asset(
                                        'assets/images/preguntasFrecuentes.png',
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => preguntasPage(
                                                  responseJson: responseJson,
                                                  idUsuario: _idUsuario,
                                                  idPropiedad: _idPropiedad,
                                                )),
                                      );
                                    }),
                                Text(
                                  'Preguntas frecuentes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03,
                left: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.width * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.38,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(66, 1, 29, 69),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.01,
                          left: MediaQuery.of(context).size.width * 0.01,
                          top: MediaQuery.of(context).size.width * 0.03,
                          bottom: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    iconSize: 60,
                                    icon: Image.asset('assets/images/falla.png',
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => fallasPage(
                                                  responseJson: responseJson,
                                                  idUsuario: _idUsuario,
                                                  idPropiedad: _idPropiedad,
                                                )),
                                      );
                                    }),
                                Text(
                                  'Reporta una falla',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03,
                left: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.width * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.38,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(66, 1, 29, 69),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.01,
                          left: MediaQuery.of(context).size.width * 0.01,
                          top: MediaQuery.of(context).size.width * 0.03,
                          bottom: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    iconSize: 55,
                                    icon: Image.asset(
                                        'assets/images/contacto.png',
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => contactoPage(
                                                  responseJson: responseJson,
                                                  idUsuario: _idUsuario,
                                                  idPropiedad: _idPropiedad,
                                                )),
                                      );
                                    }),
                                Text(
                                  'Ponerse en contácto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        )
      ],
    ));
  }
}

class barranavegacion extends StatelessWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final accessCode;

  const barranavegacion({
    super.key,
    required this.responseJson,
    required this.idPropiedad,
    required this.idUsuario,
    required this.accessCode,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.width * 0.17,
        child: ClipRRect(
          child: BottomNavigationBar(
            backgroundColor: Color.fromARGB(183, 3, 15, 145),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/icr.png',
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                label: 'Reservaciones',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/CARRITO.png',
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                label: 'Carrito',
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReservationsScreen()),
                );
              }
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PantallaCarrito(idPropiedad: idPropiedad, idUsuario: idUsuario, responseJson: responseJson,)),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class BotonFlotante extends StatelessWidget {
  final Map<String, dynamic> responseJson;
  final String idUsuario;
  final String idPropiedad;
  final String accessCode;

  const BotonFlotante({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.accessCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.4, // Ajusta el valor del ancho según sea necesario
      height: MediaQuery.of(context).size.width *
          0.26, // Ajusta el valor del alto según sea necesario
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Establece la forma del botón como un círculo
        border: Border.all(
            color: Color.fromARGB(255, 255, 255, 255),
            width: 10.0), // Agrega un borde blanco alrededor del botón
      ),
      child: FloatingActionButton(
        backgroundColor: Color.fromARGB(
            255, 3, 16, 145), // Establece el color de fondo del botón
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MiCobroWidget(
              responseJson: responseJson,
              idUsuario: idUsuario,
              idPropiedad: idPropiedad,
              AccessCode: accessCode,
            ),
          ));
          print('Hola Mundo');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/4.png',
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
