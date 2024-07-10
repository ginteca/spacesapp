import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:spacesclub/pages/codigoqr/crearcodigo_widget.dart';
import 'package:spacesclub/pages/codigoqr/histocodigo_widget.dart';
import 'package:spacesclub/pages/codigoqr/entrega_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Acceso',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Fondo de Scaffold
        backgroundColor: Colors.white, // Color de fondo predeterminado
        appBarTheme: AppBarTheme(
          color: Colors.white, // Color de fondo de AppBar
          iconTheme:
              IconThemeData(color: Colors.black), // Color de iconos de AppBar
        ),
        // Define otros aspectos del tema aquí si es necesario
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        // Ajustes adicionales si fuera necesario
      ),
      // Usar darkTheme cuando el sistema está en modo oscuro
      themeMode: ThemeMode
          .light, // Ignora la preferencia del sistema y siempre usa light theme
      home: AccessControlScreen(),
    );
  }
}

class AccessControlScreen extends StatefulWidget {
  @override
  State<AccessControlScreen> createState() => _AccessControlScreenState();
}

class AccessCodeDetails {
  final String code;
  final String description;
  final String type;
  final String residentName;
  // ... y cualquier otro campo relevante

  AccessCodeDetails({
    required this.code,
    required this.description,
    required this.type,
    required this.residentName,
    // ... inicializa otros campos aquí
  });

  factory AccessCodeDetails.fromJson(Map<String, dynamic> json) {
    return AccessCodeDetails(
      code: json['Code'] as String,
      description: json['Description'] as String,
      type: json['Type'] as String,
      residentName: json['UserNeighbor']['Name'] as String,
      // ... asigna otros campos aquí
    );
  }
}

