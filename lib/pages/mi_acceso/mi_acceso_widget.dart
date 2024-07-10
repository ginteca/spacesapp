import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../inicio/inicio_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class MiAccesoWidget extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;
  const MiAccesoWidget(
      {Key? key,
      required this.responseJson,
      required this.idUsuario,
      required this.idPropiedad,
      required this.AccessCode})
      : super(key: key);

  @override
  _MiAccesoWidgetState createState() => _MiAccesoWidgetState();
}

class _MiAccesoWidgetState extends State<MiAccesoWidget> {
  late String textoQR = codigoAcceso;
  late String usuarioId = widget.idUsuario;
  late String propiedadId = widget.idPropiedad;
  late String codigoAcceso = '123456';
  late String codigo = '';
  late String codigoFinal;
  late String codigo1 = '';

  Future<void> generarCodigo() async {
    print(usuarioId);
    print(propiedadId);
    print('entrando a generar codigo');
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetAccessCodeProfile/';

    final body = {
      'IdUser': usuarioId,
      'PropertyId': propiedadId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Entro a la Api');

      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      codigo = jsonResponse['Data'][0]['Value'];
      Map<String, dynamic> parsedJson = json.decode(codigo);
      print(codigo);

      codigoFinal = codigo;
    } else {
      print('No entro a la Api');
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  void actualizarTexto(code) {
    setState(() {
      textoQR = code;
    });
  }

  int segundosRestantes = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    generarCodigo();
    startTimer();
    String _codigoAcceso = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_codigoAcceso);
  }

  void setText() {
    setState(() {
      textoQR = codigo;
    });
  }

  void startTimer() {
    const unSegundo = Duration(seconds: 1);
    timer = Timer.periodic(unSegundo, (Timer timer) {
      if (segundosRestantes == 0) {
        timer.cancel();
        ejecutarFuncion();
        generarCodigo();
      } else {
        setState(() {
          segundosRestantes--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  int i = 0;
  void ejecutarFuncion() {
    i++;
    String texto = 'Contador' + i.toString();
    print(texto);
    print('El contador ha finalizado');
    segundosRestantes = 30;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    final responseJson = widget.responseJson;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/FONDO_GENERAL.jpg'),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Color.fromRGBO(44, 255, 226, 1),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: FaIcon(FontAwesomeIcons.arrowLeft),
                  ),
                  Text(
                    'MI ACCESO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
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
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¡BIENVENIDO AL CLUB!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromRGBO(1, 29, 69, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'MI CODIGO DE ACCESO DINAMICO',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(1, 29, 69, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.31,
                      child: QrImageView(
                        data: codigo,
                        version: QrVersions.auto,
                        size: 200,
                      ),
                    ),
                    Text(
                      'PRESENTA ESTE QR PARA',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(1, 29, 69, 1),
                      ),
                    ),
                    Text(
                      'VALIDAR TU INGRESO',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(1, 29, 69, 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 35.0),
                      child: Container(
                        width: 250,
                        height: 43,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(1, 29, 69, 0.459),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            codigo,
                            style: TextStyle(
                              letterSpacing: 6,
                              fontSize: 35,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 35.0),
                      child: Text(
                        '00:$segundosRestantes',
                        style: TextStyle(
                          color: Color.fromRGBO(1, 29, 69, 1),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'TIEMPO RESTANTE PARA ACCEDER',
                      style: TextStyle(
                        color: Color.fromRGBO(1, 29, 69, 1),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
