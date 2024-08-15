import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../inicio/success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _employeeNo;
  bool _showNextButton = false;
  String _statusText = 'Analizando...';

  @override
  void initState() {
    super.initState();
    _loadEmployeeNo();
  }

  Future<void> _loadEmployeeNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _employeeNo = prefs.getString('idUsuario');
    });
  }

  Future<void> _takePicture() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (pickedFile != null) {
        // Reduce la calidad de la imagen
        final tempDir = await getTemporaryDirectory();
        final path = tempDir.path;
        var result = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          '$path/${DateTime.now().millisecondsSinceEpoch}.jpg',
          quality: 10,
        );

        setState(() {
          _image = result != null ? File(result.path) : null;
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || _employeeNo == null) {
      print('No image or employee number to upload.');
      _showDialog('Error', 'No image or employee number to upload.');
      return;
    }

    _showLoadingModal();

    var uri = Uri.parse('https://habitan-t.com/test.php'); // Cambia a tu URL
    var request = http.MultipartRequest('POST', uri)
      ..fields['employeeNo'] = _employeeNo!
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();

    // Mostrar botón "Siguiente" después de 5 segundos
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _showNextButton = true;
        _statusText = 'Análisis completo';
      });
    });
  }

  Future<void> checkLogin() async {
    // Aquí va tu lógica de verificación de login
    print("Check login executed");
    // Navegar a la pantalla de éxito después de la verificación
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen()),
    );
  }

  void _showLoadingModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/fondop.png"), // Reemplaza con tu imagen de fondo
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/center_image.png', // Reemplaza con tu imagen
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _statusText,
                      style: TextStyle(
                        color: Colors.purple, // Mismo color que el botón
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_showNextButton)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cerrar el modal
                          checkLogin(); // Ejecutar la verificación de login
                        },
                        child: Text('Siguiente'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/fondop.png"), // Reemplaza con tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: _image == null
                      ? Text(
                          'No image selected.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      : Image.file(_image!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Recuerda que tu foto debe salir desde tu torso hasta tu cabeza.',
                  style: TextStyle(
                    color: Colors.purple, // Mismo color que el botón
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _takePicture,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Tomar Foto'),
                    ),
                    ElevatedButton(
                      onPressed: _uploadImage,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Siguiente'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
