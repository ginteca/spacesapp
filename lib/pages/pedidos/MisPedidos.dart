import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacesclub/pages/avisosMenu/avisosComments.dart';
import 'package:spacesclub/pages/avisosMenu/avisosModal.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Asegúrate de tener este import para el DateFormat
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../inicio/carrito_widget.dart';
import '../control_acceso/control_acceso_widget.dart';
import '../inicio/inicio_widget.dart';
import '../reservaciones/reservaWidget.dart';
import '../mi_acceso/mi_cobro_widget.dart';
import '../seguridad_home_page/view_SOS.dart';

class misPedidosPage extends StatefulWidget {
  final idUsuario;
  final responseJson;
  final idPropiedad;

  const misPedidosPage({
    Key? key,
    required this.idUsuario,  
    required this.responseJson,
    required this.idPropiedad,
  });

  @override
  _misPedidosPage createState() => _misPedidosPage();
}

class _misPedidosPage extends State<misPedidosPage> {
  String? currentButton;
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/SaveMessageNeighbor/';
  late String idUser;
  late String propertyId;
  late String neighborPropertyId;
  late String neighborId;
  late String comment;
  late String typeMessage;
  late TextEditingController textFieldEnviarComment;
  late String idAssociation;
  late String _accessCode;

  String selectedtext = '';

  List<dynamic> news = [];
  List<dynamic> comments = [];
  List<dynamic> owner = [];
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentButton = 'No leído';
    idUser = '';
    propertyId = '';
    neighborPropertyId = '';
    neighborId = '';
    comment = '';
    typeMessage = '';
    getPayments();
    textFieldEnviarComment = TextEditingController();
  }


  Future<void> getPayments() async {
    final userNeighborId = widget.idPropiedad;
    final url = Uri.parse('https://jaus.azurewebsites.net/historialcaddy.php?UserProperty_Id=$userNeighborId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body) as List;
      setState(() {
        news = parsedJson;
      });
    } else {
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        body: Builder(
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit
                    .fill, // Ajusta la imagen para cubrir toda la pantalla
                image: AssetImage('assets/images/FONDO_GENERAL.jpg'),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                buttonsBackHome(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Expanded(
                  child: contentBuzon(),
                ),
              ],
            ),
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
          padding: EdgeInsetsDirectional.fromSTEB(9.0, 0.0, 0.0, 0.0),
          child: IconButton(
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            iconSize: MediaQuery.of(context).size.width * 0.07,
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'MIS PEDIDOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04,
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

  Widget contentBuzon() {
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final responseJson = widget.responseJson;
    if(news.isNotEmpty){
      return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (BuildContext context, int index) {
                final payment = news[index];
                final fechaPago = payment['Fecha_inicial']['date'];
                final mount = payment['Devices'];
                final status = payment['Status'];

                return Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            top: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color.fromARGB(68, 0, 12, 52),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        mount,
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Color(0xFF011D45),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.004,
                                      ),
                                      Text(
                                        status,
                                        style: TextStyle(
                                          color: Color(0xFF011D45),
                                          fontFamily: 'Helvetica',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.032,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.004,
                                      ),
                                      Text(
                                        fechaPago,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.024,
                                          color: Color(0xFF011D45),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
        ],
      ),
    );
    }else{
      return Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            top: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color.fromARGB(68, 0, 12, 52),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "No hay pedidos aun",
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Color(0xFF011D45),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.004,
                                      ),
                                      
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.004,
                                      ),
                                      
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
    }
    
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
       statusBarColor: Color.fromRGBO(3, 16, 145, 1),
     ));
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
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color.fromARGB(255, 225, 216, 216),
          width: 10.0,
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 3, 16, 145),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MiCobroWidget(
                responseJson: responseJson,
                idUsuario: idUsuario,
                idPropiedad: idPropiedad,
                AccessCode: accessCode,
              ),
            ),
          );
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
