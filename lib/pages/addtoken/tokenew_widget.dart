import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPropertyScreen extends StatefulWidget {
  @override
  _RegisterPropertyScreenState createState() => _RegisterPropertyScreenState();
}

class _RegisterPropertyScreenState extends State<RegisterPropertyScreen> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numExtController = TextEditingController();
  final TextEditingController _numIntController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  String _idUser = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getString('idUsuario') ?? '';
    });
  }

  Future<void> _registerProperty() async {
    try {
      await nuevapropiedad(
        _tokenController.text,
        _idUser,
        _aliasController.text,
        _streetController.text,
        _numExtController.text,
        _numIntController.text,
        _zipCodeController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Propiedad registrada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la propiedad: $e')),
      );
    }
  }

  Future<void> nuevapropiedad(
    String token,
    String idUsuario,
    String alias,
    String street,
    String numExt,
    String numInt,
    String zipCode,
  ) async {
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
      'longitude': "80.654321"
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: data,
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar el Token');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Propiedad'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: screenHeight * 0.5), // Espacio en la parte superior
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _tokenController,
                    decoration: InputDecoration(labelText: 'Token'),
                  ),
                  TextField(
                    controller: _aliasController,
                    decoration: InputDecoration(labelText: 'Alias'),
                  ),
                  TextField(
                    controller: _streetController,
                    decoration: InputDecoration(labelText: 'Calle'),
                  ),
                  TextField(
                    controller: _numExtController,
                    decoration: InputDecoration(labelText: 'Número Exterior'),
                  ),
                  TextField(
                    controller: _numIntController,
                    decoration: InputDecoration(labelText: 'Número Interior'),
                  ),
                  TextField(
                    controller: _zipCodeController,
                    decoration: InputDecoration(labelText: 'Código Postal'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registerProperty,
                    child: Text('Registrar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _aliasController.dispose();
    _streetController.dispose();
    _numExtController.dispose();
    _numIntController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }
}
