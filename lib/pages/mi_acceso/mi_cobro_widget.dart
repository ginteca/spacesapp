import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../inicio/inicio_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:local_auth/local_auth.dart';

class MiCobroWidget extends StatefulWidget {
  final responseJson;
  final String idUsuario;
  final String idPropiedad;
  final String AccessCode;

  const MiCobroWidget({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.AccessCode,
  }) : super(key: key);

  @override
  _MiCobroWidgetState createState() => _MiCobroWidgetState();
}

class _MiCobroWidgetState extends State<MiCobroWidget> {
  late String textoQR;
  late String usuarioId;
  late String propiedadId;
  late String codigoAcceso;
  late String codigo = '';
  late String codigoFinal;
  late String codigo1 = '';
  double currentMount = 0.0;
  bool isAuthenticated = false;

  Future<void> obtenerMonto() async {
    final url = 'https://yourserver.com/api.php';

    final body = {
      'idUsuario': usuarioId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          currentMount = jsonResponse['current_mount'];
        });
      } else {
        print('Error: ${jsonResponse['message']}');
      }
    } else {
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> generarCodigo() async {
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
      final jsonResponse = json.decode(response.body);
      codigo = jsonResponse['Data'][0]['Value'];
      Map<String, dynamic> parsedJson = json.decode(codigo);
      codigoFinal = codigo;
      setText();
    } else {
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  void setText() {
    setState(() {
      textoQR = codigo;
    });
  }

  int segundosRestantes = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    usuarioId = widget.idUsuario;
    propiedadId = widget.idPropiedad;
    codigoAcceso = widget.AccessCode;
    textoQR = codigoAcceso;
    generarCodigo();
    obtenerMonto();
    startTimer();
    String _codigoAcceso = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_codigoAcceso);
  }

  void startTimer() {
    const unSegundo = Duration(seconds: 1);
    timer = Timer.periodic(unSegundo, (Timer timer) {
      if (segundosRestantes == 0) {
        timer.cancel();
        ejecutarFuncion();
        obtenerMonto();
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

  Future<void> authenticate() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      isAuthenticated = authenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));

    final responseJson = widget.responseJson;
    return Container(
      child: Scaffold(
        body: Builder(
          builder: (context) => SafeArea(
            child: Container(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1.0,
                          height: MediaQuery.of(context).size.height * 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.asset(
                                'assets/images/FONDO_GENERAL.jpg',
                              ).image,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
                                    child: IconButton(
                                      color: Color.fromRGBO(44, 255, 226, 1),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: FaIcon(FontAwesomeIcons.arrowLeft),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'PAGAR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 5.0, 0.0),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => InicioWidget(
                                              responseJson: widget.responseJson,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Image.asset(
                                          'assets/images/ICONOP.png'),
                                    ),
                                  ),
                                ],
                              ),
                              if (isAuthenticated)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 160.0, 0.0, 0.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        '\$$currentMount',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Color.fromRGBO(1, 29, 69, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Saldo Actual',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromRGBO(1, 29, 69, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.31,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          child: QrImageView(
                                            data: codigo,
                                            version: QrVersions.auto,
                                            size: 200,
                                          ),
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
                                        'PAGAR DENTRO DE LAS INSTALACIONES',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromRGBO(1, 29, 69, 1),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 35.0, 0.0, 0.0),
                                        child: Container(
                                          width: 250,
                                          height: 43,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                1, 29, 69, 0.459),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Center(
                                            child: Text(
                                              codigo,
                                              style: TextStyle(
                                                letterSpacing: 6,
                                                fontSize: 35,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 20.0, 0.0, 0.0),
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
                                        'TIEMPO RESTANTE PARA PAGAR',
                                        style: TextStyle(
                                          color: Color.fromRGBO(1, 29, 69, 1),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        if (!isAuthenticated)
                          ElevatedButton(
                            onPressed: authenticate,
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(149, 55, 255, 1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              'PAGAR',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para el botón "VER MIS PAGOS"
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(1, 29, 69, 1),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            'VER MIS PAGOS',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            // Acción para el botón "Términos y condiciones"
                          },
                          child: Text(
                            'Términos y condiciones',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
