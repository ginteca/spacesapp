import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../inicio/inicio_widget.dart';
import 'buttonGroups.dart';

class viewVecinoVigilante extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const viewVecinoVigilante({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _viewVecinoVigilante createState() => _viewVecinoVigilante();
}

class OptionItem {
  final String idPlace;
  final String value;
  final String text;
  final String icon;

  OptionItem(
      {required this.idPlace,
      required this.value,
      required this.text,
      required this.icon});
}

TextEditingController? selectedController;
TextEditingController _iconController = TextEditingController();
List<TextEditingController> textControllers = [
  TextEditingController(),
  TextEditingController(),
  TextEditingController()
];

class _viewVecinoVigilante extends State<viewVecinoVigilante> {
  bool mostrarScreenBlock = false;
  int selectedIndexGlobal = 1;
  String? selectedValue;
  late bool showTextField;
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/CreateVigilantAlert/';
  late String idUser;
  late String propertyId;
  late String type;
  late String emergency;
  late String idPlace;
  late String description;
  late String lat;
  late String lon;
  int selectedIndex = -1;
  String selectedtext = '';
  late String _accessCode;

  List<OptionItem> options = [
    OptionItem(
        idPlace: '21',
        value: 'opcion1',
        text: 'Entrada Trasera',
        icon: 'assets/images/ENTRADA.png'),
    OptionItem(
        idPlace: '179',
        value: 'opcion2',
        text: 'Gimnasio Mujeres',
        icon: "assets/images/GYM.png"),
    OptionItem(
        idPlace: '181',
        value: 'opcion3',
        text: 'Zona de Juegos',
        icon: "assets/images/ZONA_DE_JUEGOS.png"),
    OptionItem(
        idPlace: '183',
        value: 'opcion4',
        text: 'Cancha de Futbol',
        icon: "assets/images/CANCHA_DE_FUTBOL.png"),
    OptionItem(
        idPlace: '178',
        value: 'opcion5',
        text: 'Gimasio Hombres',
        icon: "assets/images/GYM.png"),
    OptionItem(
        idPlace: '180',
        value: 'opcion6',
        text: 'Casa Club',
        icon: "assets/images/CASA_CLUB.png"),
    OptionItem(
        idPlace: '182',
        value: 'opcion7',
        text: 'Cancha de Tenis',
        icon: "assets/images/TENIS.png"),
    OptionItem(
        idPlace: '235',
        value: 'opcion8',
        text: 'Alberca',
        icon: "assets/images/ALBERCA.png")
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idUser = '';
    propertyId = '';
    type = '';
    emergency = '';
    idPlace = '';
    description = '';
    lat = '';
    lon = '';
    showTextField = false;
    _iconController = TextEditingController();
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    _accessCode = data['AccessCode'].toString();
  }

  Future<String> generarCodigoSOS(selectedIndexGlobal) async {
    //USUARIO
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();
    //PROPIEDAD
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    propertyId = data1['Id'].toString();
    String idPlace = options[selectedIndexGlobal].idPlace;
    String emergency = selectedtext;

    Map<String, String> data = {
      'idUser': idUser,
      'PropertyId': propertyId,
      'Type': 'Vecino vigilante',
      'Emergency': emergency,
      'IdPlace': idPlace,
      'Description': '----',
      'Lat': '---',
      'Lon': '---'
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var codeApiResponse = jsonDecode(response.body);
      print('hello buey');
      return codeApiResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
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
                            mostrarScreenBlock
                                ? screenBlock()
                                : contentVigilante(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
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
                print('hello');
                Navigator.of(context).pop();
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'ALERTA VECINAL',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("¿Cuál es tu emergencia?",
              style: TextStyle(
                color: Color(0xFF011D45),
                fontSize: 20,
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          iconsEmergency(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.045),
          Text("¿Dónde es tu emergencia?",
              style: TextStyle(
                color: Color(0xFF011D45),
                fontSize: 20,
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.height * 0.04,
                left: MediaQuery.of(context).size.height * 0.04),
            child: Column(
              children: [
                buttonsEmergencia2(),
                /*TextField(
                  controller: _iconController,
                  enabled: false,
                ),*/
                TextField(
                  controller: _iconController,
                  enabled: false,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                buttonEnviarSolicitud()
              ],
            ),
          )
        ],
      ),
    );
  }

  //Funcion para seleccionar el icono de la emergencia
  Widget iconsEmergency() {
    return Container(
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.04),
            child: Column(children: [
              ToggleButton(
                icon: AssetImage('assets/images/BOTON1.png'),
                index: 0,
                selectedIndex: selectedIndex,
                onTap: () {
                  print("Actividad Sospechosa");
                  setState(() {
                    selectedIndex = 0;
                    //selectedController.text = 'Robo';
                    //showTextField = false;
                    selectedtext =
                        textControllers[0].text = 'Actividad Sospechosa';
                    //selectedController = _icnRoboController;
                    //enviarData(selectedtext);
                  });
                },
                iconSize: 72,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text("Actividad",
                  style: TextStyle(
                      color: Color(0xFF1890F7),
                      fontSize: 15,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold)),
              Text("Sospechosa",
                  style: TextStyle(
                      color: Color(0xFF1890F7),
                      fontSize: 15,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold))
            ]),
          ),
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            child: Column(children: [
              ToggleButton(
                icon: AssetImage('assets/images/BOTON2.png'),
                index: 1,
                selectedIndex: selectedIndex,
                onTap: () {
                  print("Incendio");
                  setState(() {
                    selectedIndex = 1;
                    //selectedController.text = 'Medica';
                    selectedtext = textControllers[1].text = 'Incendio';
                    //showTextField = false;
                    //selectedController = _icnMedicaController;
                    //enviarData(selectedtext);
                  });
                },
                iconSize: 72,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                "Incendio",
                style: TextStyle(
                    color: Color(0xFF1890F7),
                    fontSize: 15,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold),
              )
            ]),
          ),
          Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.height * 0.05),
            child: Column(children: [
              ToggleButton(
                icon: AssetImage('assets/images/BOTON3.png'),
                index: 2,
                selectedIndex: selectedIndex,
                onTap: () {
                  print("Fuga tóxica");
                  setState(() {
                    selectedIndex = 2;
                    selectedtext = textControllers[2].text = 'Fuga tóxica';
                    //enviarData(selectedtext);
                  });
                },
                iconSize: 72,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text("Fuga tóxica",
                  style: TextStyle(
                      color: Color(0xFF1890F7),
                      fontSize: 15,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold)),
            ]),
          ),
        ]),
      ]),
    );
  }

  //Funcion para seleccionar un area de la emergencia
  Widget buttonsEmergencia2() {
    int selectedIndex = -1;
    return Container(
      child: FFButtonWidget(
        text: ("Selecciona el area"),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext contex) {
                return Dialog(
                  backgroundColor: Color(0xFF011D45),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Bordes redondeados
                  ),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                        child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.65),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.cancel_outlined,
                                    size: 30,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 68, 68, 68),
                                      ),
                                    ])),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.04),
                            child: Text(
                              "Selecciona un area",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 68, 68, 68),
                                    ),
                                  ]),
                            ),
                          ),
                          Container(
                              height: 450,
                              child: ListView.builder(
                                itemCount: options.length,
                                itemBuilder: ((context, index) {
                                  final item = options[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        _iconController.text = item.text;
                                        idPlace = item.idPlace;
                                        Navigator.of(context).pop();
                                      });
                                      selectedIndexGlobal = selectedIndex;
                                      print(
                                          "id del elemento es: ${item.idPlace}");
                                      print(
                                          'Elemento seleccionado: ${item.text}');
                                    },
                                    /*child: ListTile(
                                      title: Text(
                                        item.text,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Image.asset(
                                        item.icon,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),*/
                                    child: Container(
                                      color: selectedIndex == index
                                          ? Color.fromARGB(132, 0, 236, 204)
                                          : null,
                                      child: ListTile(
                                        title: Text(
                                          item.text,
                                          style: TextStyle(
                                            color: selectedIndex == index
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                        leading: Image.asset(
                                          item.icon,
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )),
                        ],
                      ),
                    ));
                  }),
                );
              });
        },
        options: FFButtonOptions(
          width: MediaQuery.of(context).size.width * 1.0,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
          borderRadius: BorderRadius.circular(10.0),
        ),
        icon: Icon(Icons.menu),
      ),
    );
  }

  //Funcion para enviar la solicitud de la emergencia
  Widget buttonEnviarSolicitud() {
    return Container(
      child: FFButtonWidget(
        text: "Enviar Solicitud",
        onPressed: () {
          setState(() {
            mostrarScreenBlock = true;
          });
          print("hola kk");
          generarCodigoSOS(selectedIndexGlobal);
        },
        options: FFButtonOptions(
          width: 150.0,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
    );
  }

  Widget screenBlock() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey[300],
              ),
            ),
            txtSOS(), // Agrega el widget txtSOS() aquí
          ],
        ),
      ),
    );
  }

  Widget txtSOS() {
    return Container(
      child: Column(
        children: [
          Text("ASISTENCIA EN CAMINO A:"),
          Image.asset(
            'assets/images/main.png',
            width: 50,
            height: 50,
          ),
          Text("ss"),
        ],
      ),
    );
  }
}
