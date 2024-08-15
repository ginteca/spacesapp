import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../control_acceso/control_acceso_widget.dart';
import '../inicio/carrito_widget.dart';
import '../mi_acceso/mi_acceso_widget.dart';
import '../mi_acceso/mi_cobro_widget.dart';
import '../reservaciones/reservaWidget.dart';
import '../seguridad_home_page/view_SOS.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../pages/inicio/inicio_widget.dart';

class contactoPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const contactoPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _contactoPage createState() => _contactoPage();
}

class _contactoPage extends State<contactoPage> {
  late TextEditingController textFieldEnviarNombre;
  late TextEditingController textFieldEnviarCorreo;
  late TextEditingController textFieldEnviarAsunto;
  late TextEditingController textFieldEnviarToken;
  late TextEditingController textFieldEnviarToken1;
  String selectedtext = '';
  late String _accessCode;
  @override
  void initState() {
    super.initState();
    textFieldEnviarNombre = TextEditingController();
    textFieldEnviarCorreo = TextEditingController();
    textFieldEnviarAsunto = TextEditingController();
    textFieldEnviarToken = TextEditingController();
    textFieldEnviarToken1 = TextEditingController();
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    _accessCode = data['AccessCode'].toString();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
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
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            contentContacto(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
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
            'SOPORTE TÉCNICO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2.4,
              fontFamily: 'Helvetica Neue, Bold',
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
        ),
      ],
    );
  }

  contentContacto() {
    return Container(
      child: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.09,
          child: Image.asset('assets/images/contacto.png'),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.08,
            left: MediaQuery.of(context).size.width * 0.08,
            bottom: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Container(
            child: Text(
              'PONERSE EN CONTÁCTO',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  color: Color.fromRGBO(255, 255, 255, 1)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.04,
            left: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.01,
            top: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Container(
            child: Text(
              'Contacta con nosotros',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(67, 66, 93, 1)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.04,
            left: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.01,
            top: MediaQuery.of(context).size.width * 0.06,
          ),
          child: Container(
            child: Text(
              'Rellena este formulario y estaremos encantados de devolverte'
              'la llamada.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 12,
                  color: Color.fromRGBO(0, 0, 0, 1)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.04,
            left: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.0,
            top: MediaQuery.of(context).size.width * 0.0,
          ),
          child: Container(
            child: Text(
              'O si lo prefieres envianos un WhatsApp al (771) 532 6002',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 12,
                  color: Color.fromRGBO(0, 0, 0, 1)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.04,
            left: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.0,
            top: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Container(
            child: Text(
              'Te acompañamos durante todo el proceso.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 12,
                  color: Color.fromRGBO(0, 0, 0, 1)),
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.15,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.width * 0.01,
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldEnviarNombre,
                  onChanged: (value) {
                    setState(() {
                      selectedtext = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(
                        66, 105, 117, 134), // Cambia el color de fondo aquí
                    hintText: 'Nombre completo...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Ajusta el radio del borde aquí
                    ),
                    // Ajusta el espaciado del texto dentro del TextField
                  ),
                ),
              ],
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.15,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.01,
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldEnviarCorreo,
                  onChanged: (value) {
                    setState(() {
                      selectedtext = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(
                        66, 105, 117, 134), // Cambia el color de fondo aquí
                    hintText: 'Correo electrónico (requerido)...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Ajusta el radio del borde aquí
                    ),
                    // Ajusta el espaciado del texto dentro del TextField
                  ),
                ),
              ],
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.15,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.01,
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldEnviarAsunto,
                  onChanged: (value) {
                    setState(() {
                      selectedtext = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(
                        66, 105, 117, 134), // Cambia el color de fondo aquí
                    hintText: 'Asunto...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Ajusta el radio del borde aquí
                    ),
                    // Ajusta el espaciado del texto dentro del TextField
                  ),
                ),
              ],
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.15,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.01,
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldEnviarToken,
                  onChanged: (value) {
                    setState(() {
                      selectedtext = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(
                        66, 105, 117, 134), // Cambia el color de fondo aquí
                    hintText: 'XXXXXXXX...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Ajusta el radio del borde aquí
                    ),
                    // Ajusta el espaciado del texto dentro del TextField
                  ),
                ),
              ],
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.15,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.01,
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldEnviarToken1,
                  onChanged: (value) {
                    setState(() {
                      selectedtext = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,

                    fillColor: Color.fromARGB(
                        66, 105, 117, 134), // Cambia el color de fondo aquí
                    hintText: 'XXXXXXXX...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Ajusta el radio del borde aquí
                    ),

                    // Ajusta el espaciado del texto dentro del TextField
                  ),
                ),
              ],
            )),
        Container(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.11,
            left: MediaQuery.of(context).size.width * 0.11,
            top: MediaQuery.of(context).size.width * 0.03,
          ),
          child: ElevatedButton(
            onPressed: () {},
            child: Text("ENVIAR",
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                )),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(130, 36)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF011D45))),
          ),
        )
      ]),
    );
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
