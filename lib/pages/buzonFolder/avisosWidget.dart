import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../pages/inicio/inicio_widget.dart';

class avisosPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const avisosPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  }) : super(key: key);

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
  String selectedtext = '';

  List<dynamic> news = [];
  List<dynamic> comments = [];
  List<dynamic> owner = [];

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
  }

  Future<void> getNews() async {
    final url = 'https://appaltea.azurewebsites.net/api/Mobile/GetNews/';
    final body = {
      'idUser': widget.idUsuario,
      'AssociationId': '1',
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/FONDO_GENERAL.jpg'),
              ),
            ),
            child: Column(
              children: [
                buttonsBackHome(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                Expanded(
                  child: contentBuzon(),
                ),
                buttonsBarraInferior()
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
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
          child: IconButton(
            color: Color.fromRGBO(0, 15, 36, 1),
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
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InicioWidget(responseJson: responseJson)),
              );
            },
            icon: Image.asset('assets/images/ICONOP.png'),
            iconSize: MediaQuery.of(context).size.width * 0.07,
          ),
        )
      ],
    );
  }

  Widget contentBuzon() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Expanded(
            child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (BuildContext context, int index) {
                final noticia = news[index];
                final idUser = noticia['Id'].toString();
                final title = noticia['Title'] as String;
                final content = noticia['Content'] as String;
                final newDate = noticia['NewDate'] as String;
                final parsedDate = DateTime.parse(newDate);
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(parsedDate);

                final status = noticia['Status'] as String;

                String neighborName = '';
                String neighborLastName = '';
                final comments = noticia['Comments'] as List<dynamic>;
                if (comments.isNotEmpty) {
                  final firstComment = comments[0];
                  final owner = firstComment['Owner'];
                  final neighbor = owner['Neighbor'];
                  final property = owner['Property'];
                  neighborName = neighbor['Name'];
                  neighborLastName = neighbor['LastName'];
                } else {}

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
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color.fromARGB(68, 0, 12, 52),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.01,
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
                                        fontSize:
                                            MediaQuery.of(context).size.width *
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
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.032,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.004,
                                    ),
                                    Text(
                                      "$content",
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
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
          Container(
            width: 90,
            height: 90,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    print("Se presiono nuevo aviso");
                  },
                  icon: Icon(
                    Icons.circle,
                    color: Color.fromRGBO(0, 15, 36, 1),
                  ),
                  iconSize: MediaQuery.of(context).size.width * 0.1,
                ),
                Text(
                  "CREAR NUEVO AVISO",
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                    color: Color.fromRGBO(0, 15, 36, 1),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonsBarraInferior() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.11,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/MENU_ESTATICO.png'),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  top: MediaQuery.of(context).size.height * 0.035,
                ),
                child: IconButton(
                  iconSize: 65,
                  onPressed: () {
                    print('Reservaciones barra');
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor:
                          Color.fromRGBO(1, 29, 69, 1).withOpacity(0.7),
                      builder: (BuildContext context) {
                        bool isFinished = false;
                        return Container();
                      },
                    );
                  },
                  icon: Image.asset(
                    'assets/images/RESERVACIONES.png',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: IconButton(
                  iconSize: 65,
                  onPressed: () {
                    print('SOS BARRA');
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor:
                          Color.fromRGBO(1, 29, 69, 1).withOpacity(0.7),
                      builder: (BuildContext context) {
                        bool isFinished = false;
                        return Container();
                      },
                    );
                  },
                  icon: Image.asset(
                    'assets/images/S.O.S.png',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.09,
                  top: MediaQuery.of(context).size.height * 0.04,
                ),
                child: IconButton(
                  iconSize: 65,
                  onPressed: () {
                    print('Reservaciones barra');
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor:
                          Color.fromRGBO(1, 29, 69, 1).withOpacity(0.7),
                      builder: (BuildContext context) {
                        bool isFinished = false;
                        return Container();
                      },
                    );
                  },
                  icon: Image.asset(
                    'assets/images/MIACCESO.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
