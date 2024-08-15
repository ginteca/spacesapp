import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../inicio/inicio_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'home_page_logged_model.dart';
export 'home_page_logged_model.dart';
import 'package:http/http.dart' as http;
import '../dashvigilante/dash_widget.dart';
import 'home_page_widget.dart';

class HomePageWidgetLogged extends StatefulWidget {
  const HomePageWidgetLogged({Key? key}) : super(key: key);

  @override
  _HomePageWidgetLoggedState createState() => _HomePageWidgetLoggedState();
}

class _HomePageWidgetLoggedState extends State<HomePageWidgetLogged> {
  final String apiUrl = 'https://jaus.azurewebsites.net/api/Mobile/LoginUser/';
  final localAuth = LocalAuthentication();
  bool _obscureText = true;
  late String? email = '';
  late String? pass = '';
  late String? nombre = '';
  late String? fotoPerfil = '';
  late HomePageWidgetLoggedModel _model2;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSharedPreferencesValues();
    _model2 = createModel(context, () => HomePageWidgetLoggedModel());

    _model2.textFieldCorreoController ??= TextEditingController();
    _model2.textFieldPasswordController ??= TextEditingController();
    _model2.textFieldforgotpassController ??= TextEditingController();

    // Configurar el modo de inmersión
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
       statusBarColor: Color.fromRGBO(3, 16, 145, 1),
     ));
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/FONDO_ENTRADA_BIENVENIDA.jpg',
                ).image,
              ),
            ),
            child: Column(
              children: [
                LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth * 0.5,  // 10% del ancho del contenedor padre
                        child: AspectRatio(
                          aspectRatio: 1,  // Mantener la relación de aspecto 1:1 para la imagen
                          child: Image.asset('assets/images/Logo3.png'),
                        ),
                      );
                    },
                  ),
                const Text(
                  '¡BIENVENIDO!',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontFamily: 'Helvetica',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    nombre.toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromRGBO(0, 229, 231, 1),
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: MediaQuery.of(context).size.width * 0.41,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            fotoPerfil.toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: loginConHuella,
                        icon: Image.asset(
                          'assets/images/face.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 0.0, 0.0),
                        child: Text(
                          'Ingresa tu Face Id',
                          style: TextStyle(color: Color.fromRGBO(0, 229, 231, 1), fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  hintText: 'Contraseña...',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(255, 245, 239, 239),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureText ? Icons.visibility : Icons.visibility_off,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(0, 255, 255, 255),
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
                                  filled: true,
                                  fillColor: Color(0x67FFFFFF),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                textAlign: TextAlign.start,
                                validator: _model2.textFieldPasswordControllerValidator
                                    ?.asValidator(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 10.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (_passwordController.text.trim() == pass.toString()) {
                              login();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Color.fromARGB(186, 243, 243, 243),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 800,
                                            color: Color.fromRGBO(0, 15, 36, 0.308),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'CREDENCIALES INVALIDAS',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(255, 21, 46, 174),
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Revisa si las credenciales proporcionadas son las correctas.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
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
                          },
                          text: 'ENTRAR',
                          options: FFButtonOptions(
                            width: 150.0,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF011D45),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            print('Olvidaste tu contra');
                          },
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: Color.fromARGB(197, 255, 255, 255),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePageWidget()),
                            );
                          },
                          child: Text(
                            '¿No eres $nombre?',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 229, 231, 1),
                              fontFamily: 'Helvetica',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

  Future<void> getSharedPreferencesValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    pass = prefs.getString('password');
    nombre = prefs.getString('nombre');
    setState(() {
      fotoPerfil = prefs.getString('fotoPerfil');
    });

    print('Email: $email');
    print('pass: $pass');
    print('nombre: $nombre');
    print('foto: $fotoPerfil');
  }

  Future<void> loginConHuella() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Autenticate para ingresar a la aplicacion',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true, // Force biometric authentication only
        ),
      );
    } on PlatformException catch (e) {
      // Manejo de errores para excepciones específicas
      if (e.code == 'NotAvailable' || e.code == 'NotEnrolled') {
        // Handle the case where biometric is not available or not enrolled
        print('Biometric authentication is not available or not enrolled');
      } else {
        // Handle other exceptions
        print('An error occurred during biometric authentication: $e');
      }
    }

    if (isAuthenticated) {
      login();
    } else {
      print('Authentication failed');
    }
  }

  Future<String> login() async {
    String user = email.toString();
    String password = pass.toString();
    Map<String, String> data = {'user': user, 'password': password};

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('hello buey');
      print(jsonResponse);
      String _usuario = jsonResponse['Data'][0]['Value'];
      String _propiedad = jsonResponse['Data'][1]['Value'];
      Map<String, dynamic> data0 = jsonDecode(_usuario);
      Map<String, dynamic> data1 = jsonDecode(_propiedad);
      String _nombreUsuario = (data0['Name']);
      String _imagenProfile = data0['ImageProfile'];

      if (jsonResponse['Type'] == 'Success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user);
        await prefs.setString('password', password);
        await prefs.setString('nombre', _nombreUsuario);
        await prefs.setString('fotoPerfil', _imagenProfile);
        List<dynamic> _rolesUsuario = data1['RolesUser'];
        bool esAdministrador = false;
        for (var rol in _rolesUsuario) {
          if (rol == "Administrador") {
            esAdministrador = true;
            break;
          }
        }

        bool esVecino = false;
        for (var rol in _rolesUsuario) {
          if (rol == "Vecino") {
            esVecino = true;
            break;
          }
        }

        bool esVigilancia = false;
        for (var rol in _rolesUsuario) {
          if (rol == "Vigilancia") {
            esVigilancia = true;
            break;
          }
        }

        if (esVecino) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user);
          await prefs.setString('password', password);
          await prefs.setString('nombre', _nombreUsuario);
          String _idUsuario = data0['Id'].toString();
          await prefs.setString('fotoPerfil', _imagenProfile);
          await prefs.setString('idUsuario', _idUsuario);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InicioWidget(responseJson: jsonResponse)),
          );
        } else if (esAdministrador) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user);
          await prefs.setString('password', password);
          await prefs.setString('nombre', _nombreUsuario);
          await prefs.setString('fotoPerfil', _imagenProfile);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InicioWidget(responseJson: jsonResponse)),
          );
        } else if (esVigilancia) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user);
          await prefs.setString('password', password);
          await prefs.setString('nombre', _nombreUsuario);
          await prefs.setString('fotoPerfil', _imagenProfile);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    IniciovigWidget(responseJson: jsonResponse)),
          );
        }
      } else {
        print('valio verdura');
      }
      return jsonResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }
}
