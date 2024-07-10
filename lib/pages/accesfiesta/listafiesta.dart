import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../inicio/inicio_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

String _selectedOption = ''; // Variable para almacenar la opción seleccionada
List<String> _options = ['Opción 1', 'Opción 2'];

class ListaFiesta extends StatefulWidget {
  final responseJson;
  final idUsuario;

  const ListaFiesta({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _ListaFiestaState createState() => _ListaFiestaState();
}

class _ListaFiestaState extends State<ListaFiesta> {
  String? selectcode;
  List<String> selectcodelist = ['Servicio', 'Permanente'];
  late String _idPropiedad = '';
  late TextEditingController textFieldEnviarselect;
  late String textoQR = codigo;
  late String usuarioId = widget.idUsuario;

  late String codigo = '';
  late String Description = 'FERNANDO';
  late String Validity = '09/15/2023';
  late String TypePermanent = 'Servicio';
  late String Type = 'Permanente';
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    textFieldEnviarselect = TextEditingController();
  }

  String selectedtext = '';
  int numberOfTextFields = 0; // Número de TextFields a mostrar
  List<Widget> textFieldList = [];

  Future<void> generarCodigo() async {
    print(usuarioId);

    print('entrando a generar codigo');
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetAccessCode/'; // Reemplaza con la URL de tu API

    // Datos que deseas enviar en el cuerpo de la solicitud
    final body = {
      'IdUser': usuarioId,
      'Description': Description,
      'Type': Type,
      'Validity': Validity,
      'TypePermanent': TypePermanent,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // La solicitud fue exitosa, analiza la respuesta JSON
      print('Entro a la Api');

      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      //codigoacceso
      codigo = jsonResponse['Data'][0]['Value'];
      //codigo1 = parsedJson['Value'].toString();
      print(codigo);
      // setText();
      showModal(context);
    } else {
      // La solicitud falló
      print('No entro a la Api');
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el color de la barra de notificaciones en blanco
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));

    final responseJson = widget.responseJson;
    //print(responseJson);
    final String textoQR = '123456';
    return Container(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: BotonFlotante(),
        bottomNavigationBar: barranavegacion(),
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
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    .0, 0.0, 0.0, 0.0),
                                child: IconButton(
                                    //rgba(44, 255, 226, 1)
                                    color: Color.fromRGBO(44, 255, 226, 1),
                                    onPressed: () {
                                      print('hello');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InicioWidget(
                                                responseJson: responseJson)),
                                      );
                                      //context.pushNamed('inicio');
                                    },
                                    icon: FaIcon(FontAwesomeIcons.arrowLeft)),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'ACCESO PERMANENTE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Helvetica'),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.13,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InicioWidget(
                                              responseJson: responseJson)),
                                    );
                                  },
                                  icon: Image.asset('assets/images/ICONOP.png'),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 180.0, 0.0, 0.0),
                            child: Text(
                              'Lista de Invitados',
                              style: TextStyle(
                                  color: Color(0xFF1890F7),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Helvetica'),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: MediaQuery.of(context).size.width * 0.7,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: textFieldList,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 25.0, 0.0, 0.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: TextFormField(
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'Invitado...',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                              borderRadius:
                                                  BorderRadius.circular(34.0),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(34.0),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(34.0),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(34.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                Color.fromARGB(157, 83, 83, 83),
                                            prefixIcon: Icon(
                                              Icons.person,
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
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: addTextField,
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Color(0xFF011D45),
                                  size: 40,
                                ),
                              ),
                              IconButton(
                                onPressed: removeTextField,
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Color(0xFF011D45),
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Listo",
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

  void addTextField() {
    setState(() {
      numberOfTextFields++;
      textFieldList.add(
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextFormField(
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Invitado...',
                hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
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
                fillColor: Color.fromARGB(157, 83, 83, 83),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      );
    });
  }

  void removeTextField() {
    setState(() {
      if (numberOfTextFields > 0) {
        textFieldList.removeLast();
        numberOfTextFields--;
      }
    });
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Color.fromRGBO(1, 29, 69, 0),
        builder: (BuildContext context) {
          bool isFinished = false;
          return Dialog(
            alignment: Alignment.center,
            backgroundColor:
                Color.fromRGBO(255, 255, 255, 0.435).withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.0), // Bordes redondeados
            ),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 1,
                child: Column(children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(0, 255, 255, 255),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(27),
                            topRight: Radius.circular(27))),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Tú Código es...",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.45,
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.00,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              10), // Agregar bordes redondeados
                          border: Border.all(
                            color: Colors.black,
                            width: 5,
                          ),
                        ),
                        child: QrImageView(
                          data: codigo,
                          version: QrVersions.auto,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.0,
                          left: MediaQuery.of(context).size.width * 0.0,
                          top: MediaQuery.of(context).size.width * 0.0,
                          bottom: MediaQuery.of(context).size.width * 0.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.share,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () async {},
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 1.0,
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.0,
                          left: MediaQuery.of(context).size.width * 0.0,
                          top: MediaQuery.of(context).size.width * 0.0,
                          bottom: MediaQuery.of(context).size.width * 0.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10), // Agregar bordes redondeados
                        ),
                        child: Container(
                          width: 250,
                          height: 43,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(1, 29, 69, 1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                              child: Text(
                            codigo,
                            style: TextStyle(
                                //rgba(1, 29, 69, 1)
                                letterSpacing: 6,
                                fontSize: 35,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ],
                  )
                ]),
              );
            }),
          ); //accesosModal();
        });
  }
}

class barranavegacion extends StatelessWidget {
  const barranavegacion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.width *
          0.16, // Ajusta el valor del ancho según sea necesario
      child: ClipRRect(
        child: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(
              1, 29, 69, 1), // Set the background color of the navigation bar
          selectedItemColor: Colors.white, // Set the color of the selected item
          unselectedItemColor:
              Colors.white, // Set the color of the unselected items
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/RESERVACIONES.png',
                  width: 40, height: 25), // Cambia el icono por la imagen
              label: 'Reservaciones',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/MIACCESO.png',
                  width: 40, height: 24), // Cambia el icono por la imagen
              label: 'Mi Acceso',
            ),
          ],
        ),
      ),
    );
  }
}

class BotonFlotante extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.90, // Ajusta el valor del ancho según sea necesario
      height: MediaQuery.of(context).size.width *
          0.2, // Ajusta el valor del alto según sea necesario
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Establece la forma del botón como un círculo
        border: Border.all(
            color: Colors.white,
            width: 10.0), // Agrega un borde blanco alrededor del botón
      ),
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(
            1, 29, 69, 1), // Establece el color de fondo del botón
        child: Image.asset('assets/images/S.O.S.png',
            width: 80, height: 60), // Cambia el icono por la imagen
        onPressed: () {
          print('Hola Mundo');
        },
      ),
    );
  }
}
