import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../inicio/carrito_widget.dart';
import '../inicio/inicio_widget.dart';
import '../mi_acceso/mi_acceso_widget.dart';
import '../reservaciones/reservaWidget.dart';
import '../reservaciones/reservacionesWidget.dart';
import '../seguridad_home_page/view_SOS.dart';
import 'carrito_widget.dart';

class TecnologiaProduc extends StatefulWidget {
  @override
  _TecnologiaProducState createState() => _TecnologiaProducState();
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;

  const TecnologiaProduc({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.AccessCode,
  }) : super(key: key);
}

class _TecnologiaProducState extends State<TecnologiaProduc> {
  List<dynamic> tags = [];
  void initState() {
    super.initState();
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
              TecnoContainer(),
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
            'ARTICULOS DE \n TECNOLOGÍA',
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
                                responseJson: responseJson,
                                idUsuario: _idUsario,
                                idPropiedad: _idPropiedad,
                                AccessCode: _accessCode),
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

  Widget TecnoContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.632,
      width: MediaQuery.of(context).size.width * 0.95,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Columna izquierda
            Column(
              children: <Widget>[
                // Imagen 1.1 Inicio
                Image.asset(
                  'assets/images/mouse.jpg',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Mouse inalámbrico',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011D45),
                  ),
                ),
                Text(
                  'Marca Phillips',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  '\$2,424.ºº',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                //imagen 1.1 fin
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                //imagen 1.2 inicio
                Image.asset(
                  'assets/images/camaraseg1.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Camara de videovigilancia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011D45),
                  ),
                ),
                Text(
                  'Marca Phillips',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  '\$2,424.ºº',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                //imagen 1.2 fin
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                //imagen 1.3 inicio
                Image.asset(
                  'assets/images/camaraseg2.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Camara de videovigilancia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011D45),
                  ),
                ),
                Text(
                  'Marca Phillips',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  '\$2,424.ºº',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                //imagen 1.3 fin
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                //imagen 1.4 inicio
                Image.asset(
                  'assets/images/camaraseg6.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Camara de videovigilancia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011D45),
                  ),
                ),
                Text(
                  'Marca Phillips',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  '\$2,424.ºº',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                //imagen 1.4 fin
              ],
            ),
            ///////////////////////////
            //SizedBox(width: 22),        // Columna derecha

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            ///////////////////////////
            Column(
              children: <Widget>[
                // Imagen 2.1 Inicio
                Image.asset(
                  'assets/images/camaraseg3.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Camara de videovigilancia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011D45),
                  ),
                ),
                Text(
                  'Marca Phillips',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  '\$2,424.ºº',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                //imagen 2.1 fin
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                //imagen 2.2 inicio
                Image.asset(
                  'assets/images/camaraseg4.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Camara de videovigilancia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011D45),
                  ),
                ),
                Text(
                  'Marca Phillips',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  '\$2,424.ºº',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                //imagen 2.2 Fin
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                //imagen 2.3 inicio
                Image.asset(
                  'assets/images/camaraseg5.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Camara de videovigilancia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011D45),
                  ),
                ),
                Text(
                  'Marca Phillips',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  '\$2,424.ºº',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                //imagen 2.3 fin
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                //imagen 2.4 inicio
                Image.asset(
                  'assets/images/camaraseg7.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Camara de videovigilancia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011D45),
                  ),
                ),
                Text(
                  'Marca Phillips',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  '\$2,424.ºº',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                //imagen 2.4 fin
              ],
            ),
          ],
        ),
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
