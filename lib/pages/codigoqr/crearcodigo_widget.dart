import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// Asegúrate de tener todas las importaciones necesarias aquí

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Acceso',
      theme: ThemeData(
        primaryColor: Color(0xFF011D45),
      ),
      home: NewVisitPage(),
    );
  }
}

class NewVisitPage extends StatefulWidget {
  @override
  _NewVisitPageState createState() => _NewVisitPageState();
}

class UserNeighbor {
  final int id;
  final String name;
  final String lastName;
  final String street;
  final String statusVisit;
  final String financialStatus;
  final int idp;

  UserNeighbor({
    required this.id,
    required this.name,
    required this.lastName,
    required this.street,
    required this.statusVisit,
    required this.financialStatus,
    required this.idp,
  });

  factory UserNeighbor.fromJson(Map<String, dynamic> json) {
    // 'json' debería ser el objeto completo que incluye tanto 'UserNeighbor' como 'Property'
    Map<String, dynamic> userNeighborJson =
        json['UserNeighbor'] as Map<String, dynamic>? ?? {};
    Map<String, dynamic> propertyJson =
        json['Property'] as Map<String, dynamic>? ?? {};

    return UserNeighbor(
      id: userNeighborJson['Id'] as int? ?? 0,
      name: userNeighborJson['Name'] as String? ?? 'Unknown',
      lastName: userNeighborJson['LastName'] as String? ?? 'Unknown',
      street: propertyJson['Street'] as String? ?? 'Unknown',
      statusVisit: propertyJson['StatusVisit'] as String? ?? 'Unknown',
      financialStatus: propertyJson['FinancialStatus'] as String? ?? 'Unknown',
      idp: propertyJson['Id'] as int? ?? 0,
    );
  }
}

void _showAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alerta'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo de alerta.
            },
          ),
        ],
      );
    },
  );
}

class _NewVisitPageState extends State<NewVisitPage> {
  // Aquí agregarías el resto de tu lógica de estado
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _platesController = TextEditingController();
  File? _idPhoto;
  File? _vehiclePhoto;
  String? selectedVisitType;
  bool isIdPhotoTaken = false;
  bool isVehiclePhotoTaken = false;
  int? selectedUserId;
  int? selectedPropertyId;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _residentSearchController = TextEditingController();
  List<UserNeighbor> _filteredResidents = [];
  // ...

