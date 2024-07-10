import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert'; // Importa el paquete dart:convert

class SubtokenWidget extends StatefulWidget {
  final idUsuario;
  const SubtokenWidget({
    Key? key,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _SubtokenWidgetState createState() => _SubtokenWidgetState();
}

class _SubtokenWidgetState extends State<SubtokenWidget> {
  late String _IdUsuario = widget.idUsuario;
  final _token = TextEditingController();

// ...

  Future<void> nuevapropiedad1(String token, idUsuario) async {
    final String apiUrl =
        'https://appaltea.azurewebsites.net/api/Mobile/RegisterSubToken/';

    Map<String, String> data = {'Subtoken': token, 'idUser': idUsuario};

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: data,
    );

    if (response.statusCode == 200) {
      print(idUsuario);
      print(token);

      // Decodificar la respuesta JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Imprimir la respuesta JSON
      print('Respuesta JSON: $jsonResponse');

      // Manejo de la respuesta
      abrirNuevoModalsubto(context);
      print(token);
      print(idUsuario);
      print('Token enviado con éxito');
    } else {
      abrirNuevoModalfallo(context);
      // Manejo de errores
      throw Exception('Error al enviar el Token');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el color de la barra de notificaciones en blanco
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));

    //print(responseJson);
    return Container(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                            height: MediaQuery.of(context).size.width * 0.48,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Registrar Subtoken',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Helvetica'),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% del ancho de la pantalla
                            height: MediaQuery.of(context).size.height *
                                0.03, // 10% de la altura de la pantalla
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Escribe el token de acceso que te proporcionó el dueño de la propiedad',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Helvetica'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 25.0, 0.0, 0.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: _token,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'SubToken',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                  filled: true,
                                  fillColor: Color(0x4D011D45),
                                  prefixIcon: Icon(
                                    Icons.edit_note,
                                    color: Colors.white,
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% del ancho de la pantalla
                            height: MediaQuery.of(context).size.height *
                                0.1, // 10% de la altura de la pantalla
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Una vez registrado el token de acceso tu perfil de usuario sera vinculado a la propiedad',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Helvetica'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.01,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              print('boton recuperarggg');
                              String token = _token.text.trim();

                              String idUsuario = _IdUsuario;

                              print(token);
                              await nuevapropiedad1(token, idUsuario);
                            },
                            child: Text("REGISTRAR SUBTOKEN",
                                style: TextStyle(
                                  fontFamily: 'Helvetica Neue, Bold',
                                  fontSize: 14,
                                )),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        34), // Ajusta el radio de borde para redondear el botón
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(260, 44)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF011D45))),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.09,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Crea Un Subtoken',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Helvetica'),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% del ancho de la pantalla
                            height: MediaQuery.of(context).size.height *
                                0.1, // 10% de la altura de la pantalla
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Presiona el Boton si quieres crear un nuevo Subtoken para la propiedad',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Helvetica'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Aqui pon tu codigo xD
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonsBackHome() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
            'AGREGAR SUBTOKEN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2.4,
              fontWeight: FontWeight.bold,
              fontFamily: 'Helvetica',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
          child: IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/ICONOP.png'),
          ),
        ),
      ],
    );
  }
}

void abrirNuevoModalfallo(BuildContext context) {
  Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor:
            Color.fromARGB(186, 243, 243, 243), // Color de fondo del Dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0), // Bordes redondeados
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                //rgba(0, 15, 36, 1)
                width: 800,
                color: Color.fromRGBO(0, 15, 36, 0.308),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                      child: Text(
                        'Confirmado',
                        style: TextStyle(
                            color: Color.fromARGB(255, 7, 236, 225),
                            fontSize: 22),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 20.0),
                      child: Container(
                        child: Icon(
                          Icons.password,
                          size: 75,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Tu Subtoken esta registrado o no es valido',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),

              //Boton de recuperar
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 15.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    // buttonEntendido
                    print('Entendido');
                    Navigator.of(context).pop();
                  },
                  text: 'ENTENDIDO',
                  options: FFButtonOptions(
                    width: 150.0,
                    height: 40.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF011D45),
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
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
              ),
            ],
          ),
        ),
      );
    },
  );
}

void abrirNuevoModalsubto(BuildContext context) {
  Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor:
            Color.fromARGB(186, 243, 243, 243), // Color de fondo del Dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0), // Bordes redondeados
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                //rgba(0, 15, 36, 1)
                width: 800,
                color: Color.fromRGBO(0, 15, 36, 0.308),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                      child: Text(
                        'Confirmado',
                        style: TextStyle(
                            color: Color.fromARGB(255, 7, 236, 225),
                            fontSize: 22),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 20.0),
                      child: Container(
                        child: Icon(
                          Icons.password,
                          size: 75,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Tu Subtoken esta registrado regresa a la pantalla anterior',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),

              //Boton de recuperar
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 15.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    // buttonEntendido
                    print('Entendido');
                    Navigator.of(context).pop();
                  },
                  text: 'ENTENDIDO',
                  options: FFButtonOptions(
                    width: 150.0,
                    height: 40.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF011D45),
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
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
              ),
            ],
          ),
        ),
      );
    },
  );
}
