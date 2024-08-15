import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dashvigilante/dash_widget.dart';
import 'bar.dart';
import 'caddie.dart';
import 'inicio_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SuccessScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final String apiUrl = 'https://jaus.azurewebsites.net/api/Mobile/LoginUser/';
  final String updateHikregisterUrl =
      'https://jaus.azurewebsites.net/hikregister.php'; // Reemplaza con tu URL de API
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('email');
    String? password = prefs.getString('password');
    String? userNeighborId = prefs.getString('idUsuario');

    if (user == null || password == null || userNeighborId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (user == 'bar@clubdegolf.com' && password == '123456') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BarControlScreen()),
      );
    } else if (user == 'restaurant@clubdegolf.com' && password == '123456') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BarControlScreen()),
      );
    } else if (user == 'caddy@clubdegolf.com' && password == '123456') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CaddyeApp()),
      );
    } else {
      Map<String, String> data = {'user': user, 'password': password};

      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: data);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('Data') && jsonResponse['Data'] != null) {
          String _usuario = jsonResponse['Data'][0]['Value'];
          String _propiedad = jsonResponse['Data'][1]['Value'];
          Map<String, dynamic> data0 = jsonDecode(_usuario);
          String _nombreUsuario = (data0['Name']);
          String _imagenProfile = data0['ImageProfile'];
          String _idUsuario = data0['Id'].toString();
          String _status = data0['Status'].toString();
          if (_propiedad == "none") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('idUsuario', _idUsuario);
          } else if (_status == 'PasswordReset') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('idUsuario', _idUsuario);
          } else if (jsonResponse['Type'] == 'Succes' ||
              jsonResponse['Type'] == 'Success') {
            String _propiedad = jsonResponse['Data'][1]['Value'];
            Map<String, dynamic> data1 = jsonDecode(_propiedad);
            String _idPropiedad = data1['Id'].toString();
            String _nombrePropiedad = data1['Name'];
            String _direccion = data1['Street'];
            String _numint = data1['NumInt'].toString();
            String _FinancialStatus = data1['FinancialStatus'].toString();
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
            await updatenoti();
            bool esAdministrador = _rolesUsuario.contains('Administrador');
            bool esVecino = _rolesUsuario.contains('Vecino');
            bool esVigilancia = _rolesUsuario.contains('Vigilancia');

            await updateHikregister(userNeighborId, true);

            if (esVecino) {
              await updatenoti();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InicioWidget(responseJson: jsonResponse)),
              );
            } else if (esAdministrador) {
              await updatenoti();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InicioWidget(responseJson: jsonResponse)),
              );
            } else if (esVigilancia) {
              await updatenoti();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IniciovigWidget(responseJson: jsonResponse)),
              );
            }
          } else {
            print('Error: El campo \'Data\' no está presente o es nulo');
          }
        }
      } else {
        throw Exception('Error al realizar la petición POST');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateHikregister(
      String userNeighborId, bool hikregister) async {
    final response = await http.post(
      Uri.parse(updateHikregisterUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'UserNeighbor_Id': userNeighborId,
        'hikregister': hikregister,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        print('Hikregister updated successfully');
      } else {
        print('Failed to update hikregister: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to update hikregister');
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
        await _sendUpdateNotificationRequest(idUser, idnot);
        return;
      } else {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromRGBO(101, 119, 255, 1),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Image.asset(
                    'assets/images/ef/5.png',
                    height: size.height * 0.4,
                    width: size.width * 0.6,
                  ),
                  SizedBox(height: size.height * 0.05),
                  Text(
                    'REGISTRO EXITOSO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.1),
                    child: ElevatedButton(
                      onPressed: () {
                        login(
                            context); // Ejecutar la función login al presionar el botón
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900],
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.1,
                            vertical: size.height * 0.02),
                      ),
                      child: Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
      ),
    );
  }
}