  Future<void> _selectImage(bool isIdPhoto) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print(
          "Image path: ${image.path}"); // Agregar esta línea para comprobar la ruta de la imagen seleccionada.
      setState(() {
        if (isIdPhoto) {
          _idPhoto = File(image.path);
          isIdPhotoTaken = true;
        } else {
          _vehiclePhoto = File(image.path);
          isVehiclePhotoTaken = true;
        }
      });
    }
  }

  Future<void> saveNewVisit(BuildContext context) async {
    if (selectedUserId == null ||
        selectedPropertyId == null ||
        selectedVisitType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor selecciona un usuario, propiedad y tipo de visita')),
      );
      return;
    }

    if (_idPhoto == null || _vehiclePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor toma las dos fotos requeridas')),
      );
      return;
    }

    // Ahora crea la solicitud de envío con toda la información
    final url = Uri.parse(
        'https://appaltea.azurewebsites.net/api/Mobile/SaveNewVisit'); // Coloca aquí la URL real de tu API
    var request = http.MultipartRequest('POST', url)
      ..fields['idUser'] = selectedUserId.toString()
      ..fields['idProperty'] = selectedPropertyId.toString()
      ..fields['PlatesCar'] = _platesController.text
      ..fields['Type'] = selectedVisitType!
      ..fields['Description'] = _descriptionController.text;

    // Agrega las imágenes como archivos multipart
    request.files.add(await http.MultipartFile.fromPath(
      'id.png',
      _idPhoto!.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'plates.png',
      _vehiclePhoto!.path,
    ));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Si la respuesta fue exitosa, obtén el cuerpo de la respuesta
        var responseBody = await http.Response.fromStream(response);
        var decodedResponse = json.decode(responseBody.body);
        if (decodedResponse['Type'] == 'Success') {
          String alertMessage = '';
          print('Visita guardada con éxito');

          alertMessage = 'El código se a creado con exito';
          _showAlert(context, alertMessage);
          // Aquí puedes redirigir al usuario o mostrar un mensaje de éxito
        } else {
          print('Advertencia: ${decodedResponse['Message']}');
          // Aquí puedes mostrar el mensaje de advertencia
        }
      } else {
        print('Error: La solicitud falló con estado ${response.statusCode}.');
        // Manejar errores de respuesta diferentes de 200
      }
    } catch (e) {
      print('Excepción al hacer la solicitud: $e');
      // Manejar cualquier excepción de la solicitud
    }
  }

  Future<List<UserNeighbor>> getUsersVigilantFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String idUsuario = prefs.getString('idUsuario') ?? '';
    final int idAssociation = prefs.getInt('IdAssociation') ?? 0;
    List<UserNeighbor> userList = [];

    if (idUsuario.isNotEmpty && idAssociation != 0) {
      final url = Uri.parse(
          'https://appaltea.azurewebsites.net/api/Mobile/GetUsersVigilant');
      final headers = {"Content-Type": "application/x-www-form-urlencoded"};
      final body = {
        "idUser": idUsuario,
        "AssociationId": idAssociation.toString(),
      };

      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          if (data['Type'] == 'Success' && data['Data'] is List) {
            final List<dynamic> usersData = data['Data'];
            for (var userData in usersData) {
              final String userJsonString = userData['Value'];
              final List<dynamic> userJsonList = json.decode(userJsonString);

              for (var userJson in userJsonList) {
                if (userJson is Map<String, dynamic>) {
                  userList.add(UserNeighbor.fromJson(userJson));
                }
              }
            }
          }
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (e) {
        print('Exception caught while making the request: $e');
      }
    } else {
      print('User or association data is not available in SharedPreferences.');
    }

    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('NUEVA VISITA'),
        backgroundColor: Color(0xFF011D45),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 35.0),
              ElevatedButton(
                child: Text('Seleccionar residente'),
                onPressed: () async {
                  List<UserNeighbor> users = await getUsersVigilantFromPrefs();
                  await _showUserNeighborSelectionDialog(context, users);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF011D45),
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 36.0),
              _buildVisitTypeSection(context),
              SizedBox(height: 36.0),
              _buildDescriptionSection(),
              SizedBox(height: 36.0),
              _buildPhotoSection(context),
              SizedBox(height: 36.0),
              _buildLicensePlateSection(),
              SizedBox(height: 36.0),
              ElevatedButton(
                child: Text('Guardar'),
                onPressed: () => saveNewVisit(context),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF011D45),
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitTypeSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildVisitTypeButton(
            context, 'Visita Personal', Icons.home, 'personal'),
        _buildVisitTypeButton(
            context, 'Visita de Servicio', Icons.build, 'servicio'),
        _buildVisitTypeButton(
            context, 'Visita de Entrega', Icons.local_shipping, 'entrega'),
      ],
    );
  }

  Future<void> _showUserNeighborSelectionDialog(
      BuildContext context, List<UserNeighbor> users) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona un residente'),
          content: SingleChildScrollView(
            child: ListBody(
              children: users.map((user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                    setState(() {
                      selectedUserId = user.id;
                      selectedPropertyId = user.idp;
                      print(selectedUserId);
                      print(selectedUserId);
                      // Aquí guardas el ID seleccionado
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.name} ${user.lastName}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          user.street,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.statusVisit,
                              style: TextStyle(
                                color:
                                    user.statusVisit.contains('No Disponible')
                                        ? Colors.red
                                        : Colors.green,
                              ),
                            ),
                            Text(
                              _financialStatusText(user.financialStatus),
                              style: TextStyle(
                                color:
                                    _financialStatusColor(user.financialStatus),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  String _financialStatusText(String status) {
    switch (status) {
      case 'Debtor':
        return 'Moroso';
      case 'Pay':
        return 'Cumplido';
      default:
        return status;
    }
  }

  Color _financialStatusColor(String status) {
    switch (status) {
      case 'Debtor':
        return Colors.red;
      case 'Pay':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildVisitTypeButton(
    BuildContext context,
    String label,
    IconData icon,
    String visitType,
  ) {
    bool isSelected = selectedVisitType == visitType;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: isSelected
                ? Colors.green
                : Color(0xFF011D45), // Cambia el color aquí
            onPrimary: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: isSelected ? Colors.black : Colors.white),
              Text(label,
                  style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white)),
            ],
          ),
          onPressed: () {
            setState(() {
              selectedVisitType =
                  visitType; // Actualiza el tipo de visita seleccionado
            });
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    // Método que construye la sección de descripción de la visita
    // ...

    return TextField(
      decoration: InputDecoration(
        labelText: 'Describe tu visita',
        hintText: 'Gas, jardinería, contratista, mudanza, etc.',
      ),
    );
  }

  Widget _buildLicensePlateSection() {
    // Método que construye la sección de descripción de la visita
    // ...

    return TextField(
      decoration: InputDecoration(
        labelText: 'Escribe tu placa',
        hintText: 'Placa',
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context) {
    // Método que construye la sección para fotos
    // ...

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildPhotoButton(context, 'Foto de Identificación', isIdPhotoTaken),
        _buildPhotoButton(
            context, 'Foto de vehículo / placa', isVehiclePhotoTaken),
      ],
    );
  }

  Widget _buildPhotoButton(
      BuildContext context, String label, bool isPhotoTaken) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: isPhotoTaken
                ? Colors.green
                : Color(0xFF011D45), // Cambia el color si la foto fue tomada
            onPrimary: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.camera_alt,
                  color: isPhotoTaken ? Colors.black : Colors.white),
              Text(label,
                  style: TextStyle(
                      color: isPhotoTaken ? Colors.black : Colors.white)),
            ],
          ),
          onPressed: () {
            _selectImage(label == 'Foto de Identificación');
          },
        ),
      ),
    );
  }
}
