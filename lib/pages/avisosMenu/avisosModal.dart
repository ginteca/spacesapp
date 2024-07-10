import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class avisosModal extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  //final idAssociation;
  const avisosModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    //required this.idAssociation
  });
  @override
  _avisosModal createState() => _avisosModal();
}

class _avisosModal extends State<avisosModal> {
  String? selectedMonth;
  int? selectedDay;
  late int selectedYear = 1922;
  late List<int> yearsList;
  File? selectedImage;
  File? image;
  late bool isLoading;
  //Datos para guardar los avisos
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/SaveAdvice/';
  late String idUser;
  late String idAssociation;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  Future<String> enviarAvisos() async {
    print('entro a realizar el aviso');

    // Obtener datos del formulario
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();

    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();

    String? description = _descriptionController.text.trim();
    String? title = _titleController.text.trim();
    String? day = _dayController.text.trim();
    String? month = _monthController.text.trim();
    String? year = _yearController.text.trim();
    String date = "$month/$day/$year";
    print("$day/$month/$year");

    Map<String, String> data = {
      'idUser': idUser,
      'AssociationId': idAssociation,
      'Title': '$title',
      'Description': '$description',
      'DateAdvice': '$date',
    };

    // Agregar la imagen si está disponible
    if (selectedImage != null) {
      data['file'] = selectedImage!.path;
    }

    if (image != null) {
      data['file'] = image!.path;
    }

    // Crear la solicitud HTTP multipart con el formulario y la imagen adjunta
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Agregar los campos del formulario y la imagen al cuerpo de la solicitud
    request.fields.addAll(data);
    if (selectedImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', selectedImage!.path));
    }

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('file', image!.path));
    }

    // Enviar la solicitud
    var response = await request.send();

    // Leer la respuesta de la solicitud
    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseString);
      print('hello buey');
      print(jsonResponse);
      print("$selectedImage");
      if (jsonResponse['Message'] == 'Created') {
        print("si quedo");

        //Navigator.push(
        //context,
        //MaterialPageRoute(
        //    builder: (context) => InicioWidget(responseJson: jsonResponse)),
        // );
      } else {
        print('valio verdura');
      }
      return jsonResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  void _resetSelected() {
    setState(() {
      selectedImage = null;
    });
  }

  void _resetTakePhoto() {
    setState(() {
      image = null;
    });
  }

  //Funcion para seleccionar una imagen de tu galeria
  Future<void> _openImagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  //Funcion para tomar una foto con tu camara
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
    return null;
  }

  List<int> daysList = [];

  List<String> monthsList = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  void updateDaysList(String selectedMonth) {
    int daysInMonth =
        DateTime(DateTime.now().year, monthsList.indexOf(selectedMonth) + 2, 0)
            .day;
    setState(() {
      daysList = List<int>.generate(daysInMonth, (index) => index + 1);
    });
  }

  @override
  void initState() {
    super.initState();
    selectedImage = null;
    isLoading = false;
    image = null;
    selectedYear = DateTime.now().year;
    yearsList = List.generate(100, (index) => DateTime.now().year - index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Column());
  }

  Widget txtNuevoAviso() {
    return Container(
      child: Column(children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(
                    color:
                        Colors.white, // Establecer el color del texto en blanco
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(
                        68, 0, 12, 52), // Cambia el color de fondo aquí
                    hintText: 'Titulo del aviso...',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          34.0), // Ajusta el radio del borde aquí
                    ),
                    // Ajusta el espaciado del texto dentro del TextField
                  ),
                ),
              ],
            )),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _descriptionController,
                  style: TextStyle(
                    color:
                        Colors.white, // Establecer el color del texto en blanco
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(
                        68, 0, 12, 52), // Cambia el color de fondo aquí
                    hintText: 'Descripción…',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          34.0), // Ajusta el radio del borde aquí
                    ),
                    // Ajusta el espaciado del texto dentro del TextField
                  ),
                ),
              ],
            )),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
      ]),
    );
  }

  Widget tomarFoto(Function()? callback) {
    //var isLoading = false;
    Future<void> _requestCameraPermission() async {
      final PermissionStatus status = await Permission.camera.request();
      if (status.isGranted) {
        _takePicture().then((_) {
          if (callback != null) {
            callback();
          }
        });
        isLoading = true;
      } else {
        // El usuario denegó el permiso de la cámara, puedes mostrar un mensaje o realizar alguna otra acción.
      }
    }

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
                        scale: 1.5, // Factor de escala para agrandar la imagen

                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        _requestCameraPermission();
                      },
                    )
                  ],
                )
              else
                Icon(Icons.camera_alt, color: Colors.white)
            ]),
            onPressed: () {
              _requestCameraPermission();
            },
          )
        ],
      ),
    );
  }

  Widget seleccionarFoto(File? selectedImage, VoidCallback setStateCallback) {
    Future<void> _requestGalleryPermission() async {
      PermissionStatus status = await Permission.accessMediaLocation.request();
      if (status.isGranted) {
        // Gallery permission granted, you can now access the gallery.
        _openImagePicker().then((_) {
          setStateCallback();
        });
      } else {
        // Handle permission denied here.
      }
    }

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
                      )),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          _requestGalleryPermission();
                        },
                      ),
                    ],
                  )
                else
                  Icon(Icons.photo_library, color: Colors.white),
              ],
            ),
            onPressed: () {
              _requestGalleryPermission();
            },
          ),
        ],
      ),
    );
  }
}
