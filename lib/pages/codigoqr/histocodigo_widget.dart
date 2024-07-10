import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Asegúrate de que la estructura de tus clases coincida con tu respuesta JSON
class ApiResponse {
  String type;
  String message;
  List<Data> data;

  ApiResponse({required this.type, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        type: json['Type'],
        message: json['Message'],
        data: List<Data>.from(json['Data'].map((x) => Data.fromJson(x))),
      );
}

class Data {
  String name;
  List<Code> listCodes;

  Data({required this.name, required this.listCodes});

  factory Data.fromJson(Map<String, dynamic> json) {
    var parsedListCodes = jsonDecode(json['Value']) as List;
    List<Code> listCodes =
        parsedListCodes.map((x) => Code.fromJson(x)).toList();
    return Data(
      name: json['Name'],
      listCodes: listCodes,
    );
  }
}

class Code {
  int id;
  String code;
  String description;
  DateTime registerDate;
  DateTime validity;
  String type;

  Code({
    required this.id,
    required this.code,
    required this.description,
    required this.registerDate,
    required this.validity,
    required this.type,
  });

  factory Code.fromJson(Map<String, dynamic> json) => Code(
        id: json['Id'],
        code: json['Code'],
        description: json['Description'],
        registerDate: DateTime.parse(json['RegisterDate']),
        validity: DateTime.parse(json['Validity']),
        type: json['Type'],
      );
}

const String apiUrl =
    'https://appaltea.azurewebsites.net/api/Mobile/GetHistoryVigilantCodes';

Future<ApiResponse> fetchCodes(int idUser, int propertyId) async {
  print(idUser);
  print(propertyId);
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'idUser': idUser.toString(),
      'PropertyId': propertyId.toString(),
    },
  );

  if (response.statusCode == 200) {
    return ApiResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load codes');
  }
}

Future<bool> registerCodeExit(int idUser, String codeId) async {
  final uri =
      Uri.parse('https://appaltea.azurewebsites.net/api/Mobile/GetOutCodeUser');
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'idUser': idUser.toString(),
      'CodeId': codeId,
    },
  );

  // Aquí asumimos que una respuesta exitosa es 200 OK.
  // Puede que necesites ajustar esta lógica basada en cómo tu API maneja las respuestas.
  return response.statusCode == 200;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historial de Códigos',
      theme: ThemeData(
        primaryColor: Color(0xFF011D45), // Usar primaryColor aquí
        // Si necesitas establecer también un swatch, puedes usar esta línea:
        // primarySwatch: Colors.blue, // Esto se mantendrá como está
      ),
      home: CodesHistoryScreen(),
    );
  }
}

class CodesHistoryScreen extends StatefulWidget {
  @override
  _CodesHistoryScreenState createState() => _CodesHistoryScreenState();
}

class _CodesHistoryScreenState extends State<CodesHistoryScreen> {
  Future<ApiResponse>? futureApiResponse;
  List<Code> _allCodes = [];
  TextEditingController _searchController = TextEditingController();
  List<Code> _filteredCodes = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCodes);
    _loadCodes(); // Esto inicializará futureApiResponse adecuadamente.
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString('idUsuario') ?? '';
    String propertyId = prefs.getString('idPropiedad') ?? '';

    int idUserInt = int.tryParse(idUser) ?? 0;
    int propertyIdInt = int.tryParse(propertyId) ?? 0;

    var apiResponse = await fetchCodes(idUserInt, propertyIdInt);
    setState(() {
      futureApiResponse = Future.value(apiResponse);
      _allCodes = apiResponse.data.first.listCodes;
      _filteredCodes = List<Code>.from(_allCodes);
    });
  }

  void _filterCodes() {
    // Puedes expandir esta lógica para buscar en múltiples campos si es necesario.
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCodes = List.from(_allCodes);
      } else {
        _filteredCodes = _allCodes.where((code) {
          // Aquí puedes agregar más campos por los cuales deseas buscar.
          return code.code.toLowerCase().contains(query) ||
              code.description.toLowerCase().contains(query) ||
              code.type.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? Text('Historial de Códigos')
            : TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.white),
                  hintText: "Buscar...",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
        actions: !_isSearching
            ? [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                )
              ]
            : [
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _isSearching = false;
                      _filterCodes();
                    });
                  },
                )
              ],
        backgroundColor: Color(0xFF011D45),
      ),
      body: FutureBuilder<ApiResponse>(
        future: futureApiResponse,
        builder: (context, snapshot) {
          if (futureApiResponse == null ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Asegúrate de actualizar _filteredCodes solo cuando no estés buscando,
            // para no sobrescribir los resultados filtrados.
            if (!_isSearching) {
              _filteredCodes = snapshot.data!.data.first.listCodes;
            }
            return ListView.builder(
              itemCount: _filteredCodes.length,
              itemBuilder: (context, index) {
                Code code = _filteredCodes[index];
                return CodeListItem(
                  code: code,
                  onExitRegistered: _loadCodes,
                );
              },
            );
          } else {
            return Center(child: Text('No se encontraron datos.'));
          }
        },
      ),
    );
  }
}

class CodeListItem extends StatelessWidget {
  final Code code;
  final VoidCallback onExitRegistered; // Callback para recargar los códigos
  CodeListItem({Key? key, required this.code, required this.onExitRegistered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  // Asumiendo que tienes un campo o una lógica para determinar el color
                  backgroundColor: _getColorForType(code.type),
                  child: Text(
                      code.code.substring(0, 1)), // Primer letra del código
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          code.code,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Descripcion: ${code.description}'),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Obtén las instancias de SharedPreferences
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    // Lee el valor de idUser, con un valor por defecto en caso de no existir
                    String idUser = prefs.getString('idUsuario') ?? '';

                    // Asegúrate de que idUser se pueda convertir en entero si es necesario
                    int idUserInt = int.tryParse(idUser) ??
                        0; // Usa 0 o cualquier otro valor por defecto que consideres apropiado

                    bool success =
                        await registerCodeExit(idUserInt, code.id.toString());
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Salida registrada con éxito.')),
                      );
                      onExitRegistered(); // Llamar al callback cuando la salida es exitosa
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al registrar salida.')),
                      );
                    }
                    // Acción al presionar 'Registrar salida'
                  },
                  child: Text('Registrar salida'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Color del botón
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Creado el: ${_formatDateTime(code.registerDate)}'),
                Text('Válido hasta: ${_formatDateTime(code.validity)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'permanente':
        return Color(0xFF011D45);
      case 'entrega':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
