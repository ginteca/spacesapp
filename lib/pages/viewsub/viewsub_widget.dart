import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacesclub/pages/addsubtoken/addsubtoken_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart'; // Cambia a share_plus para compartir

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

class SubToken {
  final int? id;
  final String code;
  final String description;
  final String status;
  final String dateRegister;
  final String dateAccess;
  final List<String> areas;
  final String type;
  final String personAccess;

  SubToken({
    required this.id,
    required this.code,
    required this.description,
    required this.status,
    required this.dateRegister,
    required this.dateAccess,
    required this.areas,
    required this.type,
    required this.personAccess,
  });

  factory SubToken.fromJson(Map<String, dynamic> json) {
    return SubToken(
      id: json['Id'] ?? 0, // Proporcionar un valor por defecto si es nulo
      code: json['Code'] ?? '',
      description: json['Description'] ?? '',
      status: json['Status'] ?? '',
      dateRegister: json['DateRegister'] ?? '',
      dateAccess: json['DateAccess'] ?? '',
      areas: List<String>.from(json['Areas'] ?? []),
      type: json['Type'] ?? '',
      personAccess: json['PersonAccess'] ?? '',
    );
  }
}

Future<void> deletesubtoken(
    String token, String idUsuario, String id, String idPropiedad) async {
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/DeleteSubToken/'; // Asegúrate de que esta es la URL correcta para eliminar un token.

  Map<String, String> data = {
    'idUser': idUsuario,
    'PropertyId': idPropiedad,
    'IdToken':
        id, // Asegúrate de que la API espera este parámetro para identificar el token a eliminar.
  };
  print(id);
  final response = await http.post(Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: data);

  if (response.statusCode == 200) {
    print('Subtoken eliminado con éxito');
  } else {
    throw Exception('Error al eliminar el SubToken: ${response.statusCode}');
  }
}

Future<List<SubToken>> listsubtokens(
    String token, String idUsuario, String idPropiedad) async {
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/GetSubTokens/';
  Map<String, String> data = {
    'idUser': idUsuario,
    'PropertyId': idPropiedad,
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: data,
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    print('decoded: $decoded'); // Imprime toda la respuesta decodificada

    // Verifica que 'decoded' contiene la clave 'Data' y que no es nulo
    if (decoded['Data'] != null && decoded['Data'].isNotEmpty) {
      print(
          'decoded[\'Data\']: ${decoded['Data']}'); // Imprime el contenido de 'Data'

      final String nestedJson = decoded['Data'][0]['Value'];
      if (nestedJson != null) {
        final List<dynamic> subTokensList = jsonDecode(nestedJson);
        final List<SubToken> subTokens = subTokensList
            .map((dynamic item) => SubToken.fromJson(item))
            .toList();
        return subTokens;
      } else {
        throw Exception(
            'La clave \'Value\' es nula o no está presente en los datos de la API.');
      }
    } else {
      throw Exception('La clave \'Data\' es nula o no contiene elementos.');
    }
  } else {
    throw Exception(
        'Error al obtener los Subtokens: Estado ${response.statusCode}');
  }
}

class SubTokensScreen extends StatefulWidget {
  @override
  _SubTokensScreenState createState() => _SubTokensScreenState();
}

class _SubTokensScreenState extends State<SubTokensScreen> {
  List<SubToken> _subTokens = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubTokens();
    _loadIdUsuario();
  }

  String _IdUsuario = '';
  String _idPropiedad = '';
  Future<void> _loadIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final String idUsuario = prefs.getString('idUsuario') ?? '';
    final String idPropiedad = prefs.getString('idPropiedad') ?? '';

    if (idUsuario.isNotEmpty && idPropiedad.isNotEmpty) {
      setState(() {
        _IdUsuario = idUsuario;
        _idPropiedad = idPropiedad;
      });
      await _loadSubTokens(); // Llama a cargar los subtokens después de establecer los valores
    } else {
      // Manejo de error si alguno de los valores no está disponible
    }
  }

  Future<void> _loadSubTokens() async {
    try {
      // Asegúrate de que _IdUsuario y _idPropiedad se han inicializado
      if (_IdUsuario.isNotEmpty && _idPropiedad.isNotEmpty) {
        var tokens = await listsubtokens('tu_token', _IdUsuario, _idPropiedad);
        setState(() {
          _subTokens = tokens;
          _isLoading = false;
        });
      } else {
        // Si _IdUsuario o _idPropiedad están vacíos, maneja el error
        throw Exception('IdUsuario o IdPropiedad no están disponibles');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al cargar los SubTokens: $e'),
      ));
    }
  }

  Future<void> _deleteSubToken(String idToken, int index) async {
    try {
      // Asegúrate de que _IdUsuario y _idPropiedad se han inicializado
      if (_IdUsuario.isNotEmpty && _idPropiedad.isNotEmpty) {
        await deletesubtoken('tu_token', _IdUsuario, idToken, _idPropiedad);
        setState(() {
          _subTokens.removeAt(index);
        });
      } else {
        // Si _IdUsuario o _idPropiedad están vacíos, maneja el error
        throw Exception('IdUsuario o IdPropiedad no están disponibles');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al eliminar el SubToken: $e'),
      ));
    }
  }

  Future<void> _shareSubToken(String code) async {
    final message =
        "Hola, te otorgo este código para agregarte como subtoken a mi propiedad: $code. Para más información visita www.habitan-t.com";
    await Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene el tamaño de la pantalla
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF011D45),
          title: Text('SubTokens'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF011D45),
        title: Text('Administrar Subtokens'),
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/FONDO_GENERAL.jpg"), // Asegúrate de tener esta imagen en tu carpeta assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                  height: screenHeight * 0.15), // Reducido el espacio superior
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Fondo transparente
                    borderRadius:
                        BorderRadius.circular(10), // Radio del borde redondeado
                  ),
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: ListView.builder(
                    itemCount: _subTokens.length,
                    itemBuilder: (context, index) {
                      SubToken subToken = _subTokens[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Fondo gris
                          borderRadius:
                              BorderRadius.circular(10.0), // Bordes redondeados
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subToken.description,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text('Código: ${subToken.code}',
                                style: TextStyle(color: Colors.black)),
                            Text(
                              'Estado: ${subToken.status}',
                              style: TextStyle(
                                color: subToken.status == 'Standby'
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                            Text('Fecha de Registro: ${subToken.dateRegister}',
                                style: TextStyle(color: Colors.black)),
                            Text('Tipo: ${subToken.type}',
                                style: TextStyle(color: Colors.black)),
                            Text('Persona con Acceso: ${subToken.personAccess}',
                                style: TextStyle(color: Colors.black)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.black,
                                  ),
                                  onPressed: () =>
                                      _shareSubToken(subToken.code),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.black),
                                  onPressed: () => _deleteSubToken(
                                      subToken.id.toString(), index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                child: FFButtonWidget(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddsubtokenWidget()),
                    );
                  },
                  text: 'Nuevo subtoken',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: screenHeight * 0.05,
                    padding: EdgeInsets.zero,
                    iconPadding: EdgeInsets.zero,
                    color: Color(0xFF011D45),
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                            ),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                ),
              ),
              SizedBox(
                  height:
                      screenHeight * 0.05), // Espacio extra debajo del botón
            ],
          ),
        ],
      ),
    );
  }
}
