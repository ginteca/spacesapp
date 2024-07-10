import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../inicio/carrito_widget.dart';
import '../inicio/inicio_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import '../reservaciones/reservaWidget.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class AccesentregaWidget extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;
  const AccesentregaWidget(
      {Key? key,
      required this.responseJson,
      required this.idPropiedad,
      required this.idUsuario,
      required this.AccessCode})
      : super(key: key);

  @override
  _AccesentregaWidgetState createState() => _AccesentregaWidgetState();
}

class _AccesentregaWidgetState extends State<AccesentregaWidget> {
  String? selectcode;
  late String _idPropiedad = '';
  late TextEditingController textFieldEnviarselect;
  late String textoQR = codigo;
  late String usuarioId = widget.idUsuario;
  late String propiedadId = widget.idPropiedad;
  late String codigo = '';
  late String Description = 'Otros';
  late String Type = 'Entrega';

// botones inicio
  String selectedOption = '';

  void _selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  Widget _buildButton(String optionText) {
    final isSelected = selectedOption == optionText;
    return ElevatedButton(
      onPressed: () => _selectOption(optionText),
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Color(0xFF2CFFE2) : Color(0x4D011D45),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(40), // Establecer el radio del borde
        ),
        minimumSize: Size(200, 50), // Establecer el tamaño mínimo
      ),
      child: Text(
        optionText,
        style: TextStyle(
          fontSize: 18,
          color: isSelected
              ? Color(0xFF011D45)
              : Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
// botones final

  Future<void> generarCodigo() async {
    print(usuarioId);
    print(propiedadId);
    print('entrando a generar codigo');
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/SaveAdviceDelivery/'; // Reemplaza con la URL de tu API

    // Datos que deseas enviar en el cuerpo de la solicitud
    final body = {
      'IdUser': usuarioId,
      'PropertyId': propiedadId,
      'Description': Description,
      'Type': Type,
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

      //codigoacceso
      //codigo1 = parsedJson['Value'].toString();
      // setText();
      abrirNuevoModalentrega(context);
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
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
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
                                      MediaQuery.of(context).size.width * 0.48,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    '¿Qué tipo de entrega esperas?',
                                    style: TextStyle(
                                        color: Color(0xFF011D45),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Helvetica'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 25.0, 0.0, 0.0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _buildButton('Paquetería'),
                                        SizedBox(height: 20),
                                        _buildButton('Alimentos y Bebidas'),
                                        SizedBox(height: 20),
                                        _buildButton('Otros'),
                                        SizedBox(height: 20),
                                        Text(
                                          'Opción seleccionada: $selectedOption',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF011D45)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          generarCodigo();
                                        },
                                        child: Text("GENERAR ACCESO",
                                            style: TextStyle(
                                              fontFamily:
                                                  'Helvetica Neue, Bold',
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
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(260, 44)),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Color(0xFF011D45))),
                                      ),
                                      Text(
                                        'Una vez generando el código lo podrás compartir con tu visita',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //Aqui pon tu codigo xD
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
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
            'Acceso Entrega',
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

void abrirNuevoModalentrega(BuildContext context) {
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
                          Icons.delivery_dining,
                          size: 75,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Se a enviado tu aviso correctamente',
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