class _AccessControlScreenState extends State<AccessControlScreen> {
  String accessCodeId = '';
  final TextEditingController textEditingController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AccessCodeDetails? accessCodeDetails;
  Barcode? result;
  QRViewController? controller;
  String codigo = '';
  @override
  void initState() {
    super.initState();
    // Agrega el listener al textEditingController
    textEditingController.addListener(() {
      // Actualiza la variable 'codigo' con el texto actual del TextField
      setState(() {
        codigo = textEditingController.text;
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    // Remueve el listener antes de llamar a dispose en el TextEditingController
    textEditingController.removeListener(() {});
    textEditingController.dispose();
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          codigo = result?.code ??
              ''; // Usa '??' para manejar el caso donde code pueda ser null.
          textEditingController.text =
              codigo; // Actualiza el controlador del TextField.
          controller
              .pauseCamera(); // Opcional: Pausa la cámara después de escanear el QR.
        }
      });
    });
  }

  void _validateCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString('idUsuario') ?? '';
    String propertyId = prefs.getString('idPropiedad') ?? '';
    print(codigo);
    final url = Uri.parse(
        'https://appaltea.azurewebsites.net/api/Mobile/ValidateAccessCode');
    final headers = {"Content-Type": "application/x-www-form-urlencoded"};
    final body = {
      "idUser": idUser, // Usa el valor leído
      "AccessCode": codigo,
      "PropertyId": propertyId, // Usa el valor leído
      "Scanner": "Disabled",
    };
    print(idUser);
    print(propertyId);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['Message'];
        print(data);

        if (message == 'Active') {
          print("abuebo1");
          final valueData = jsonDecode(data['Data'][0]['Value']);

          setState(() {
            accessCodeId = valueData['Id'].toString();
            accessCodeDetails = AccessCodeDetails(
              code: valueData['Code'],
              residentName: valueData['UserNeighbor']['Name'],
              type: valueData['Type'],
              description: valueData['Description'],
            );
          });
        } else if (message == 'IsNeighbor') {
          // Aquí manejas el caso 'IsNeighbor'
          final valueData = jsonDecode(data['Data'][0]['Value']);
          final neighborName = valueData['Neighbor']['Name'];
          final neighborLastName = valueData['Neighbor']['LastName'];
          final propertyNumExt = valueData['Property']['NumExt'];
          final propertyNumInt = valueData['Property']['NumInt'];
          final propertyStreet = valueData['Property']['Street'];

          // Muestra el modal con la información
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Información del Vecino'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Nombre: $neighborName $neighborLastName'),
                      Text('Calle: $propertyStreet'),
                      Text('Número Exterior: $propertyNumExt'),
                      Text('Número Interior: $propertyNumInt'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print("abuebo 3");
          String alertMessage = '';
          switch (message) {
            case 'AlreadyValidated':
              alertMessage = 'El código ya fue validado anteriormente';
              break;
            case 'Expired':
              alertMessage = 'El código ya expiró';
              break;
            case 'NotAvalibleCodes':
              alertMessage =
                  'Ya se han utilizado todos los códigos para este acceso';
              break;
            case 'Disabled':
              alertMessage = 'El código de acceso está deshabilitado';
              break;
            case 'Unavailable':
              alertMessage =
                  'En estos momentos la propiedad no está disponible para visitas';
              break;
            default:
              alertMessage = 'No has agregado ningun codigo';
              break;
          }
          _showAlert(context,
              alertMessage); // Asumiendo que tienes un método que muestra alertas.
        }
      } else {
        print("Error en la solicitud: ${response.statusCode}");
        _showAlert(context,
            'Error en la solicitud: ${response.statusCode}'); // Mostrar otro tipo de error.
      }
    } catch (e) {
      print("Excepción capturada al hacer la solicitud: $e");
      _showAlert(context,
          'Excepción capturada al hacer la solicitud: $e'); // Mostrar error de excepción.
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

  File? idImage; // Imagen para el ID
  File? platesImage; // Imagen para las placas
  bool isLoading = false; // Añadir un nuevo estado para el indicador de carga
  void _guardar() async {
    setState(() {
      isLoading = true; // Iniciar la carga
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Asegúrate de que 'idUser' sea un entero válido.
    int idUser = int.parse(prefs.getString('idUser') ?? '0');
    final uri = Uri.parse(
        'https://appaltea.azurewebsites.net/api/Mobile/SaveReportAccessControl');

    var request = http.MultipartRequest('POST', uri)
      ..fields['idUser'] = idUser.toString()
      ..fields['CodeId'] = accessCodeId
          .toString() // Asegúrate de que este valor sea correcto y exista en la DB.
      ..fields['PlatesCar'] = 'validado';

    // Agregar imágenes si están disponibles
    if (idImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'id.png', idImage!.path,
          filename: 'id.png'));
    }
    if (platesImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'plates.png', platesImage!.path,
          filename: 'plates.png'));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      setState(() {
        isLoading = false; // Detener la carga
      });
      if (response.statusCode == 200) {
        _showSuccessDialog1();
        print("Imagenes cargadas correctamente");
        print("Respuesta del servidor: ${response.body}");
      } else {
        _showErrorDialog1("Error al cargar imágenes: ${response.reasonPhrase}");
        print("Error al cargar imágenes: ${response.statusCode}");
        print("Detalle del error: ${response.body}");
      }
    } catch (e) {
      print("Excepción al cargar imágenes: $e");
      setState(() {
        isLoading = false; // Detener la carga
      });
      _showErrorDialog1(
          "Excepción al cargar imágenes: $e"); // Manejar excepción
    }
  }

  void _showErrorDialog1(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Éxito'),
          content: Text('Código validado correctamente'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pickImage(bool isIdImage) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          if (isIdImage) {
            idImage = File(pickedFile.path); // Imagen de identificación
          } else {
            platesImage = File(pickedFile.path); // Imagen de placas
          }
        });
      }
    } catch (e) {
      print('Error al capturar imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONTROL DE ACCESO'),
        backgroundColor: Color(0xFF011D45),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          _buildMainContent(),
          if (isLoading)
            Center(child: CircularProgressIndicator()), // Indicador de carga
        ],
      ),
    );
  }

  @override
  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height *
            0.005, // equivale al 0.5% de la altura de la pantalla
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Escribe el código de acceso para realizar la validación',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.001,
          ),
          TextField(
            controller: textEditingController, // Asigna el controlador aquí
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Escribe o escanea Código de acceso',
              hintStyle:
                  TextStyle(color: Colors.black), // Estilo para el hintText
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
                color: Colors.black), // Estilo para el texto ingresado
            obscureText: false,
            maxLength: 6,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.001,
          ),
          ElevatedButton(
            onPressed: () {
              _validateCode(); // Llama a tu nuevo método aquí
            },
            child: Text('Validar código'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF011D45),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (accessCodeDetails != null) ...[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height *
                      0.001, // equivale al 0.5% de la altura de la pantalla
                ), // Añade un relleno a todo el contenido
                child: Column(
                  children: [
                    if (accessCodeDetails != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height *
                              0.002, // equivale al 0.5% de la altura de la pantalla
                        ),
                        child: Text(
                          'Código Válido ${accessCodeDetails!.code}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                          textAlign: TextAlign
                              .center, // Asegura que el texto esté centrado
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ), // Ajusta la altura fija entre elementos
                      ListTile(
                        leading: Icon(Icons.home, color: Colors.black),
                        title: Text(
                          'Tipo de visita:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                        subtitle: Text(
                          accessCodeDetails!.type,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.black),
                        title: Text(
                          'Residente:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                        subtitle: Text(
                          accessCodeDetails!.residentName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.description, color: Colors.black),
                        title: Text(
                          'Descripción:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                        subtitle: Text(
                          accessCodeDetails!.description,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.history, color: Colors.black),
                        title: Text(
                          'Historial de validación:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                        subtitle: Text(
                          'No hay historial de validaciones', // Suponiendo que esto sea estático
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.025,
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Notas',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: false,
                        maxLength: 50,
                      ),
                      if (accessCodeDetails!.type == 'Personal' ||
                          accessCodeDetails!.type == 'Servicio') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Centra los widgets horizontalmente
                          children: [
                            idImage != null
                                ? Container(
                                    width:
                                        100, // Define el tamaño del contenedor
                                    height: 100,
                                    child: Image.file(idImage!),
                                  )
                                : ElevatedButton(
                                    onPressed: () => pickImage(true),
                                    child: Text('Imagen Identificación'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF011D45),
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                                width: 20), // Espacio entre los dos elementos
                            platesImage != null
                                ? Container(
                                    width:
                                        100, // Define el tamaño del contenedor
                                    height: 100,
                                    child: Image.file(platesImage!),
                                  )
                                : ElevatedButton(
                                    onPressed: () => pickImage(false),
                                    child: Text('Imagen Placas'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF011D45),
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                      ],
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ), // Ajusta la altura fija entre elementos
                      ElevatedButton(
                        onPressed: () {
                          _guardar(); // Llama a tu nuevo método aquí
                        },
                        child: Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF011D45),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            )
          ] else ...[
            // Aquí mantienes el QRView si accessCodeDetails es null
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Color(0xFF011D45),
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
          ],
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal:
                          4.0), // Agrega un poco de espacio entre los botones
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => NewVisitPage()),
                      );
                    },
                    child: Text('Acceso sin codigo'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF011D45),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CodesHistoryScreen()),
                      );
                    },
                    child: Text('Historial'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF011D45),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => DeliveryNoticesScreen()),
                      );
                    },
                    child: Text('Avisos de Entrega'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF011D45),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
