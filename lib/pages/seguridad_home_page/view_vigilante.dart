import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../inicio/inicio_widget.dart';

class viewVigilante extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const viewVigilante({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _viewVigilante createState() => _viewVigilante();
}

class ContactosItem {
  final String id;
  final String icon;
  final String text1;
  final String text2;
  final String text3;
  final String numero;

  ContactosItem(
      {required this.id,
      required this.icon,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.numero});
}

List<ContactosItem> contactos = [
  ContactosItem(
      id: '1',
      icon: 'assets/images/_AUX..png',
      text1: 'Fernando Vargas',
      text2: 'Lunes/Martes',
      text3: 'provenza@habitan-t.com',
      numero: '7711719576'),
  ContactosItem(
      id: '2',
      icon: 'assets/images/_AUX..png',
      text1: 'Carlos Hernandez',
      text2: 'Miercoles/Jueves',
      text3: 'provenza@habitan-t.com',
      numero: '7711719576'),
  ContactosItem(
      id: '3',
      icon: 'assets/images/_AUX..png',
      text1: 'Cesar Martinez',
      text2: 'Viernes/Sabado',
      text3: 'provenza@habitan-t.com',
      numero: '7711719576')
];

class _viewVigilante extends State<viewVigilante> {
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));
    final responseJson = widget.responseJson;
    final _idPropiedad = widget.idPropiedad;
    final _idUsuario = widget.idUsuario;
    return Container(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BotonFlotante(
        responseJson: responseJson,
        accessCode: _accessCode,
        idPropiedad: _idPropiedad,
        idUsuario: _idUsuario,
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
                                    MediaQuery.of(context).size.height * 0.18),
                            contentVigilante(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),
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
              color: Color.fromRGBO(44, 255, 226, 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'VIGILANTE',
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

  Widget contentVigilante() {
    return Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.035,
            right: MediaQuery.of(context).size.width * 0.035),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Vigilancia",
                style: TextStyle(
                  color: Color(0xFF011D45),
                  fontSize: 20,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(contactos.length, (index) {
                final contacto = contactos[index];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.31,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        contacto.icon, width: 55, // Ancho deseado de la imagen
                        height: 55,
                      ),
                      Text(
                        contacto.text1,
                        style:
                            TextStyle(color: Color(0xFF4D4D4D), fontSize: 10),
                      ),
                      Text(
                        contacto.text2,
                        style: TextStyle(color: Color(0xFF011D45), fontSize: 8),
                      ),
                      Text(contacto.text3,
                          style:
                              TextStyle(color: Color(0xFF011D45), fontSize: 8)),
                      Text(contacto.numero,
                          style:
                              TextStyle(color: Color(0xFF011D45), fontSize: 8)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        width: 60,
                        height: 19,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Ajusta el valor de circular según el grado de redondez deseado
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF011D45))),
                          child: Text("Llamar",
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                color: Colors.white,
                                fontSize: 8,
                              )),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(contactos.length, (index) {
                final contacto = contactos[index];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.31,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        contacto.icon, width: 55, // Ancho deseado de la imagen
                        height: 55,
                      ),
                      Text(
                        contacto.text1,
                        style:
                            TextStyle(color: Color(0xFF4D4D4D), fontSize: 10),
                      ),
                      Text(
                        contacto.text2,
                        style: TextStyle(color: Color(0xFF011D45), fontSize: 8),
                      ),
                      Text(contacto.text3,
                          style:
                              TextStyle(color: Color(0xFF011D45), fontSize: 8)),
                      Text(contacto.numero,
                          style:
                              TextStyle(color: Color(0xFF011D45), fontSize: 8)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        width: 60,
                        height: 19,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Ajusta el valor de circular según el grado de redondez deseado
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF011D45))),
                          child: Text("Llamar",
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                color: Colors.white,
                                fontSize: 8,
                              )),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            FFButtonWidget(
              onPressed: () {},
              text: 'LLAMAR A CASETA',
              options: FFButtonOptions(
                width: 150.0,
                height: 40.0,
                color: Color.fromARGB(255, 1, 29, 69),
                textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(34.0),
              ),
            ),
          ],
        ));
  }
}
