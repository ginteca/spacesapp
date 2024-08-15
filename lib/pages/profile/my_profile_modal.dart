import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import '../inicio/inicio_widget.dart';

class MyProfileModal extends StatefulWidget {
  final responseJson;
  final idUsuario;

  const MyProfileModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _MyProfileModal createState() => _MyProfileModal();
}

class _MyProfileModal extends State<MyProfileModal> {
  File? selectedImage;
  File? image;
  late String? email = '';
  late String? pass = '';

  bool isLoading = false;
  final String apiUrl1 =
      'https://appaltea.azurewebsites.net/api/Mobile/UploadImageUser';
  late String idUser;
  late String idAssociation;

  final String apiUrl2 = 'https://jaus.azurewebsites.net/api/Mobile/LoginUser/';
  late String? fotoPerfil = '';

  @override
  void initState() {
    super.initState();
    getSharedPreferencesValues();
    selectedImage = null;
    isLoading = false;
    image = null;
  }

  Future<void> saveProfileImage(String? imagePath) async {
    print("la de abajo");
    print(imagePath);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (imagePath != null) {
      await prefs.setString('fotoPerfil', imagePath);
      print("imagen guardada");
      getSharedPreferencesValues();
      Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InicioWidget(responseJson: widget.responseJson),
                ),
              );
    }
  }

  Future<void> getSharedPreferencesValues() async {
    print("esta cambiando bro");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fotoPerfil = prefs.getString('fotoPerfil');
    });
    print('foto: $fotoPerfil');
  }

  Future<void> enviarFoto() async {
    print('Entro a la api enviar');
    String idUser = widget.idUsuario.toString();
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl1));
      request.fields['UserId'] = idUser;

      if (selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', selectedImage!.path),
        );
      }
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', image!.path),
        );
      }

      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        if (jsonResponse['Type'] == 'Success' &&
            jsonResponse['Message'] == 'Updated') {
           login(selectedImage);
          
        } else {
          print('Error en la respuesta de la API: ${jsonResponse['Message']}');
          
        }
      } else {
        print('Error en la petición POST: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la petición POST se rompip: $e');
    }
  }

  Future<void> login(File? selectedImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    pass = prefs.getString('password');
    String user = email.toString();
    String password = pass.toString();

    Map<String, String> data = {'user': user, 'password': password};

    final response = await http.post(Uri.parse(apiUrl2),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('hello buey');
      
      String _usuario = jsonResponse['Data'][0]['Value'];
      print(_usuario);
      Map<String, dynamic> data0 = jsonDecode(_usuario);
      String? _imagenProfile = data0['ImageProfile'];
      
      if (jsonResponse['Type'] == 'Success') {
        saveProfileImage(_imagenProfile);
        
      } else {
        print('valio verdura');
      }
    } else {
      throw Exception('Error al realizar la petición POST chingo');
    }
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) {
      print('Permission granted');
    } else if (status.isDenied) {
      print('Permission denied');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _openImagePicker() async {
    await _requestPermission(Permission.photos);
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final originalFile = File(pickedImage.path);
      final originalImage = img.decodeImage(originalFile.readAsBytesSync());

      // Corrige la orientación
      final fixedImage = img.bakeOrientation(originalImage!);

      final fixedFile = File(pickedImage.path)
        ..writeAsBytesSync(img.encodeJpg(fixedImage));

      setState(() {
        selectedImage = fixedFile;
      });
    }
  }

  Future<void> _takePicture() async {
    await _requestPermission(Permission.camera);
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final originalFile = File(pickedImage.path);
      final originalImage = img.decodeImage(originalFile.readAsBytesSync());

      // Corrige la orientación
      final fixedImage = img.bakeOrientation(originalImage!);

      final fixedFile = File(pickedImage.path)
        ..writeAsBytesSync(img.encodeJpg(fixedImage));

      setState(() {
        image = fixedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          IconButton(
            iconSize: 50,
            onPressed: () {
              print("Se presiono nuevo imagen");
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Color.fromARGB(164, 243, 243, 243),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27.0),
                    ),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: SingleChildScrollView(
                            child: Container(
                              width: 5000,
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            tomarFoto(() {
                                              setState(() {
                                                selectedImage = null;
                                              });
                                            }),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05),
                                            seleccionarFoto(selectedImage, () {
                                              setState(() {
                                                image = null;
                                              });
                                            }),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.002),
                                      Center(
                                        child: Text("Selecciona una imagen",
                                            style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontSize: 15,
                                                color: Colors.black)),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025),
                                      ElevatedButton(
                                        onPressed: () async {
                                          enviarFoto();
                                          
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xFF011D45)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(34),
                                            ),
                                          ),
                                          fixedSize:
                                              MaterialStateProperty.all<Size>(
                                            Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.025,
                                            ),
                                          ),
                                        ),
                                        child: Text("GUARDAR"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            icon: Image.asset('assets/images/camara3.png'),
          ),
        ],
      ),
    );
  }

  Widget tomarFoto(Function()? callback) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Color.fromARGB(66, 1, 29, 69),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Stack(alignment: Alignment.center, children: [
              if (image != null)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Transform.scale(
                        scale: 2.0,
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        _requestPermission(Permission.camera).then((_) {
                          if (callback != null) {
                            callback();
                          }
                        });
                      },
                    ),
                  ],
                )
              else
                Icon(Icons.camera_alt, color: Colors.white),
            ]),
            onPressed: () {
              _requestPermission(Permission.camera).then((_) {
                _takePicture().then((_) {
                  if (callback != null) {
                    callback();
                  }
                });
              });
            },
          ),
        ],
      ),
    );
  }

  Widget seleccionarFoto(File? selectedImage, VoidCallback setStateCallback) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Color.fromARGB(66, 1, 29, 69),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                if (selectedImage != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Transform.scale(
                          scale: 1.5,
                          child: Image.file(
                            selectedImage,
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 1,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          _requestPermission(Permission.photos).then((_) {
                            setStateCallback();
                          });
                        },
                      ),
                    ],
                  )
                else
                  Icon(Icons.photo_library, color: Colors.white),
              ],
            ),
            onPressed: () {
              _requestPermission(Permission.photos).then((_) {
                _openImagePicker().then((_) {
                  setStateCallback();
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
