import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_theme.dart';
import '../inicio/inicio_widget.dart';
import 'contentBuzon.dart';

class buzonPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const buzonPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _buzonPage createState() => _buzonPage();
}

class _buzonPage extends State<buzonPage> {
  String? currentButton;
  late String idUser;
  late String propertyId;
  late String neighborPropertyId;
  late String neighborId;
  late String comment;
  late String typeMessage;
  late TextEditingController textFieldEnviarComment;
  late String commenBuzon;
  late String _accessCode;
  String selectedtext = '';
  String selectedText2 = '';
  late String idAssociation;

  late String idUser2;

  List<dynamic> buzon = [];

  @override
  void initState() {
    super.initState();
    getCommentBuzon();
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    _accessCode = data['AccessCode'].toString();
  }

  Future<void> getCommentBuzon() async {
    final url = "https://appaltea.azurewebsites.net/api/Mobile/GetCommentBox/";
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    final idProperty = data1['Id'].toString();
    final type = data1['Type'].toString();
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();
    final body = {
      'idProperty': idProperty,
      'AssociationId': idAssociation,
      'UserType': "Vigilant"
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
      print('Entro a la Api de buzon');
      final parsedJson = json.decode(response.body);
      print(parsedJson);
      print("$idProperty, $idAssociation, $type");
      final dataList = parsedJson['Data'] as List<dynamic>;
      final buzonList = json.decode(dataList[0]['Value']) as List<dynamic>;
      print("Esto traE: $dataList");

      setState(() {
        buzon = buzonList;
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
    final idUsuario = widget.idUsuario;
    final idPropiedad = widget.idPropiedad;
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
                            contentBuzon(
                              responseJson: responseJson,
                              idUsuario: idUsuario,
                              idPropiedad: idPropiedad,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    ));
  }
}
