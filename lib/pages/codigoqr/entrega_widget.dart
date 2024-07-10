import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeliveryNoticesScreen(),
    );
  }
}

Future<List<dynamic>> fetchAdvices(int userId, int propertyId) async {
  var url = Uri.parse(
      'https://appaltea.azurewebsites.net/api/Mobile/GetAdvicesAccess');
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'idUser': userId.toString(),
      'PropertyId': propertyId.toString(),
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    var codesInfo = json.decode(jsonResponse['Data'][0]['Value']);
    return codesInfo;
  } else {
    throw Exception('Failed to load advices');
  }
}

class DeliveryNoticesScreen extends StatefulWidget {
  @override
  _DeliveryNoticesScreenState createState() => _DeliveryNoticesScreenState();
}

class _DeliveryNoticesScreenState extends State<DeliveryNoticesScreen> {
  // Define las variables como nulas o con valores por defecto iniciales
  int? _userId;
  int? _propertyId;
  int? _selectedId;
  List<dynamic> _advices = [];
  List<dynamic> _filteredAdvices = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _platesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _idImage;
  File? _plateImage;
  dynamic _selectedAdvice;

  Future<void> takePicture(ImageSource source, String type) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      setState(() {
        if (type == 'ID') {
          _idImage = File(photo.path);
        } else if (type == 'PLATE') {
          _plateImage = File(photo.path);
        }
      });
    }
  }

  Future<void> saveReportAdviceAccess() async {
    // Construye la URL de la API
    var url = Uri.parse(
        'https://appaltea.azurewebsites.net/api/Mobile/SaveReportAdviceAccess');
    var request = http.MultipartRequest('POST', url);

    // Agrega los campos de texto al request
    request.fields['idUser'] = _userId.toString();
    request.fields['IdAccess'] = _selectedId
        .toString(); // Asegúrate de que _selectedId tenga un valor asignado antes de llamar a esta función
    request.fields['PlatesCar'] = _platesController.text;

    // Adjunta las imágenes al request utilizando las claves correctas que espera tu backend
    if (_idImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file1', // Asegúrate de que estas claves coincidan con las que tu backend espera
        _idImage!.path,
      ));
    }
    if (_plateImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file2', // Asegúrate de que estas claves coincidan con las que tu backend espera
        _plateImage!.path,
      ));
    }

    // Envía la solicitud
    var response = await request.send();

    // Espera por la respuesta completa y decodifica el cuerpo de la respuesta
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print(
          'Reporte guardado: $respStr'); // Puedes eliminar esta línea después de las pruebas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reporte guardado exitosamente')),
      );
    } else {
      print(
          'Error al guardar el reporte: $respStr'); // Puedes eliminar esta línea después de las pruebas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el reporte')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserAndPropertyIds();
    _searchController.addListener(_filterAdvices);
  }

  Future<void> loadUserAndPropertyIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = int.tryParse(prefs.getString('idUsuario') ?? '0') ?? 0;
    int propertyId = int.tryParse(prefs.getString('idPropiedad') ?? '0') ?? 0;

    // Después de obtener los valores de SharedPreferences, actualiza el estado
    // y luego llama a _fetchAdvices() para buscar los avisos.
    setState(() {
      _userId = userId;
      _propertyId = propertyId;

      // Ahora que los valores no son nulos, llama a _fetchAdvices
      _fetchAdvices();
    });
  }

  void _fetchAdvices() async {
    try {
      var advices = await fetchAdvices(_userId!, _propertyId!);
      setState(() {
        _advices = advices;
        _filteredAdvices = advices;
        _selectedAdvice =
            null; // Inicialmente, _filteredAdvices muestra todos los datos
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los avisos: $e")),
      );
    }
  }

// ...resto de tu clase

  void _filterAdvices() {
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      _filteredAdvices = _advices.where((advice) {
        final nameLower = advice['UserNeighbor']['Name'].toLowerCase();
        final streetLower = advice['Property']['Street'].toLowerCase();
        return nameLower.contains(query) || streetLower.contains(query);
      }).toList();
    } else {
      _filteredAdvices = List.from(_advices);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('AVISOS DE ENTREGA'),
        backgroundColor: Color(0xFF011D45),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Asegúrate de que nada se corte si el teclado aparece
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50), // Espacio después de la AppBar
              ElevatedButton(
                onPressed: _showModalWithAdvices,
                child: Text('Buscar aviso'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF011D45),
                  minimumSize: Size(screenWidth, 50),
                ),
              ),
              SizedBox(height: 80),
              Visibility(
                visible: _selectedAdvice != null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(_selectedAdvice?['Description'] ?? ''),
                      subtitle: Text(
                        _selectedAdvice != null
                            ? "Registrado: ${_selectedAdvice['RegisterDate']}\n"
                                "Validez: ${_selectedAdvice['Validity']}\n"
                                "Nombre: ${_selectedAdvice['UserNeighbor']['Name']}\n"
                                "Calle: ${_selectedAdvice['Property']['Street']}"
                            : '',
                      ),
                    ),
                  ),
                ),
              ),
              // Espacio entre botones
              SizedBox(height: 80),
              TextField(
                controller: _platesController,
                decoration: InputDecoration(
                  labelText: 'Placas del vehículo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 80), // Espacio después del campo de texto
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Column(
                        children: [
                          Visibility(
                            visible: _idImage != null,
                            child: _idImage != null
                                ? Image.file(
                                    _idImage!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Container(), // Si _idImage es nulo, muestra un contenedor vacío.
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                takePicture(ImageSource.camera, 'ID'),
                            child: Text('Tomar foto de identificación'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF011D45),
                              minimumSize: Size(screenWidth / 2 - 12, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Column(
                        children: [
                          Visibility(
                            visible: _plateImage != null,
                            child: _plateImage != null
                                ? Image.file(
                                    _plateImage!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Container(), // Si _idImage es nulo, muestra un contenedor vacío.
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                takePicture(ImageSource.camera, 'PLATE'),
                            child: Text('Tomar foto de las placas'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF011D45),
                              minimumSize: Size(screenWidth / 2 - 12, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80), // Espacio entre botones
              ElevatedButton(
                onPressed: saveReportAdviceAccess,
                child: Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF011D45),
                  minimumSize: Size(screenWidth, 50),
                ),
              ),
              SizedBox(height: 20), // Espacio al final
            ],
          ),
        ),
      ),
    );
  }

  void _showModalWithAdvices() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar',
                  hintText: 'Ingrese nombre o calle...',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAdvices.length,
                itemBuilder: (BuildContext context, int index) {
                  var codeInfo = _filteredAdvices[index];
                  var userNeighbor = codeInfo[
                      'UserNeighbor']; // Acceso al mapa de UserNeighbor
                  var property =
                      codeInfo['Property']; // Acceso al mapa de Property
                  return ListTile(
                    title:
                        Text("${codeInfo['Code']}: ${codeInfo['Description']}"),
                    subtitle: Text("Registrado: ${codeInfo['RegisterDate']}\n"
                        "Validez: ${codeInfo['Validity']}\n"
                        "Nombre: ${userNeighbor['Name']}\n" // Muestra el nombre del vecino
                        "Calle: ${property['Street']}" // Muestra la calle de la propiedad
                        ),
                    onTap: () {
                      Navigator.pop(
                          context); // Cierra el modal después de la selección.
                      setState(() {
                        _selectedId = codeInfo['Id'];
                        _selectedAdvice =
                            codeInfo; // Guarda la información del aviso seleccionado.
                      });
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class IdentificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal[600], // Ajusta el color de la tarjeta aquí
      child: ListTile(
        leading: Icon(Icons.camera_alt, color: Colors.white),
        title: Text(
          'Foto de Identificación',
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          // Acción al tocar la tarjeta de identificación
        },
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal[600], // Ajusta el color de la tarjeta aquí
      child: ListTile(
        leading: Icon(Icons.camera_alt, color: Colors.white),
        title: Text(
          'Foto de vehículo / placa',
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          // Acción al tocar la tarjeta de vehículo
        },
      ),
    );
  }
}
