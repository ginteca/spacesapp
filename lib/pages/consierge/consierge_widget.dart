export 'consierge_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../inicio/carrito_widget.dart';
import '../inicio/inicio_widget.dart';
import 'dart:async';
import 'dart:convert';
import '../mi_acceso/mi_acceso_widget.dart';
import '../reservaciones/reservaWidget.dart';
import '../reservaciones/reservacionesWidget.dart';
import '../seguridad_home_page/view_SOS.dart';
import 'carrito_widget.dart';
import 'tecnologia_widget.dart';

class consierge extends StatefulWidget {
  @override
  _consiergeState createState() => _consiergeState();
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;

  const consierge({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.AccessCode,
  }) : super(key: key);
}

class _consiergeState extends State<consierge> {
  List<dynamic> tags = [];
  void initState() {
    super.initState();
    apiCall();
  }

  Future<void> apiCall() async {
    print('ejecutanndo tags');
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetTagsProperty/';

    final body = {
      'PropertyId': '8207',
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
      print('Entro a la Api de tags');
      final parsedJson = json.decode(response.body);
      print(parsedJson);
      final dataList = parsedJson['Data'] as List<dynamic>;
      final tagsList = json.decode(dataList[0]['Value']) as List<dynamic>;

      setState(() {
        tags = tagsList;
      });
      //codigoacceso

      // setText();
    } else {
      // La solicitud falló
      print('No entro a la Api');
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));
    final responseJson = widget.responseJson;
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final _accessCode = widget.AccessCode;
    //print(responseJson);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BotonFlotante(
        responseJson: widget.responseJson,
      ),
      bottomNavigationBar: barranavegacion(
        responseJson: widget.responseJson,
        idPropiedad: _idPropiedad,
        idUsuario: _idUsario,
        accessCode: _accessCode,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/FONDO_GENERAL.jpg',
              ), // Ruta de la imagen
              fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
            ),
          ),
          child: Column(
            children: [
              buttonsBackHome(),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.14,
              ),
              carritoCompras(),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.0,
              ),
              contentconserge(),
            ],
          ),
        ),
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
            'CONSIERGE',
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

  Widget carritoCompras() {
    final responseJson = widget.responseJson;
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final _accessCode = widget.AccessCode;
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 1,
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.0,
            left: MediaQuery.of(context).size.width * 0.8,
            top: MediaQuery.of(context).size.width * 0.0,
            bottom: MediaQuery.of(context).size.width * 0.0,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _customSizedFloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => carritoCompra(
                              responseJson: widget.responseJson,
                              idUsuario: _idUsario,
                              idPropiedad: _idPropiedad,
                              AccessCode: _accessCode,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/carrito.png',
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.08,
                      ),
                    ),
                    Text(
                      'Ver carrito (1)',
                      style: TextStyle(
                        color: Color(0xFF1890F7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customSizedFloatingActionButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: MediaQuery.of(context).size.width *
              0.0022, // Escala del botón flotante (ajusta según tus necesidades)
          child: FloatingActionButton(
            onPressed: onPressed,
            child: child,
            backgroundColor: Color.fromARGB(0, 1, 29, 69),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  contentconserge() {
    final responseJson = widget.responseJson;
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final _accessCode = widget.AccessCode;
    return Container(
        child: Column(children: [
      //BARRA 1 INICIO
      InkWell(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/robot.jpg'),
              fit: BoxFit.cover,
            ),
            color: Color(0xFF801EF5),
            borderRadius: BorderRadius.circular(29),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x635D83CC),
                borderRadius: BorderRadius.circular(29),
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 75.0, // Espacio a la izquierda
                      top: MediaQuery.of(context).size.width * 0.03,
                      bottom: MediaQuery.of(context).size.width * 0.0,
                    ),
                    child: Container(
                      child: Text(
                        'TECNOLOGÍA',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.0, // Espacio a la izquierda
                      top: 8.0,
                    ),
                    child: Container(
                      child: Text(
                        'Encuentra los artículos indispensables para tu \n hogar a los mejores precios.',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 10,
                          fontFamily: 'Helvetica',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 10), // Espacio vertical entre el texto y el botón
                  Padding(
                    padding: EdgeInsets.only(
                      left: 75.0, // Espacio a la izquierda
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TecnologiaProduc(
                                responseJson: responseJson,
                                idUsuario: _idUsario,
                                idPropiedad: _idPropiedad,
                                AccessCode: _accessCode),
                          ),
                        );
                      },
                      child: Text(
                        'VER MÁS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF2CFFE2), // Color de fondo del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      //BARRA 1 FINAL

      //BARRA 2 INICIO
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.015,
      ),
      Container(
          height: MediaQuery.of(context).size.height * 0.43,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/internet.jpg'),
                              fit: BoxFit.cover,
                            ),
                            color: Color(0xFF801EF5),
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0x635D83CC),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            width: MediaQuery.of(context).size.width * 0.46,
                          ),
                        ),
                      ),
                      SizedBox(width: 15), // Espacio entre el InkWell y el Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'INTERNET Y MEDIOS',
                                style: TextStyle(
                                  color: Color(0xFF1890F7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ), // Espacio entre el Text y el siguiente texto
                            Text(
                              'Encuentra los artículos indispensables \n para tu  hogar a los mejores precios.',
                              style: TextStyle(
                                color: Color(0xFF011D45),
                                fontSize: 8,
                              ),
                            ),
                            SizedBox(
                                height: 5), // Espacio entre el texto y el botón
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TecnologiaProduc(
                                          responseJson: responseJson,
                                          idUsuario: _idUsario,
                                          idPropiedad: _idPropiedad,
                                          AccessCode: _accessCode),
                                    ),
                                  );
                                },
                                child: Text(
                                  'VER MÁS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      0xFF011D45), // Color de fondo del botón
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
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
                //BARRA 2 FINAL

                //BARRA 3 INICIO
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/mantenimiento.jpg'),
                              fit: BoxFit.cover,
                            ),
                            color: Color(0xFF801EF5),
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0x635D83CC),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            width: MediaQuery.of(context).size.width * 0.46,
                          ),
                        ),
                      ),
                      SizedBox(width: 15), // Espacio entre el InkWell y el Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'MANTENIMIENTO',
                                style: TextStyle(
                                  color: Color(0xFF1890F7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ), // Espacio entre el Text y el siguiente texto
                            Text(
                              'Encuentra los artículos indispensables \n para tu  hogar a los mejores precios.',
                              style: TextStyle(
                                color: Color(0xFF011D45),
                                fontSize: 8,
                              ),
                            ),
                            SizedBox(
                                height: 5), // Espacio entre el texto y el botón
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TecnologiaProduc(
                                          responseJson: responseJson,
                                          idUsuario: _idUsario,
                                          idPropiedad: _idPropiedad,
                                          AccessCode: _accessCode),
                                    ),
                                  );
                                },
                                child: Text(
                                  'VER MÁS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      0xFF011D45), // Color de fondo del botón
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
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
                //BARRA 3 FINAL

                //BARRA 4 INICIO
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/decoracion.jpg'),
                              fit: BoxFit.cover,
                            ),
                            color: Color(0xFF801EF5),
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0x635D83CC),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            width: MediaQuery.of(context).size.width * 0.46,
                          ),
                        ),
                      ),
                      SizedBox(width: 15), // Espacio entre el InkWell y el Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'DECORACIÓN',
                                style: TextStyle(
                                  color: Color(0xFF1890F7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ), // Espacio entre el Text y el siguiente texto
                            Text(
                              'Encuentra los artículos indispensables \n para tu  hogar a los mejores precios.',
                              style: TextStyle(
                                color: Color(0xFF011D45),
                                fontSize: 8,
                              ),
                            ),
                            SizedBox(
                                height: 5), // Espacio entre el texto y el botón
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TecnologiaProduc(
                                          responseJson: responseJson,
                                          idUsuario: _idUsario,
                                          idPropiedad: _idPropiedad,
                                          AccessCode: _accessCode),
                                    ),
                                  );
                                },
                                child: Text(
                                  'VER MÁS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      0xFF011D45), // Color de fondo del botón
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
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
                //BARRA 4 FINAL
              ],
            ),
          ))
    ]));
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
  final responseJson;
  const BotonFlotante({
    super.key,
    required this.responseJson,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.2, // Ajusta el valor del ancho según sea necesario
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
        child: Image.asset(
          'assets/images/S.O.S.png',
          width: 80,
          height: 60,
        ), // Cambia el icono por la imagen
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => viewSOS(
              responseJson: responseJson,
            ),
          ));
          print('Hola Mundo');
        },
      ),
    );
  }
}
