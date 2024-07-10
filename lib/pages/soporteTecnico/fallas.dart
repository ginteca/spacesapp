import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class fallasPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const fallasPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _fallasPage createState() => _fallasPage();
}

class _fallasPage extends State<fallasPage> {
  late TextEditingController textFieldEnviarComment;
  late String _accessCode;
  @override
  void initState() {
    super.initState();
    textFieldEnviarComment = TextEditingController();
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
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            contentFallas(),
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

  contentFallas() {
    return Container(
        child: Column(children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.1,
        child: Image.asset('assets/images/falla.png'),
      ),
      Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.08,
          left: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.01,
        ),
        child: Container(
          child: Text(
            'REPORTE UNA FALLA',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 12,
                color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.08,
          left: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.01,
          top: MediaQuery.of(context).size.width * 0.12,
        ),
        child: Container(
          child: Text(
            '¿En qué podemos ayudarte?',
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
          right: MediaQuery.of(context).size.width * 0.1,
          left: MediaQuery.of(context).size.width * 0.1,
          bottom: MediaQuery.of(context).size.width * 0.03,
          top: MediaQuery.of(context).size.width * 0.04,
        ),
        child: Container(
          child: Text(
            'Si presentas fallas dentro de tu servicio carga por favor '
            'evidencia en esta sección y un experto te atenderá.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 12,
                color: Color.fromRGBO(0, 0, 0, 1)),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03,
              left: MediaQuery.of(context).size.width * 0.03,
              top: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.width * 0.03,
            ),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.18,
                decoration: BoxDecoration(
                    color: Color.fromARGB(66, 105, 117, 134),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(28)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.01,
                        left: MediaQuery.of(context).size.width * 0.01,
                        top: MediaQuery.of(context).size.width * 0.0,
                        bottom: MediaQuery.of(context).size.width * 0.01,
                      ),
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  iconSize: 45,
                                  icon: Image.asset(
                                      'assets/images/cargarPantalla.png',
                                      color: Colors.white),
                                  onPressed: () {}),
                            ]),
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03,
              left: MediaQuery.of(context).size.width * 0.08,
              top: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.width * 0.03,
            ),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.18,
                decoration: BoxDecoration(
                    color: Color.fromARGB(66, 105, 117, 134),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(28)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.01,
                        left: MediaQuery.of(context).size.width * 0.01,
                        top: MediaQuery.of(context).size.width * 0.0,
                        bottom: MediaQuery.of(context).size.width * 0.01,
                      ),
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  iconSize: 45,
                                  icon: Image.asset(
                                      'assets/images/cargaMas.png',
                                      color: Colors.white),
                                  onPressed: () {}),
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
              right: MediaQuery.of(context).size.width * 0.0,
              left: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                'Sube una captura de pantalla',
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
              right: MediaQuery.of(context).size.width * 0.03,
              left: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                'Cargar más...',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 12,
                    color: Color.fromRGBO(0, 0, 0, 1)),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.1,
          left: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Color.fromARGB(66, 105, 117, 134),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(28)),
          child: TextField(
            controller: textFieldEnviarComment,
            decoration: InputDecoration(
              // Cambia el color de fondo aquí

              hintText: 'Describe una respuesta...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(right: 50),
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      btnEnviar(),
    ]));
  }

  Widget btnEnviar() {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Color.fromARGB(164, 243, 243, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(27.0), // Bordes redondeados
                  ),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(children: [
                        Container(
                            alignment: Alignment.bottomCenter,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(104, 1, 29, 69),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(27),
                                    topRight: Radius.circular(27))),
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.cancel_outlined,
                                          size: 30,
                                          color:
                                              Color.fromARGB(255, 0, 236, 205),
                                          shadows: [
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Color.fromARGB(
                                                  255, 68, 68, 68),
                                            ),
                                          ]),
                                      iconSize: 30,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "FALLA REPORTADA",
                                    style: TextStyle(
                                        color: Color(0xFF2CFFE2),
                                        fontSize: 16,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                            left: MediaQuery.of(context).size.width * 0.05,
                            top: MediaQuery.of(context).size.width * 0.15,
                            bottom: MediaQuery.of(context).size.width * 0.15,
                          ),
                          child: Text(
                            'Tu falla ha sido reportada un técnico se pondrá en '
                            'contacto contigo para solucionarla',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.11,
                            left: MediaQuery.of(context).size.width * 0.11,
                            top: MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Entendido",
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(120, 43)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF011D45))),
                          ),
                        )
                      ]),
                    );
                  }),
                );
              });
        },
        child: Text("ENVIAR",
            style: TextStyle(
                fontFamily: 'Helvetica', fontWeight: FontWeight.bold)),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    34), // Ajusta el radio de borde para redondear el botón
              ),
            ),
            minimumSize: MaterialStateProperty.all<Size>(Size(120, 36)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF011D45))),
      ),
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
                  MaterialPageRoute(builder: (context) => PantallaCarrito()),
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
