import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../inicio/inicio_widget.dart';
import 'buttonGroups.dart';

class viewSOS extends StatefulWidget {
  final responseJson;
  const viewSOS({
    Key? key,
    required this.responseJson,
  });

  @override
  _viewSOS createState() => _viewSOS();
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
TextEditingController? selectedControllerText;

List<TextEditingController> textControllers = [
  TextEditingController(),
  TextEditingController(),
  TextEditingController()
];

class _viewSOS extends State<viewSOS> {
  bool mostrarScreenBlock = false;
  int selectedIndexGlobal = 1;
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/CreateVigilantAlert/';
  late bool showTextField;
  late String idUser;
  late String propertyId;
  late String type;
  late String emergency;
  late String idPlace;
  late String description;
  late String lat;
  late String lon;
  late TextEditingController textFieldController;
  //late bool showTextField;
  int selectedIndex = -1;
  String selectedtext = '';

  @override
  void initState() {
    idUser = '';
    propertyId = '';
    type = '';
    emergency = '';
    idPlace = '';
    description = '';
    lat = '';
    lon = '';
    super.initState();
    showTextField = false;
    textControllers[2] = TextEditingController(text: '');
    _iconController = TextEditingController();
    textFieldController = TextEditingController();
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
    //ID_PLACE
    String idPlace = options[selectedIndexGlobal].idPlace;
    String emergency = selectedtext;

    Map<String, String> data = {
      'idUser': idUser,
      'PropertyId': propertyId,
      'Type': 'SOS',
      'Emergency': emergency,
      'IdPlace': idPlace,
      'Description': 'quedara?2',
      'Lat': '---',
      'Lon': '---'
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var codeApiResponse = jsonDecode(response.body);
      print('hello buey');
      print(idUser);
      print(propertyId);
      return codeApiResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

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

  TextEditingController _iconController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));

    return Container(
        child: Scaffold(
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
                                    MediaQuery.of(context).size.height * 0.2),
                            //screenBlock()
                            mostrarScreenBlock
                                ? screenBlock()
                                : contentVigilante(),
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
                Navigator.of(context).pop();
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'S.O.S',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InicioWidget(responseJson: responseJson)),
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
          iconsEmergerncy(),
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
                btnDialog(),
                TextField(
                  controller: _iconController,
                  enabled: false,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                buttonEnviarSolicitud()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget iconsEmergerncy() {
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
                  print("Robo");
                  setState(() {
                    selectedIndex = 0;
                    showTextField = false;
                    selectedtext = textControllers[0].text = 'Robo';
                  });
                },
                iconSize: 72,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text("Robo",
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
                icon: AssetImage('assets/images/BOTON4.png'),
                index: 1,
                selectedIndex: selectedIndex,
                onTap: () {
                  print("Medica");
                  setState(() {
                    selectedIndex = 1;
                    selectedtext = textControllers[1].text = 'Medica';
                    showTextField = false;
                  });
                },
                iconSize: 72,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                "Medica",
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
                icon: AssetImage('assets/images/BOTON5.png'),
                index: 2,
                selectedIndex: selectedIndex,
                onTap: () {
                  print("Otra");
                  setState(() {
                    //selectedtext = textControllers[2].text;
                    showTextField = !showTextField;
                    if (showTextField) {
                      showTextField = true; //Se abre la accion del boton
                    } else
                      showTextField = false; // Se cierra la accion del boton
                    selectedtext = textControllers[2].text;

                    selectedIndex = 2;
                  });
                },
                iconSize: 72,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text("Otra",
                  style: TextStyle(
                      color: Color(0xFF1890F7),
                      fontSize: 15,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold)),
              if (showTextField == true)
                Container(
                  color: Color(0xFF011D45),
                  width: 130,
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.01,
                      bottom: MediaQuery.of(context).size.height * 0.01,
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: Column(children: [
                    Text(
                      "Escribe tu emergencia",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01)),
                    Container(
                      height: 20,
                      //Boton para colocar tu emergencia
                      child: TextField(
                        controller: textFieldController,
                        onChanged: (value) {
                          setState(() {
                            selectedtext = value;
                          });
                        },
                        inputFormatters: [LengthLimitingTextInputFormatter(18)],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10.0, height: 1.0, color: Colors.black),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Emergencia",
                            hintStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: 10.0,
                                    )),
                      ),
                    )
                  ]),
                )
            ]),
          ),
        ]),
        /*Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Text(
                  "Icono seleccionado $selectedtext",
                  style: TextStyle(color: Colors.black),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  controller: textFieldController,
                  enabled: false,
                  style: TextStyle(color: Colors.black),
                )
              ],
            ))*/
      ]),
    );
  }

  Widget btnDialog() {
    int selectedIndex = 1;
    return Container(
      child: FFButtonWidget(
        text: ("Selecciona el area"),
        onPressed: () {
          setState(() {
            showTextField = false;
          });
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
                                left: MediaQuery.of(context).size.width * 0.65)
                            /*padding: EdgeInsetsDirectional.fromSTEB(
                                280.0, 0.0, 0.0, 0.0)*/
                            ,
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
                                      print("Elemento del id: ${item.idPlace}");
                                      print(
                                          'Elemento seleccionado: ${item.text}');
                                    },
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

  Widget buttonsEmergencia() {
    int selectedIndex2 = 1;
    return Row(
      children: [
        Container(
            child: ListView.builder(
          itemCount: options.length,
          itemBuilder: ((context, index) {
            final item = options[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex2 = index;
                  _iconController.text = item.text;
                  Navigator.of(context).pop();
                });
                print('Elemento seleccionado: ${item.text}');
                String idPlace = options[selectedIndex2].idPlace;
              },
              child: Container(
                color: selectedIndex2 == index
                    ? Color.fromARGB(132, 0, 236, 204)
                    : null,
                child: ListTile(
                  title: Text(
                    item.text,
                    style: TextStyle(
                      color:
                          selectedIndex2 == index ? Colors.white : Colors.white,
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
        ))
      ],
    );
  }

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
