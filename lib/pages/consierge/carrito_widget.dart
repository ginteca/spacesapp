import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../inicio/carrito_widget.dart';
import '../inicio/inicio_widget.dart';
import '../mi_acceso/mi_acceso_widget.dart';
import '../reservaciones/reservaWidget.dart';
import '../reservaciones/reservacionesWidget.dart';
import '../seguridad_home_page/view_SOS.dart';

class carritoCompra extends StatefulWidget {
  @override
  _carritoCompraState createState() => _carritoCompraState();
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;

  const carritoCompra({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.AccessCode,
  }) : super(key: key);
}

class _carritoCompraState extends State<carritoCompra> {
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
                height: MediaQuery.of(context).size.width * 0.5,
              ),
              carritoContainer()
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

  Widget carritoContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/CARRITO2.png', // Reemplaza con la ruta de tu imagen
            width: 200, // Ajusta el ancho de la imagen según tus necesidades
            height: 200, // Ajusta la altura de la imagen según tus necesidades
          ),
          SizedBox(height: 20), // Espacio entre la imagen y el primer texto
          Text(
            'Tu carrito está vacío.',
            style: TextStyle(
              fontSize: 24, // Ajusta el tamaño de fuente según tus necesidades
              fontWeight: FontWeight.bold,
              color: Color(0xFF1890F7),
            ),
          ),
          Text(
            '¿Ya viste los artículos que tenemos hoy? \n ¡No te los pierdas!',
            style: TextStyle(
              fontSize: 18, // Ajusta el tamaño de fuente según tus necesidades
              fontStyle: FontStyle.italic,
              color: Color(0xFF011D45),
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
