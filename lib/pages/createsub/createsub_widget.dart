import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:http/http.dart' as http;

class CreatesubWidget extends StatefulWidget {
  final idUsuario;
  final idPropiedad;
  const CreatesubWidget({
    Key? key,
    required this.idPropiedad,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _CreatesubWidgetState createState() => _CreatesubWidgetState();
}

class _CreatesubWidgetState extends State<CreatesubWidget> {
  late String _IdUsuario = widget.idUsuario;
  String? selectcode;

  late String _IdPropiedad = widget.idPropiedad;
  late TextEditingController textFieldEnviarselect;
  late TextEditingController descriptionController;
  final _Description = TextEditingController();
  final _PersonAccess = TextEditingController();
  final _alias = TextEditingController();
  final _street = TextEditingController();
  final _numExt = TextEditingController();
  final _numInt = TextEditingController();
  final _zipCode = TextEditingController();
  List<String> selectcodelist = ['Familiar', 'Renta'];
  void initState() {
    super.initState();

    textFieldEnviarselect = TextEditingController();
    descriptionController = TextEditingController();
  }

  bool _switchValue = false;

  Future<void> nuevapropiedad(
      String Description, idUsuario, idPropiedad, PersonAccess) async {
    // Aquí va el código para agregar la propiedad a la API
    final String apiUrl =
        'https://jaus.azurewebsites.net/api/Mobile/ForgotPassword/';

    Map<String, String> data = {
      'idUser': idUsuario,
      'PropertyId': idPropiedad,
      'IdToken': "1",
      'Description': Description,
      'Areas': "numInt",
      'PersonAccess': PersonAccess,
      'TypeSubtoken': "FAMILIAR"
    }; // Cambio aquí: 'correo' por 'Email'

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      // Manejo de la respuesta
      print(idUsuario);
      print('token enviado con exito');
    } else {
      // Manejo de errores
      throw Exception('Error al enviar el Token');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el color de la barra de notificaciones en blanco
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));
    bool _isSelected1 = false;
    bool _isSelected2 = false;
    bool _isSelected3 = false;
    bool _isSelected4 = false;
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
                          buttonsBackHome(),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.30,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.07,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% del ancho de la pantalla
                            height: MediaQuery.of(context).size.height *
                                0.02, // 10% de la altura de la pantalla
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'DESCRIPCIÓN DEL SUBTOKEN',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Helvetica'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 0.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: _Description,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'DESCRIPCIÓN',
                                  hintStyle: FlutterFlowTheme.of(context)
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
                                  fillColor: Color(0x4D011D45),
                                  prefixIcon: Icon(
                                    Icons.edit_note,
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
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.09,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% del ancho de la pantalla
                            height: MediaQuery.of(context).size.height *
                                0.02, // 10% de la altura de la pantalla
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'PERSONA AUTORIZADA',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Helvetica'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 0.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: _PersonAccess,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'DESCRIPCIÓN',
                                  hintStyle: FlutterFlowTheme.of(context)
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
                                  fillColor: Color(0x4D011D45),
                                  prefixIcon: Icon(
                                    Icons.edit_note,
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
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.09,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% del ancho de la pantalla
                            height: MediaQuery.of(context).size.height *
                                0.02, // 10% de la altura de la pantalla
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'TIPO DE SUBTOKEN',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Helvetica'),
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(239, 255, 255, 255),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(30)),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                iconSize: 0,
                                alignment: Alignment.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(197, 0, 0, 0),
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                dropdownColor:
                                    Color.fromARGB(193, 255, 255, 255),
                                value: selectcode,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectcode = newValue;

                                    textFieldEnviarselect.text =
                                        newValue.toString();
                                  });
                                },
                                hint: Text(
                                  "Selecciona El Tipo",
                                  style: TextStyle(
                                      color: Color.fromARGB(197, 87, 87, 87)),
                                ),
                                items: selectcodelist.map((String selectcode) {
                                  return DropdownMenuItem<String>(
                                    alignment: Alignment.center,
                                    value: selectcode,
                                    child: Text(selectcode),
                                  );
                                }).toList(),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.01,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Column(
                            children: <Widget>[
                              CheckboxListTile(
                                title: Text("Pagos"),
                                value: _isSelected1,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isSelected1 = newValue!;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text("Finanzas"),
                                value: _isSelected2,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isSelected2 = newValue!;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text("Votaciones"),
                                value: _isSelected3,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isSelected3 = newValue!;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text("Reservaciones"),
                                value: _isSelected4,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isSelected4 = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              print('boton recuperarggg');
                              String Description = _Description.text.trim();
                              String alias = _alias.text.trim();
                              String street = _street.text.trim();
                              String numExt = _numExt.text.trim();
                              String numInt = _numInt.text.trim();
                              String zipCode = _zipCode.text.trim();
                              String idUsuario = _IdUsuario;
                              String idPropiedad = _IdPropiedad;
                              String PersonAccess = _PersonAccess.text.trim();
                              ;

                              await nuevapropiedad(Description, idUsuario,
                                  idPropiedad, PersonAccess);
                            },
                            child: Text("REGISTRAR SUBTOKEN",
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

  Widget buttonsBackHome() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
            'CREAR SUBTOKEN',
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
            onPressed: () {},
            icon: Image.asset('assets/images/ICONOP.png'),
          ),
        ),
      ],
    );
  }
}
