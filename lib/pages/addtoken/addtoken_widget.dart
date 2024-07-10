import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../subtoken/subtoken_widget.dart';

class AddtokenWidget extends StatefulWidget {
  final idUsuario;

  const AddtokenWidget({
    Key? key,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _AddtokenWidgetState createState() => _AddtokenWidgetState();
}

class _AddtokenWidgetState extends State<AddtokenWidget> {
  late String _IdUsuario = widget.idUsuario;

  final _formKey = GlobalKey<FormState>();
  final _token = TextEditingController();
  final _alias = TextEditingController();
  final _street = TextEditingController();
  final _numExt = TextEditingController();
  final _numInt = TextEditingController();
  final _zipCode = TextEditingController();
  bool _isLoading = false;

  Future<void> nuevapropiedad(
      String token, idUsuario, alias, street, numExt, numInt, zipCode) async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl =
        'https://appaltea.azurewebsites.net/api/Mobile/RegisterProperty/';

    Map<String, String> data = {
      'Token': token,
      'idUser': idUsuario,
      'alias': alias,
      'street': street,
      'numExt': numExt,
      'numInt': numInt,
      'zipCode': zipCode,
      'latitude': "25.123456",
      'longuitude': "80.654321"
    };

    // Imprimir los datos que se están enviando
    print('Datos enviados: $data');

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    final responseBody = json.decode(response.body);
    print(response.body); // Imprimir la respuesta de la API

    if (response.statusCode == 200 && responseBody['Type'] == 'Success') {
      abrirNuevoModalcompletado(context, responseBody['Message']);
    } else {
      abrirNuevoModalfallo(context, responseBody['Message']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el color de la barra de notificaciones
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 14, 114, 255),
    ));

    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/images/FONDO_GENERAL.jpg').image,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buttonsBackHome(screenSize),
                  SizedBox(height: screenSize.height * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.06),
                    child: Text(
                      'Llena los campos',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                  buildTextField(
                    controller: _token,
                    hintText: 'Token',
                    icon: Icons.edit_note,
                    screenSize: screenSize,
                  ),
                  buildTextField(
                    controller: _alias,
                    hintText: 'Alias',
                    icon: Icons.edit_note,
                    screenSize: screenSize,
                  ),
                  buildTextField(
                    controller: _street,
                    hintText: 'Dirección',
                    icon: Icons.edit_note,
                    screenSize: screenSize,
                  ),
                  buildTextField(
                    controller: _numExt,
                    hintText: 'Número Exterior',
                    icon: Icons.edit_note,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    screenSize: screenSize,
                  ),
                  buildTextField(
                    controller: _numInt,
                    hintText: 'Número Interior',
                    icon: Icons.edit_note,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    screenSize: screenSize,
                  ),
                  buildTextField(
                    controller: _zipCode,
                    hintText: 'Código Postal',
                    icon: Icons.edit_note,
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    screenSize: screenSize,
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String token = _token.text.trim();
                            String alias = _alias.text.trim();
                            String street = _street.text.trim();
                            String numExt = _numExt.text.trim();
                            String numInt = _numInt.text.trim();
                            String zipCode = _zipCode.text.trim();
                            String idUsuario = _IdUsuario;

                            await nuevapropiedad(token, idUsuario, alias,
                                street, numExt, numInt, zipCode);
                          }
                        },
                        text: "REGISTRAR PROPIEDAD",
                        screenSize: screenSize,
                      ),
                      buildElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubtokenWidget(
                                idUsuario: _IdUsuario,
                              ),
                            ),
                          );
                        },
                        text: "TENGO UN SUBTOKEN",
                        screenSize: screenSize,
                      ),
                    ],
                  ),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Size screenSize,
    int? maxLength,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.005),
      child: Container(
        width: screenSize.width * 0.9,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          obscureText: false,
          maxLength: maxLength,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: screenSize.width * 0.04,
                ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
              borderRadius: BorderRadius.circular(34.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
              borderRadius: BorderRadius.circular(34.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
              borderRadius: BorderRadius.circular(34.0),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
              borderRadius: BorderRadius.circular(34.0),
            ),
            filled: true,
            fillColor: Color(0x4D011D45),
            prefixIcon: Icon(icon, color: Colors.white),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: screenSize.width * 0.04,
              ),
          textAlign: TextAlign.start,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
            if (hintText == 'Código Postal' && value.length != 5) {
              return 'El código postal debe tener 5 dígitos';
            }
            if ((hintText == 'Número Exterior' ||
                    hintText == 'Número Interior') &&
                value.length > 8) {
              return 'El número debe tener máximo 8 caracteres';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildElevatedButton({
    required VoidCallback onPressed,
    required String text,
    required Size screenSize,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Helvetica Neue, Bold',
            fontSize: screenSize.width * 0.035,
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(34),
            ),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            Size(screenSize.width * 0.35, screenSize.height * 0.06),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF011D45)),
        ),
      ),
    );
  }

  Widget buttonsBackHome(Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
          child: IconButton(
            color: Color.fromRGBO(44, 255, 226, 1),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
          ),
        ),
        Text(
          'NUEVA PROPIEDAD',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.width * 0.04,
            letterSpacing: 2.4,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
          child: IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/ICONOP.png'),
          ),
        ),
      ],
    );
  }
}

void abrirNuevoModalcompletado(BuildContext context, String message) {
  Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color.fromARGB(186, 243, 243, 243),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: Color.fromRGBO(0, 15, 36, 0.308),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Confirmado',
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 236, 225),
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Icon(
                  Icons.check_circle,
                  size: 75,
                  color: Colors.green,
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'ENTENDIDO',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 17.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF011D45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34.0),
                    ),
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

void abrirNuevoModalfallo(BuildContext context, String message) {
  Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color.fromARGB(186, 243, 243, 243),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: Color.fromRGBO(0, 15, 36, 0.308),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Error',
                    style: TextStyle(
                      color: Color.fromARGB(255, 236, 7, 7),
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Icon(
                  Icons.error,
                  size: 75,
                  color: Colors.red,
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'ENTENDIDO',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 17.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF011D45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34.0),
                    ),
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
