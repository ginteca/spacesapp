import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../addtoken/addtoken_widget.dart';
import '../dashvigilante/dash_widget.dart';
import '../inicio/bar.dart';
import '../inicio/caddie.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'home_page_logged.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import '../inicio/inicio_widget.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  bool _obscureText = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final TextEditingController _nuevaContrasenaController =
      TextEditingController();
  final TextEditingController _repiteContrasenaController =
      TextEditingController();
  late String? email1 = '';
  late String? pass1 = '';

  //PROBAR SI YA SE HA INICADO ANTES
  Future<void> checkLogin() async {
    print('VALIDANDO SI YA SE CREO');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email1 = prefs.getString('email');
    String? password1 = prefs.getString('password');
    bool autoLogin = prefs.getBool('autoLogin') ?? true;
    bool useBiometrics = prefs.getBool('useBiometrics') ?? false;

    if (email1 != null && password1 != null) {
      print('Ya se ha iniciado sesión antes');
      print(email1);
      print(password1);

      if (email1 == 'bar@clubdegolf.com' && password1 == '123456') {
        // Acción específica para este usuario
        print('Acción específica para bar@clubdegolf.com');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BarControlScreen()), // Página específica para este usuario
        );

        return;
      } else if (email1 == 'restaurant@clubdegolf.com' &&
          password1 == '123456') {
        // Acción específica para este usuario
        print('Acción específica para restaurant@clubdegolf.com');

        return;
      } else if (email1 == 'caddy@clubdegolf.com' && password1 == '123456') {
        // Acción específica para este usuario
        print('Acción específica para caddy@clubdegolf.com');

        return;
      }

      if (autoLogin) {
        if (useBiometrics) {
          // Redirige a la pantalla de autenticación por huella digital
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePageWidgetLogged()),
          );
        } else {
          login1(email1, password1);
          // Redirige directamente a la pantalla principal
        }
      } else {
        // Si el inicio de sesión automático no está activo, muestra la pantalla de inicio de sesión normal
      }
    } else {
      print('No se ha iniciado sesión antes');
      // Redirige a la pantalla de inicio de sesión
    }
  }

  Future<String> login1(String user, String password) async {
    if (user == 'bar@clubdegolf.com' && password == '123456') {
      // Acción específica para este usuario
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BarControlScreen()), // Página específica para este usuario
      );
      return 'Logged in as bar';
    } else if (user == 'restaurant@clubdegolf.com' && password == '123456') {
      // Acción específica para este usuario
      print('Acción específica para restaurant@clubdegolf.com');

      return 'Logged in as restaurant';
    } else if (user == 'caddy@clubdegolf.com' && password == '123456') {
      // Acción específica para este usuario
      print('Acción específica para caddy@clubdegolf.com');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CaddyeApp()), // Página específica para este usuario
      );

      return 'Logged in as caddy';
    }
    Map<String, String> data = {'user': user, 'password': password};

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);
    var token;
    var direccionnew;
    var aliasnew;
    var numintnew;
    var numextnew;

    if (response.statusCode == 200) {
      //print(response.body);
      var jsonResponse = jsonDecode(response.body);
      print('hello buey 1');
      print(jsonResponse);
      if (jsonResponse.containsKey('Data') && jsonResponse['Data'] != null) {
        String _usuario = jsonResponse['Data'][0]['Value'];
        String _propiedad = jsonResponse['Data'][1]['Value'];
        Map<String, dynamic> data0 = jsonDecode(_usuario);
        //Map<String, dynamic> data1 = jsonDecode(_propiedad);
        String _nombreUsuario = (data0['Name']);
        String _imagenProfile = data0['ImageProfile'];
        //String _idPropiedad = data1['Id'].toString();
        //String _nombrePropiedad = data1['Name'];
        String _idUsuario = data0['Id'].toString();
        String _status = data0['Status'].toString();
        if (_propiedad == "none") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddtokenWidget(idUsuario: _idUsuario),
            ),
          );
        } else if (_status == 'PasswordReset') {
          String _idUsuario = data0['Id'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('idUsuario', _idUsuario);
          abrirModalPasswordReset(context);
        } else if (jsonResponse['Type'] == 'Succes') {
          errordecontra(context);
        } else if (jsonResponse['Type'] == 'Success') {
          String _usuario = jsonResponse['Data'][0]['Value'];
          String _propiedad = jsonResponse['Data'][1]['Value'];
          Map<String, dynamic> data0 = jsonDecode(_usuario);
          Map<String, dynamic> data1 = jsonDecode(_propiedad);
          String _nombreUsuario = (data0['Name']);
          String _imagenProfile = data0['ImageProfile'];
          String _idPropiedad = data1['Id'].toString();
          String _nombrePropiedad = data1['Name'];
          String _direccion = data1['Street'];
          String _numint = data1['NumInt'].toString();
          String _FinancialStatus = data1['FinancialStatus'].toString();
          String _idUsuario = data0['Id'].toString();
          String _nombreUsuario1 = (data0['Name'] + ' ' + data0['LastName']);
          Map<String, dynamic> _assocation = data1['Assocation'];
          String _nombreFracc = _assocation != null
              ? _assocation['Name']
              : "Nombre no disponible";
          Map<String, dynamic> associationData = data1['Assocation'];
          if (associationData != null && associationData.containsKey('Id')) {
            int idAssociation = associationData['Id'];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('IdAssociation', idAssociation);
          }
          //String fotoPerfil =
          String _status = data0['Status'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user);
          await prefs.setString('FinancialStatus', _FinancialStatus);
          await prefs.setString('password', password);
          await prefs.setString('nombre', _nombreUsuario);
          await prefs.setString('nombre1', _nombreUsuario1);
          await prefs.setString('idPropiedad', _idPropiedad);
          await prefs.setString('nombrePropiedad', _nombrePropiedad);
          await prefs.setString('fotoPerfil', _imagenProfile);
          await prefs.setString('idUsuario', _idUsuario);
          await prefs.setString('Status', _status);
          await prefs.setString('nombreFracc', _nombreFracc);
          await prefs.setString('direccion', _direccion);
          await prefs.setString('numint', _numint);
          List<dynamic> _rolesUsuario = data1['RolesUser'];
          print(_nombrePropiedad);
          print(_nombreFracc);
          await updatenoti();
          bool esAdministrador = false;
          for (var rol in _rolesUsuario) {
            if (rol == "Administrador") {
              esAdministrador = true;
              break; // Salimos del bucle una vez que encontramos "Administrador"
            }
          }

          // Buscamos si alguno de los roles es "Vecino"
          bool esVecino = false;
          for (var rol in _rolesUsuario) {
            if (rol == "Vecino") {
              esVecino = true;
              break; // Salimos del bucle una vez que encontramos "Vecino"
            }
          }

          // Buscamos si alguno de los roles es "Vigilancia"
          bool esVigilancia = false;
          for (var rol in _rolesUsuario) {
            if (rol == "Vigilancia") {
              esVigilancia = true;
              break; // Salimos del bucle una vez que encontramos "Vigilancia"
            }
          }
          if (esVecino) {
            print('Aqui si entro');
            print(_FinancialStatus);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //await prefs.clear();
            await prefs.setString('email', user);
            await prefs.setString('password', password);
            await prefs.setString('nombre', _nombreUsuario);
            //await prefs.setString('idPropiedad', _idPropiedad);
            //await prefs.setString('nombrePropiedad', _nombrePropiedad);
            await prefs.setString('fotoPerfil', _imagenProfile);
            await prefs.setString('idUsuario',
                _idUsuario); // Esta es la variable que se tiene que mandar
            await updatenoti();

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InicioWidget(responseJson: jsonResponse)),
            );
          } else if (esAdministrador) {
            print('Aqui si entro');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //await prefs.clear();
            await prefs.setString('email', user);
            await prefs.setString('password', password);
            await prefs.setString('nombre', _nombreUsuario);
            //await prefs.setString('idPropiedad', _idPropiedad);
            //await prefs.setString('nombrePropiedad', _nombrePropiedad);
            await prefs.setString('fotoPerfil', _imagenProfile);
            await prefs.setString('idUsuario',
                _idUsuario); // Esta es la variable que se tiene que mandar
            await updatenoti();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InicioWidget(responseJson: jsonResponse)),
            );
          } else if (esVigilancia) {
            print('Aqui si entro');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //await prefs.clear();
            await prefs.setString('email', user);
            await prefs.setString('password', password);
            await prefs.setString('nombre', _nombreUsuario);
            //await prefs.setString('idPropiedad', _idPropiedad);
            //await prefs.setString('nombrePropiedad', _nombrePropiedad);
            await prefs.setString('fotoPerfil', _imagenProfile);
            await prefs.setString('idUsuario',
                _idUsuario); // Esta es la variable que se tiene que mandar
            await updatenoti();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      IniciovigWidget(responseJson: jsonResponse)),
            );
          }
          //aqui agrega el Rol por favor
        } else {
          errordecontra(context);
        }
      } else {
        print('Error: El campo \'Data\' no está presente o es nulo');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mostrarDialogoCredencialesInvalidas(context);
        });
      }

      return jsonEncode(jsonResponse);
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Verificar las credenciales recibidas de Apple
      print('Apple ID Credential: $credential');

      // Verificar que userIdentifier no es nulo
      if (credential.userIdentifier == null) {
        print('Error: userIdentifier is null');
        return;
      }

      // Crear el email en el formato utilizado por Unity
      String email =
          credential.email ?? '${credential.userIdentifier}@appleid.com';
      String name = credential.givenName ?? 'Apple User';

      // Crear los datos del formulario en el formato esperado por la API
      final Map<String, dynamic> formData = {
        'email': email,
        'id': credential.userIdentifier,
        'name': name,
      };

      // Verificar los datos que serán enviados a la API
      print('Form data: $formData');

      final response = await http.post(
        Uri.parse(
            'https://appaltea.azurewebsites.net/api/Mobile/LoginUserApple'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData, // Cambiamos a x-www-form-urlencoded
      );

      // Verificar la respuesta del servidor
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['Type'] == 'Success') {
          print('Login successful');

          // Extraer user y password de la respuesta
          String user = responseData['Data']
              .firstWhere((element) => element['Name'] == 'User')['Value'];
          String password = responseData['Data']
              .firstWhere((element) => element['Name'] == 'Password')['Value'];
          String profile = responseData['Data']
              .firstWhere((element) => element['Name'] == 'Profile')['Value'];
          String lastProperty = responseData['Data'].firstWhere(
              (element) => element['Name'] == 'LastProperty')['Value'];

          // Guardar user, password, profile y lastProperty en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user);
          await prefs.setString('password', password);
          await prefs.setString('profile', profile);
          await prefs.setString('lastProperty', lastProperty);

          // Llamar a la función de login
          await login3();
        } else {
          print('Login failed: ${responseData['Message']}');
          // Mostrar un mensaje de error al usuario
        }
      } else {
        print('Failed to sign in with Apple: ${response.body}');
      }
    } catch (e) {
      print('Error during sign in with Apple: $e');
    }
  }

  Future<void> login3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';

    if (user.isEmpty || password.isEmpty) {
      print('No se encontraron las credenciales en SharedPreferences');
      mostrarDialogoCredencialesInvalidas(context);
      return;
    }

    Map<String, String> data = {'user': user, 'password': password};

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('hello buey 1');
      print(jsonResponse);

      if (jsonResponse['Type'] == 'Success') {
        if (jsonResponse.containsKey('Data') && jsonResponse['Data'] != null) {
          String _usuario = jsonResponse['Data'][0]['Value'];
          String _propiedad = jsonResponse['Data'][1]['Value'];
          Map<String, dynamic> data0 = jsonDecode(_usuario);
          String _nombreUsuario = (data0['Name']);
          String _imagenProfile = data0['ImageProfile'];
          String _idUsuario = data0['Id'].toString();
          String _status = data0['Status'].toString();
          if (_propiedad == "none") {
            Map<String, dynamic> data0 = jsonDecode(_usuario);
            String _idUsuario = data0['Id'].toString();
            await prefs.setString('idUsuario', _idUsuario);
            print(_idUsuario);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddtokenWidget(idUsuario: _idUsuario)),
            );
          } else if (_status == 'PasswordReset') {
            String _idUsuario = data0['Id'].toString();
            await prefs.setString('idUsuario', _idUsuario);
            abrirModalPasswordReset(context);
          } else if (jsonResponse['Type'] == 'Succes') {
            errordecontra(context);
          } else if (jsonResponse['Type'] == 'Success') {
            String _usuario = jsonResponse['Data'][0]['Value'];
            String _propiedad = jsonResponse['Data'][1]['Value'];
            Map<String, dynamic> data0 = jsonDecode(_usuario);
            Map<String, dynamic> data1 = jsonDecode(_propiedad);
            String _nombreUsuario = (data0['Name']);
            String _imagenProfile = data0['ImageProfile'];
            String _idPropiedad = data1['Id'].toString();
            String _nombrePropiedad = data1['Name'];
            String _direccion = data1['Street'];
            String _numint = data1['NumInt'].toString();
            String _FinancialStatus = data1['FinancialStatus'].toString();
            String _idUsuario = data0['Id'].toString();
            String _nombreUsuario1 = (data0['Name'] + ' ' + data0['LastName']);
            String _lastname = data0['LastName'];
            Map<String, dynamic> _assocation = data1['Assocation'];
            String _nombreFracc = _assocation != null
                ? _assocation['Name']
                : "Nombre no disponible";
            Map<String, dynamic> associationData = data1['Assocation'];
            if (associationData != null && associationData.containsKey('Id')) {
              int idAssociation = associationData['Id'];
              await prefs.setInt('IdAssociation', idAssociation);
            }
            String _status = data0['Status'].toString();
            await prefs.setString('email', user);
            await prefs.setString('FinancialStatus', _FinancialStatus);
            await prefs.setString('password', password);
            await prefs.setString('nombre', _nombreUsuario);
            await prefs.setString('nombre1', _nombreUsuario1);
            await prefs.setString('idPropiedad', _idPropiedad);
            await prefs.setString('nombrePropiedad', _nombrePropiedad);
            await prefs.setString('fotoPerfil', _imagenProfile);
            await prefs.setString('idUsuario', _idUsuario);
            await prefs.setString('Status', _status);
            await prefs.setString('nombreFracc', _nombreFracc);
            await prefs.setString('direccion', _direccion);
            await prefs.setString('numint', _numint);
            await prefs.setString('lastname', _lastname);
            List<dynamic> _rolesUsuario = data1['RolesUser'];
            print(_nombrePropiedad);
            print(_nombreFracc);
            await updatenoti();
            bool esAdministrador = false;
            for (var rol in _rolesUsuario) {
              if (rol == "Administrador") {
                esAdministrador = true;
                break; // Salimos del bucle una vez que encontramos "Administrador"
              }
            }

            // Buscamos si alguno de los roles es "Vecino"
            bool esVecino = false;
            for (var rol in _rolesUsuario) {
              if (rol == "Vecino") {
                esVecino = true;
                break; // Salimos del bucle una vez que encontramos "Vecino"
              }
            }

            // Buscamos si alguno de los roles es "Vigilancia"
            bool esVigilancia = false;
            for (var rol in _rolesUsuario) {
              if (rol == "Vigilancia") {
                esVigilancia = true;
                break; // Salimos del bucle una vez que encontramos "Vigilancia"
              }
            }
            if (esVecino) {
              print('Aqui si entro');
              print(_FinancialStatus);
              await prefs.setString('email', user);
              await prefs.setString('password', password);
              await prefs.setString('nombre', _nombreUsuario);
              await prefs.setString('fotoPerfil', _imagenProfile);
              await prefs.setString('idUsuario', _idUsuario);
              await updatenoti();

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InicioWidget(responseJson: jsonResponse)),
              );
            } else if (esAdministrador) {
              print('Aqui si entro');
              await prefs.setString('email', user);
              await prefs.setString('password', password);
              await prefs.setString('nombre', _nombreUsuario);
              await prefs.setString('fotoPerfil', _imagenProfile);
              await prefs.setString('idUsuario', _idUsuario);
              await updatenoti();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InicioWidget(responseJson: jsonResponse)),
              );
            } else if (esVigilancia) {
              print('Aqui si entro');
              await prefs.setString('email', user);
              await prefs.setString('password', password);
              await prefs.setString('nombre', _nombreUsuario);
              await prefs.setString('fotoPerfil', _imagenProfile);
              await prefs.setString('idUsuario', _idUsuario);
              await updatenoti();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IniciovigWidget(responseJson: jsonResponse)),
              );
            }
          } else {
            errordecontra(context);
          }
        } else {
          print('Error: El campo \'Data\' no está presente o es nulo');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mostrarDialogoCredencialesInvalidas(context);
          });
        }
      } else {
        throw Exception('Error al realizar la petición POST');
      }
    }
  }

  void mostrarDialogoCredencialesInvalidas(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Color.fromARGB(186, 243, 243, 243), // Color de fondo del Dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //rgba(0, 15, 36, 1)
                  width: 800,
                  color: Color.fromRGBO(0, 15, 36, 0.308),
                  child: Column(
                    children: [
                      Text(
                        'CREDENCIALES INVALIDAS',
                        style: TextStyle(
                            color: Color.fromARGB(255, 7, 236, 225),
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Revisa si las credenciales proporcionadas son las correctas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> enviarCorreoAPI(String email) async {
    // Aquí va el código para enviar el email a la API
    final String apiUrl =
        'https://jaus.azurewebsites.net/api/Mobile/ForgotPassword/';

    Map<String, String> data = {
      'Email': email
    }; // Cambio aquí: 'correo' por 'Email'

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      // Manejo de la respuesta
      print(email);

      print('Email enviado con éxito');
    } else {
      // Manejo de errores
      throw Exception('Error al enviar el email');
    }
  }

  Future<void> updatenoti(
      {int maxRetries = 5,
      Duration retryInterval = const Duration(seconds: 2)}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser;
    String idnot;
    int retries = 0;

    do {
      idUser = prefs.getString('idUsuario') ?? '';
      idnot = prefs.getString('player_id') ?? '';

      if (idUser.isNotEmpty && idnot.isNotEmpty) {
        // Si ambos ID están disponibles, envía la solicitud
        await _sendUpdateNotificationRequest(idUser, idnot);
        return;
      } else {
        // Espera si alguno de los IDs aún no está disponible
        await Future.delayed(retryInterval);
      }
      retries++;
    } while (retries < maxRetries);

    print(
        'Error: No se pudo obtener el ID del usuario o el Player ID después de los intentos de reintento.');
  }

  Future<void> _sendUpdateNotificationRequest(
      String idUser, String idnot) async {
    final String apiUrl3 =
        'https://appaltea.azurewebsites.net/api/Mobile/UpdatePushNotification/';
    Map<String, String> data = {'idUser': idUser, 'PushNotificationId': idnot};

    final response = await http.post(Uri.parse(apiUrl3),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      print('Notificación dada de alta');
      print('Player ID: $idnot');
      print('ID Usuario: $idUser');
    } else {
      throw Exception(
          'Error al actualizar notificación - ID Usuario: $idUser, Player ID: $idnot');
    }
  }

  Future<void> changepass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString('idUsuario') ?? '';

    if (idUser.isEmpty) {
      print("No se encontró el ID del usuario");
      return;
    }

    String newpassword = _nuevaContrasenaController.text.trim();
    final String apiUrl2 =
        'https://appaltea.azurewebsites.net/api/Mobile/ChangePassword/';

    Map<String, String> data = {'idUser': idUser, 'password': newpassword};

    final response = await http.post(Uri.parse(apiUrl2),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      print('Contra cambiada');
      abrirNuevoModalreset(context);
      print(idUser);
    } else {
      throw Exception('Error al cambiar contraseña' + idUser + newpassword);
    }
  }

  void abrirModalPasswordReset(BuildContext context) {
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
                // Campo para la nueva contraseña
                TextFormField(
                  controller: _nuevaContrasenaController,
                  decoration: InputDecoration(labelText: 'Nueva Contraseña'),
                  obscureText: true, // Esto es para ocultar la contraseña
                ),
                SizedBox(height: 10), // Un pequeño espacio entre los campos
                // Campo para repetir la contraseña
                TextFormField(
                  controller: _repiteContrasenaController,
                  decoration:
                      InputDecoration(labelText: 'Repite la Contraseña'),
                  obscureText: true, // Esto es para ocultar la contraseña
                ),
                SizedBox(height: 20), // Un espacio antes del botón
                // Botón para aceptar
                FFButtonWidget(
                  onPressed: () async {
                    if (_nuevaContrasenaController.text ==
                        _repiteContrasenaController.text) {
                      await changepass();
                    } else {
                      // Manejar el error de contraseñas que no coinciden
                      print('Las contraseñas no coinciden');
                    }
                  },
                  text: 'RECUPERA',
                  options: FFButtonOptions(
                    width: 150.0,
                    height: 40.0,
                    color: Color(0xFF011D45),
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                    borderRadius: BorderRadius.circular(34.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    _model = createModel(context, () => HomePageModel());

    _model.textFieldCorreoController ??= TextEditingController();
    _model.textFieldPasswordController ??= TextEditingController();
    _model.textFieldforgotpassController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    _unfocusNode.dispose();
    _nuevaContrasenaController.dispose();
    _repiteContrasenaController.dispose();
    super.dispose();
  }

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgotpassController = TextEditingController();
  final _correoRecuperar = TextEditingController();
  final _newusernameController = TextEditingController();
  final _newpasswordController = TextEditingController();
  final _token = TextEditingController();
  final _direccionnew = TextEditingController();
  final _numintnew = TextEditingController();
  final _numextnew = TextEditingController();
  final _aliasnew = TextEditingController();
  TextEditingController _tokenController = TextEditingController();

  bool _isHidden = true;

  final String apiUrl = 'https://jaus.azurewebsites.net/api/Mobile/LoginUser/';
  final String apiUrlGuardarToken =
      'https://appaltea.azurewebsites.net/api/Mobile/RegisterProperty/';

  Future<String> login() async {
    String user = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    if (user == 'bar@clubdegolf.com' && password == '123456') {
      // Acción específica para este usuario
      // Puedes agregar aquí el código específico que quieres ejecutar
      print('Acción específica para bar@clubdegolf.com');
      // Por ejemplo, redirigir a una página diferente
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BarControlScreen()), // Página específica para este usuario
      );

      return jsonEncode('Logged in as bar');
    } else if (user == 'restaurant@clubdegolf.com' && password == '123456') {
      // Acción específica para este usuario
      print('Acción específica para restaurant@clubdegolf.com');

      return jsonEncode('Logged in as restaurant');
    } else if (user == 'caddy@clubdegolf.com' && password == '123456') {
      // Acción específica para este usuario
      print('Acción específica para caddy@clubdegolf.com');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CaddyeApp()), // Página específica para este usuario
      );

      return jsonEncode('Logged in as caddy');
    }

    Map<String, String> data = {'user': user, 'password': password};

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);
    var token;
    var direccionnew;
    var aliasnew;
    var numintnew;
    var numextnew;

    if (response.statusCode == 200) {
      //print(response.body);
      var jsonResponse = jsonDecode(response.body);
      print('hello buey 1');
      print(jsonResponse);
      if (jsonResponse.containsKey('Data') && jsonResponse['Data'] != null) {
        String _usuario = jsonResponse['Data'][0]['Value'];
        String _propiedad = jsonResponse['Data'][1]['Value'];
        Map<String, dynamic> data0 = jsonDecode(_usuario);
        //Map<String, dynamic> data1 = jsonDecode(_propiedad);
        String _nombreUsuario = (data0['Name']);
        String _imagenProfile = data0['ImageProfile'];
        //String _idPropiedad = data1['Id'].toString();
        //String _nombrePropiedad = data1['Name'];
        String _idUsuario = data0['Id'].toString();
        String _status = data0['Status'].toString();
        if (_propiedad == "none") {
          Map<String, dynamic> data0 = jsonDecode(_usuario);
          String _idUsuario = data0['Id'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('idUsuario', _idUsuario);
          print(_idUsuario);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddtokenWidget(idUsuario: _idUsuario)),
          );
        } else if (_status == 'PasswordReset') {
          String _idUsuario = data0['Id'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('idUsuario', _idUsuario);
          abrirModalPasswordReset(context);
        } else if (jsonResponse['Type'] == 'Succes') {
          errordecontra(context);
        } else if (jsonResponse['Type'] == 'Success') {
          String _usuario = jsonResponse['Data'][0]['Value'];
          String _propiedad = jsonResponse['Data'][1]['Value'];
          Map<String, dynamic> data0 = jsonDecode(_usuario);
          Map<String, dynamic> data1 = jsonDecode(_propiedad);
          String _nombreUsuario = (data0['Name']);
          String _imagenProfile = data0['ImageProfile'];
          String _idPropiedad = data1['Id'].toString();
          String _nombrePropiedad = data1['Name'];
          String _direccion = data1['Street'];
          String _numint = data1['NumInt'].toString();
          String _FinancialStatus = data1['FinancialStatus'].toString();
          String _idUsuario = data0['Id'].toString();
          String _nombreUsuario1 = (data0['Name'] + ' ' + data0['LastName']);
          String _lastname = data0['LastName'];
          Map<String, dynamic> _assocation = data1['Assocation'];
          String _nombreFracc = _assocation != null
              ? _assocation['Name']
              : "Nombre no disponible";
          Map<String, dynamic> associationData = data1['Assocation'];
          if (associationData != null && associationData.containsKey('Id')) {
            int idAssociation = associationData['Id'];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('IdAssociation', idAssociation);
          }
          //String fotoPerfil =
          String _status = data0['Status'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user);
          await prefs.setString('FinancialStatus', _FinancialStatus);
          await prefs.setString('password', password);
          await prefs.setString('nombre', _nombreUsuario);
          await prefs.setString('nombre1', _nombreUsuario1);
          await prefs.setString('idPropiedad', _idPropiedad);
          await prefs.setString('nombrePropiedad', _nombrePropiedad);
          await prefs.setString('fotoPerfil', _imagenProfile);
          await prefs.setString('idUsuario', _idUsuario);
          await prefs.setString('Status', _status);
          await prefs.setString('nombreFracc', _nombreFracc);
          await prefs.setString('direccion', _direccion);
          await prefs.setString('numint', _numint);
          await prefs.setString('lastname', _lastname);
          List<dynamic> _rolesUsuario = data1['RolesUser'];
          print(_nombrePropiedad);
          print(_nombreFracc);
          await updatenoti();
          bool esAdministrador = false;
          for (var rol in _rolesUsuario) {
            if (rol == "Administrador") {
              esAdministrador = true;
              break; // Salimos del bucle una vez que encontramos "Administrador"
            }
          }

          // Buscamos si alguno de los roles es "Vecino"
          bool esVecino = false;
          for (var rol in _rolesUsuario) {
            if (rol == "Vecino") {
              esVecino = true;
              break; // Salimos del bucle una vez que encontramos "Vecino"
            }
          }

          // Buscamos si alguno de los roles es "Vigilancia"
          bool esVigilancia = false;
          for (var rol in _rolesUsuario) {
            if (rol == "Vigilancia") {
              esVigilancia = true;
              break; // Salimos del bucle una vez que encontramos "Vigilancia"
            }
          }
          if (esVecino) {
            print('Aqui si entro');
            print(_FinancialStatus);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //await prefs.clear();
            await prefs.setString('email', user);
            await prefs.setString('password', password);
            await prefs.setString('nombre', _nombreUsuario);
            //await prefs.setString('idPropiedad', _idPropiedad);
            //await prefs.setString('nombrePropiedad', _nombrePropiedad);
            await prefs.setString('fotoPerfil', _imagenProfile);
            await prefs.setString('idUsuario',
                _idUsuario); // Esta es la variable que se tiene que mandar
            await updatenoti();

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InicioWidget(responseJson: jsonResponse)),
            );
          } else if (esAdministrador) {
            print('Aqui si entro');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //await prefs.clear();
            await prefs.setString('email', user);
            await prefs.setString('password', password);
            await prefs.setString('nombre', _nombreUsuario);
            //await prefs.setString('idPropiedad', _idPropiedad);
            //await prefs.setString('nombrePropiedad', _nombrePropiedad);
            await prefs.setString('fotoPerfil', _imagenProfile);
            await prefs.setString('idUsuario',
                _idUsuario); // Esta es la variable que se tiene que mandar
            await updatenoti();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InicioWidget(responseJson: jsonResponse)),
            );
          } else if (esVigilancia) {
            print('Aqui si entro');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //await prefs.clear();
            await prefs.setString('email', user);
            await prefs.setString('password', password);
            await prefs.setString('nombre', _nombreUsuario);
            //await prefs.setString('idPropiedad', _idPropiedad);
            //await prefs.setString('nombrePropiedad', _nombrePropiedad);
            await prefs.setString('fotoPerfil', _imagenProfile);
            await prefs.setString('idUsuario',
                _idUsuario); // Esta es la variable que se tiene que mandar
            await updatenoti();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      IniciovigWidget(responseJson: jsonResponse)),
            );
          }
          //aqui agrega el Rol por favor
        } else {
          errordecontra(context);
        }
      } else {
        print('Error: El campo \'Data\' no está presente o es nulo');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mostrarDialogoCredencialesInvalidas(context);
        });
      }

      return jsonEncode(jsonResponse);
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/fondop.png'),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.07,
                      vertical: MediaQuery.of(context).size.width * 0.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.00),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(0, 255, 255, 255),
                        borderRadius: BorderRadius.circular(37.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Image.asset(
                            'assets/images/Logo3.png',
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Image.asset(
                            'assets/images/GENTE.png',
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              controller: _usernameController,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Correo electronico...',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF011D45),
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF011D45), width: 1.0),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF011D45), width: 1.0),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                filled: true,
                                fillColor: Color(0x67FFFFFF),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xFF011D45),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF011D45),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                              textAlign: TextAlign.start,
                              validator: _model
                                  .textFieldCorreoControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: 'Contraseña...',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF011D45),
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF011D45), width: 1.0),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF011D45), width: 1.0),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                filled: true,
                                fillColor: Color(0x67FFFFFF),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xFF011D45),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF011D45),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                              textAlign: TextAlign.start,
                              validator: _model
                                  .textFieldPasswordControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Color.fromARGB(186, 243,
                                        243, 243), // Color de fondo del Dialog
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Bordes redondeados
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            color: Color.fromRGBO(
                                                0, 15, 36, 0.308),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.7,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: Icon(
                                                      Icons.cancel_outlined,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                      color: Color.fromARGB(
                                                          255, 0, 236, 205),
                                                      shadows: [
                                                        Shadow(
                                                          offset:
                                                              Offset(2.0, 2.0),
                                                          blurRadius: 3.0,
                                                          color: Color.fromARGB(
                                                              255, 68, 68, 68),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'RECUPERAR CONTRASEÑA',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 7, 236, 225),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Te ayudaremos a recuperar tu contraseña, escribe tu correo electronico con el cual te registraste.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              0.0,
                                              0.0,
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: TextFormField(
                                                controller:
                                                    _forgotpassController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Correo electronico',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                      ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            34.0),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            34.0),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color(0x67FFFFFF),
                                                  prefixIcon: Icon(Icons.person,
                                                      color: Colors.white),
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                    ),
                                                textAlign: TextAlign.start,
                                                validator: _model
                                                    .textFieldCorreoControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                          //Boton de recuperar
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              0.0,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                print('boton recuperarggg');
                                                String email =
                                                    _forgotpassController.text
                                                        .trim();
                                                print(email);
                                                await enviarCorreoAPI(email);
                                                abrirNuevoModal(context);
                                              },
                                              text: 'RECUPERA',
                                              options: FFButtonOptions(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: Color(0xFF011D45),
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                    ),
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(34.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Recuperar Contraseña",
                              style: TextStyle(
                                color: Color(0xFFA03AFB),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          FFButtonWidget(
                            onPressed: () async {
                              await login();
                            },
                            text: 'ENTRAR',
                            options: FFButtonOptions(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.04,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFA03AFB),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(34.0),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed('registrar');
                            },
                            text: 'REGISTRAR',
                            options: FFButtonOptions(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.04,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF5464C6),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(34.0),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          // Botón de inicio de sesión con Apple
                          GestureDetector(
                            onTap: () async {
                              await _signInWithApple();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ingresa con Apple',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF5464C6),
                                  ),
                                ),
                                SizedBox(height: 6.0),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF5464C6),
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.apple,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.0),
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Color.fromARGB(186, 243,
                                        243, 243), // Color de fondo del Dialog
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Bordes redondeados
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            color: Color.fromRGBO(
                                                0, 15, 36, 0.308),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.7,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: Icon(
                                                      Icons.cancel_outlined,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                      color: Color.fromARGB(
                                                          255, 0, 236, 205),
                                                      shadows: [
                                                        Shadow(
                                                          offset:
                                                              Offset(2.0, 2.0),
                                                          blurRadius: 3.0,
                                                          color: Color.fromARGB(
                                                              255, 68, 68, 68),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Política de privacidad',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 7, 236, 225),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          contentPolitica(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Política de privacidad",
                              style: TextStyle(
                                color: Color(0xFF5464C6),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void abrirNuevoModal(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Color.fromARGB(186, 243, 243, 243), // Color de fondo del Dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0), // Bordes redondeados
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 20.0),
                        child: Text(
                          'CONFIRMACION',
                          style: TextStyle(
                              color: Color.fromARGB(255, 7, 236, 225),
                              fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 20.0),
                        child: Container(
                          child: Icon(
                            Icons.forward_to_inbox,
                            size: 75,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Te hemos enviado un correo con tu nueva contraseña',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                //Boton de recuperar
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 15.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      // buttonEntendido
                      print('Entendido');
                      Navigator.of(context).pop();
                    },
                    text: 'ENTENDIDO',
                    options: FFButtonOptions(
                      width: 150.0,
                      height: 40.0,
                      color: Color(0xFF011D45),
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                      borderRadius: BorderRadius.circular(34.0),
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

  void errordecontra(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Color.fromARGB(186, 243, 243, 243), // Color de fondo del Dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0), // Bordes redondeados
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 20.0),
                        child: Text(
                          'Error de contraseña',
                          style: TextStyle(
                              color: Color.fromARGB(255, 7, 236, 225),
                              fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 20.0),
                        child: Container(
                          child: Icon(
                            Icons.forward_to_inbox,
                            size: 75,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Error de contraseña',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                //Boton de recuperar
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 15.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      // buttonEntendido
                      print('Entendido');
                      Navigator.of(context).pop();
                    },
                    text: 'ENTENDIDO',
                    options: FFButtonOptions(
                      width: 150.0,
                      height: 40.0,
                      color: Color(0xFF011D45),
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                      borderRadius: BorderRadius.circular(34.0),
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

  void abrirNuevoModalreset(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Color.fromARGB(186, 243, 243, 243), // Color de fondo del Dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0), // Bordes redondeados
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 20.0),
                        child: Text(
                          'Confirmado',
                          style: TextStyle(
                              color: Color.fromARGB(255, 7, 236, 225),
                              fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 20.0),
                        child: Container(
                          child: Icon(
                            Icons.password,
                            size: 75,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Se cambio tu contraseña Exitosamente Inicia sesion',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                //Boton de recuperar
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 15.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      // buttonEntendido
                      print('Entendido');
                      Navigator.of(context).pop();
                    },
                    text: 'ENTENDIDO',
                    options: FFButtonOptions(
                      width: 150.0,
                      height: 40.0,
                      color: Color(0xFF011D45),
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                      borderRadius: BorderRadius.circular(34.0),
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

  contentPolitica() {
    return Container(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.70,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: Container(
                      child: Text(
                        'Política de privacidad\n'
                        '\n'
                        'AVISO \nDE PRIVACIDAD\n'
                        '\n'
                        'Última modificación: Mayo de 2023.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        "Agradecemos tu confianza al proporcionarnos tu información personal y nos comprometemos a darle un tratamiento transparente para brindarte un ambiente de seguridad al usar nuestra aplicación móvil App Habitan-t, así como nuestro sitio web https://app.habitan-t.com/, en lo sucesivo la APLICACIÓN. Por lo que, de acuerdo a la legislación aplicable en nuestro país, como lo es la Constitución Política de los Estados Unidos Mexicanos, la Ley Federal de Protección de Datos Personales en Posesión de los Particulares, su Reglamento, los Lineamientos del Aviso de Privacidad, así como estándares Nacionales e Internacionales en Materia de Protección de Datos Personales, Gintec Aply S.A. de C.V., pone a tu disposición el siguiente Aviso de Privacidad.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        '¿Quién es el responsable de tus datos?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        'Gintec Aply S.A. de C.V., es responsable del uso y protección de la información personal que nos proporciones, y tiene su domicilio para oír y recibir notificaciones ubicado en calle Campo Deportivo número 107, colonia Santa Julia, Pachuca de Soto, Hidalgo, C.P. 42080.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(67, 66, 93, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        '¿Con que finalidad recabamos tus datos personales?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        'Los datos personales que recabamos de ti serán utilizados para las siguientes finalidades, las cuales son necesarias para concretar nuestra relación contigo, así como brindarte los productos, servicios y/o beneficios que solicitas o contratas con nosotros:\n'
                        '\n'
                        '•  Identificarte y contactarte\n'
                        '\n'
                        '•  Registrarte en nuestros sistemas\n'
                        '\n'
                        '•  Verificar tu identidad en cumplimiento de exigencias legales\n'
                        '\n'
                        '•	Validar, actualizar y corregir tu información\n'
                        '\n'
                        '•	Elaborar y mantener un registro de las operaciones que realices, así como informarte acerca de las mismas y darle seguimiento correspondiente\n'
                        '\n'
                        '•	Atender tus comentarios, quejas y sugerencias, así como brindarte soporte\n'
                        '\n'
                        '•	Ofrecerte servicios y funcionalidades que se adecuen mejor a tus necesidades, y personalizar nuestros servicios para hacer que tu experiencia con Gintec Aply S.A. de C.V., sea lo más cómoda posible.\n'
                        '\n'
                        '•	Darles seguimiento a las cotizaciones de los productos que comercializa o fabrique Gintec Aply S.A. de C.V.\n'
                        '\n'
                        '•	Darles seguimiento a las solicitudes de asociación con Gintec Aply S.A. de C.V., que realices. \n'
                        '\n'
                        'Además, como finalidades secundarias para las cuales podemos utilizar tu información personal, tenemos:\n'
                        '\n'
                        '•  Contactarte a través de diferentes canales (por correo electrónico, mensajes cortos de texto (SMS), mensajes push, llamadas telefónicas o cualquier otro medio) para finalidades publicitarias y/o promocionales de productos y servicios de Gintec Aply S.A. de C.V.\n'
                        '\n'
                        '•	Efectuar todo tipo de actividades de mercadotecnia, publicidad, prospección comercial y/o estudios de mercado.\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        'Tratamiento de datos personales de menores de edad y personas en estado de interdicción o incapacidad.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.0,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        'Los servicios de Habitan-T solo estarán disponibles para menores de edad y personas en estado de interdicción o incapacidad, mediante el previo consentimiento de la persona que ejerce la patria potestad, o en su caso, del tutor o representante legal.\n'
                        '\n'
                        'Si estás comprendido dentro de esta categoría y no cuentas con el consentimiento de tu representante, no deberás suministrar su información personal.\n'
                        '\n'
                        'A través de tu representante legal podrás también ejercer tus derechos de acceso, rectificación, cancelación y oposición al tratamiento de tu Información Personal, así como limitar el uso o divulgación de tus datos personales.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        'Datos Personales que podrán recabarse',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Container(
                      child: Text(
                        'Para la operación de nuestra Aplicación es necesario recabar las siguientes categorías de datos personales:\n'
                        '\n'
                        '1. Datos de identificación y de contacto, tales como tu nombre, correo electrónico, número de teléfono, fecha de nacimiento, domicilio particular, Registro Federal de Contribuyentes (RFC), firma, lugar de trabajo, cargo que ocupa, dirección de la empresa, así como información que nos permita mantener contacto contigo.\n'
                        '\n'
                        '2. Datos patrimoniales y financieros, tales como tu información bancaria, CLABE Interbancaria y Número de tarjeta de crédito y/o débito, para la gestión de pagos por los servicios prestados.\n'
                        '\n'
                        '3. Datos de imagen y voz, tales como fotografías o videos captados mediante nuestras cámaras de vigilancia y/o cámaras de tu dispositivo móvil, así como grabaciones de voz obtenidas mediante grabaciones telefónicas.\n'
                        '\n'
                        '4. Datos de geolocalización, como información que nos permita determinar tu ubicación física.\n'
                        '\n'
                        '5. Datos de identificación digital, tales como información sobre tu dispositivo, dirección IP, sistema operativo y tipo de navegador que utilizas para acceder a nuestra Aplicación.\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
