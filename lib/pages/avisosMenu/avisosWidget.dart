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
import '../reservaciones/reservaWidget.dart';
import '../mi_acceso/mi_cobro_widget.dart';
import '../seguridad_home_page/view_SOS.dart';

class avisosPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;

  const avisosPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });

  @override
  _avisosPage createState() => _avisosPage();
}

class _avisosPage extends State<avisosPage> {
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
    getNews();
    textFieldEnviarComment = TextEditingController();
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    _accessCode = data['AccessCode'].toString();
  }

  Future<void> getNews() async {
    final url = 'https://appaltea.azurewebsites.net/api/Mobile/GetNews/';
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);

    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();

    final body = {
      'idUser': widget.idUsuario,
      'AssociationId': idAssociation,
      'Owner': 'true'
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      final dataList = parsedJson['Data'] as List<dynamic>;
      final newsList = json.decode(dataList[0]['Value']) as List<dynamic>;

      setState(() {
        news = newsList;
      });
    } else {
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  Future<String> enviarComment() async {
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();

    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    propertyId = data1['Id'].toString();
    String comment = selectedtext.toString();

    Map<String, String> data = {
      'idUser': idUser,
      'PropertyId': propertyId,
      'NeighborPropertyId': propertyId,
      'NeighborId': idUser,
      'Comment': comment,
      'TypeMessage': 'Comment',
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var codeApiResponse = jsonDecode(response.body);
      return codeApiResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: BotonFlotante(
          responseJson: widget.responseJson,
          accessCode: _accessCode,
          idPropiedad: widget.idPropiedad,
          idUsuario: widget.idUsuario,
        ),
        bottomNavigationBar: barranavegacion(
          responseJson: widget.responseJson,
          idPropiedad: widget.idPropiedad,
          idUsuario: widget.idUsuario,
          accessCode: _accessCode,
        ),
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
            'AVISOS Y REPORTES',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 9.0, 0.0),
          child: IconButton(
            onPressed: () {
              getNews();
            },
            icon: Icon(Icons.refresh_outlined, color: Colors.white),
            iconSize: MediaQuery.of(context).size.width * 0.07,
          ),
        ),
      ],
    );
  }

  Widget contentBuzon() {
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final responseJson = widget.responseJson;

    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (BuildContext context, int index) {
                final noticia = news[index];
                final idUser2 = noticia['Id'].toString();
                final title = noticia['Title'] as String;
                final content = noticia['Content'] as String;
                final imageUrl = noticia['Image'];
                final newDate = noticia['NewDate'] as String;
                final parsedDate = DateTime.parse(newDate);
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(parsedDate);

                final status = noticia['Status'] as String;

                String neighborName = '';
                String neighborLastName = '';
                String content2 = '';
                final comments = noticia['Comments'] as List<dynamic>;

                if (comments.isNotEmpty) {
                  final firstComment = comments[0];
                  content2 = firstComment['Content'];
                  final commentStatus = firstComment['Status'];
                  final owner = firstComment['Owner'];
                  final neighbor = owner['Neighbor'];
                  final property = owner['Property'];

                  neighborName = neighbor['Name'];
                  neighborLastName = neighbor['LastName'];
                } else {
                  // Manejar el caso en el que no hay comentarios
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => avisosComents(
                          responseJson: responseJson,
                          idPropiedad: _idPropiedad,
                          idUsuario: _idUsario,
                          idUser2: idUser2,
                          title: title,
                          content: content,
                          image: imageUrl,
                          formattedDate: formattedDate,
                          comments: comments,
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                                        "$title",
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
                                        "$formattedDate",
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
                                        "$content...",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      child: Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "VER COMENTARIOS",
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.018,
                                                color: Color(0xFF011D45),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.012,
                                            ),
                                            Image.asset(
                                              'assets/images/icono_de_mensaje.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.1,
            child: avisosModal(
              responseJson: responseJson,
              idUsuario: _idUsario,
              idPropiedad: _idPropiedad,
            ),
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
