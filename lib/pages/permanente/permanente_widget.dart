import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http_auth/http_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'dart:io';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../inicio/inicio_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

String _selectedOption = ''; // Variable para almacenar la opción seleccionada
List<String> _options = ['Opción 1', 'Opción 2'];
final ImagePicker _picker = ImagePicker();

class PermanenteWidget extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;
  const PermanenteWidget(
      {Key? key,
      required this.responseJson,
      required this.idPropiedad,
      required this.idUsuario,
      required this.AccessCode})
      : super(key: key);

  @override
  _PermanenteWidgetState createState() => _PermanenteWidgetState();
}

class _PermanenteWidgetState extends State<PermanenteWidget> {
  final ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey globalKey = GlobalKey();
  String? selectcode;
  List<String> selectcodelist = ['Servicio', 'Familiar'];
  late String _idPropiedad = '';
  late TextEditingController textFieldEnviarselect;
  late TextEditingController descriptionController;
  late TextEditingController authorizedPersonController;
  late String usuarioId = widget.idUsuario;
  late String propiedadId = widget.idPropiedad;
  late String codigo = '';
  late String Validity = DateTime.now().toIso8601String(); // Fecha actual
  late String Type = 'Permanente';
  String _nombreCasa1 = '';
  String _idPropiedad1 = '';
  String _imagenProfile1 = '';
  String _nombre1 = '';
  String _direccion = '';
  String _numint = '';
  Uint8List? qrImageData;
  bool _isLoading = false; // Variable de estado para el indicador de carga

  File? _selectedImage1;
  File? _selectedImage2;
  File? _selectedImage3;

  @override
  void initState() {
    super.initState();
    textFieldEnviarselect = TextEditingController();
    descriptionController = TextEditingController();
    authorizedPersonController = TextEditingController();
    getValoresPropiedad().then((_) {
      // setState se llama para reconstruir el widget con los nuevos valores
      setState(() {});
    });
    _setStatusBarColor(
        Color.fromRGBO(1, 29, 69, 1)); // Set initial status bar color
  }

  Future<void> getValoresPropiedad() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nombreCasa1 = prefs.getString('nombrePropiedad') ?? '';
    _idPropiedad1 = prefs.getString('idPropiedad') ?? '';
    _imagenProfile1 = prefs.getString('nombreFracc') ?? '';
    _nombre1 = prefs.getString('nombre1') ?? '';
    _direccion = prefs.getString('direccion') ?? '';
    _numint = prefs.getString('numint') ?? '';
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickImage(
      ImageSource source, int imageNumber, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final image =
            img.decodeImage(await File(pickedFile.path).readAsBytes());
        final pngBytes = img.encodePng(image!);

        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/image_${imageNumber}.png';
        final file = await File(filePath).create();
        await file.writeAsBytes(pngBytes);

        setState(() {
          if (imageNumber == 1) {
            _selectedImage1 = file;
          } else if (imageNumber == 2) {
            _selectedImage2 = file;
          } else if (imageNumber == 3) {
            _selectedImage3 = file;
          }
        });
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> generarCodigo() async {
    setState(() {
      _isLoading = true;
    });
    String? Description1 = descriptionController.text.trim();
    String? visita = textFieldEnviarselect.text.trim();
    String? AuthorizedPerson = authorizedPersonController.text.trim();
    final url = Uri.parse(
        'https://appaltea.azurewebsites.net/api/Mobile/GetAccessCode/');

    final request = http.MultipartRequest('POST', url)
      ..fields['IdUser'] = usuarioId
      ..fields['PropertyId'] = propiedadId
      ..fields['Description'] = Description1
      ..fields['Type'] = Type
      ..fields['Validity'] = Validity
      ..fields['AuthorizedPerson'] = AuthorizedPerson
      ..fields['TypePermanent'] = visita;
    print(usuarioId);
    print(propiedadId);
    print(Description1);
    print(Type);
    print(Validity);
    print(AuthorizedPerson);
    if (_selectedImage1 != null) {
      request.files.add(
          await http.MultipartFile.fromPath('file1', _selectedImage1!.path));
    }
    if (_selectedImage2 != null) {
      request.files.add(
          await http.MultipartFile.fromPath('file2', _selectedImage2!.path));
    }
    if (_selectedImage3 != null) {
      request.files.add(
          await http.MultipartFile.fromPath('file3', _selectedImage3!.path));
    }

    final response = await request.send();

    setState(() {
      _isLoading = false;
    });

    if (Description1.isNotEmpty && AuthorizedPerson.isNotEmpty) {
      if ((selectcode == 'Familiar' && _selectedImage1 != null) ||
          (selectcode == 'Servicio' &&
              _selectedImage1 != null &&
              _selectedImage2 != null)) {
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseBody);
          codigo = jsonResponse['Data'][0]['Value'];
          showModal(context);
        } else {
          print(
              'Error en la solicitud. Código de estado: ${response.statusCode}');
        }
      } else {
        showModal1(context);
      }
    } else {
      showModal1(context);
    }
  }

  FutureBuilder<Uint8List?> buildQRCodeImage(
      BuildContext context, String codigo) {
    return FutureBuilder<Uint8List?>(
      future: toQrImageData(codigo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('No se pudo generar el código QR');
        } else {
          return Container(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    child: QrImageView(
                      data: codigo,
                      version: QrVersions.auto,
                      size: 200,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
        color: Color(0xFF000000),
        emptyColor: Color(0xFFFFFFFF),
      ).toImage(300);

      // Guarda la imagen en formato PNG
      final a = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = a!.buffer.asUint8List();

      // Convierte la imagen PNG a JPG
      final imagePng = img.decodeImage(pngBytes)!;
      final jpgBytes = img.encodeJpg(imagePng,
          quality: 100); // 100 es la calidad, puedes ajustarla

      return Uint8List.fromList(jpgBytes);
    } catch (e) {
      throw e;
    }
  }

  Future<void> shareImage(Uint8List imageBytes, String imageName) async {
    try {
      // Decodificar la imagen original.
      final img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) return;

      // Calcular el tamaño del margen.
      final int margin = (originalImage.width < originalImage.height
              ? originalImage.width
              : originalImage.height) ~/
          10;

      // Crear una imagen nueva con el margen blanco.
      final img.Image newImage = img.Image(
          originalImage.width + 2 * margin, originalImage.height + 2 * margin);

      // Llenar la nueva imagen con blanco.
      img.fill(newImage, img.getColor(255, 255, 255, 255));

      // Copiar la imagen del código QR en la nueva imagen con margen.
      img.copyInto(newImage, originalImage, dstX: margin, dstY: margin);

      // Convertir la nueva imagen a Uint8List.
      final Uint8List newImageBytes =
          Uint8List.fromList(img.encodePng(newImage));

      // Obtener el directorio temporal y crear un archivo para la imagen.
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/$imageName.png');

      // Escribir los bytes de la imagen en el archivo.
      await file.writeAsBytes(newImageBytes);

      // Compartir la imagen con el margen blanco.
      await Share.shareFiles(
        [file.path],
        text:
            codigo + 'Te invito a visitarme utiliza este código para ingresar',
        subject: 'Compartir imagen',
      );
    } catch (e) {
      print('Error al compartir la imagen: $e');
    }
  }

  void _setStatusBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setStatusBarColor(
        Color.fromRGBO(1, 29, 69, 1)); // Set status bar color on build
    final responseJson = widget.responseJson;
    final String textoQR = '123456';

    return Stack(
      children: [
        Scaffold(
          body: Builder(
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset('assets/images/FONDO_GENERAL.jpg')
                            .image,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  .0, 0.0, 0.0, 0.0),
                              child: IconButton(
                                color: Color.fromRGBO(44, 255, 226, 1),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: FaIcon(FontAwesomeIcons.arrowLeft),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'ACCESO PERMANENTE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.06,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InicioWidget(
                                          responseJson: responseJson),
                                    ),
                                  );
                                },
                                icon: Image.asset('assets/images/ICONOP.png'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Nombre completo de la persona autorizada',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 25.0, 0.0, 0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: authorizedPersonController,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Nombre Completo',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                filled: true,
                                fillColor: Color(0x4D011D45),
                                prefixIcon: Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 25.0, 0.0, 0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: descriptionController,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Descripción',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                filled: true,
                                fillColor: Color(0x4D011D45),
                                prefixIcon: Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Elige tu tipo de Visita',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(239, 255, 255, 255),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  iconSize: 0,
                                  alignment: Alignment.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(197, 0, 0, 0),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                  dropdownColor:
                                      Color.fromARGB(193, 255, 255, 255),
                                  value: selectcode,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectcode = newValue;
                                      textFieldEnviarselect.text =
                                          newValue.toString();
                                    });
                                  },
                                  hint: Text(
                                    "Selecciona El Tipo",
                                    style: TextStyle(
                                        color: Color.fromARGB(197, 87, 87, 87)),
                                  ),
                                  items:
                                      selectcodelist.map((String selectcode) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: selectcode,
                                      child: Text(selectcode),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      _selectedImage1 == null
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.photo_camera,
                                                color: Color(0xFF011D45),
                                              ),
                                              onPressed: () => _pickImage(
                                                  ImageSource.camera,
                                                  1,
                                                  context),
                                            )
                                          : Image.file(
                                              _selectedImage1!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                      Text(
                                        'Foto Persona',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF011D45),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      _selectedImage2 == null
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.photo_camera,
                                                color: Color(0xFF011D45),
                                              ),
                                              onPressed: () => _pickImage(
                                                  ImageSource.camera,
                                                  2,
                                                  context),
                                            )
                                          : Image.file(
                                              _selectedImage2!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                      Text(
                                        'Foto Identificación',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF011D45),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      _selectedImage3 == null
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.photo_camera,
                                                color: Color(0xFF011D45),
                                              ),
                                              onPressed: () => _pickImage(
                                                  ImageSource.camera,
                                                  3,
                                                  context),
                                            )
                                          : Image.file(
                                              _selectedImage3!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                      Text(
                                        'Foto Vehículo',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF011D45),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                child: Text(
                                  'En caso de ser "Familiar", se requiere una imagen obligatoria. En caso de ser "Servicio", se requieren dos imágenes obligatorias.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (descriptionController.text.isNotEmpty &&
                                      authorizedPersonController
                                          .text.isNotEmpty) {
                                    if ((selectcode == 'Familiar' &&
                                            _selectedImage1 != null) ||
                                        (selectcode == 'Servicio' &&
                                            _selectedImage1 != null &&
                                            _selectedImage2 != null)) {
                                      await generarCodigo();
                                    } else {
                                      showModal1(context);
                                    }
                                  } else {
                                    showModal1(context);
                                  }
                                },
                                child: Text(
                                  "GENERAR ACCESO",
                                  style: TextStyle(
                                    fontFamily: 'Helvetica Neue, Bold',
                                    fontSize: 14,
                                  ),
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(34),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(260, 44)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF011D45)),
                                ),
                              ),
                              Text(
                                'Una vez generando el código lo podrás compartir con tu visita',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) // Mostrar el indicador de carga si _isLoading es true
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Cierra el diálogo al tocar fuera de él.
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              EdgeInsets.all(0), // Sin espaciado alrededor del diálogo
          backgroundColor:
              Colors.transparent, // Fondo transparente para el diálogo
          child: Screenshot(
            controller: screenshotController,
            child: LayoutBuilder(
              // Usar LayoutBuilder para dimensiones relativas
              builder: (context, constraints) {
                return Container(
                  // Hacer uso de las constraints para establecer dimensiones relativas
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    // Asegurar que el contenido sea desplazable
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Ajustar al contenido
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.5),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: Color.fromARGB(255, 1, 29, 69)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                            height: constraints.maxHeight *
                                0.05), // Proporcional a la altura
                        Image.asset(
                          'assets/images/logo2.png',
                          height: constraints.maxHeight *
                              0.1, // 10% de la altura disponible
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        buildQRCodeImage(context, codigo),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth *
                                  0.05), // Padding proporcional
                          child: Text(
                            _nombre1,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Text(
                          'Te invita a su casa a $_direccion $_numint',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          'Para tener acceso presenta este código QR en caseta, ó la siguiente clave:',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Text(
                          codigo,
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.blueAccent),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.1),
                          child: FFButtonWidget(
                            onPressed: () async {
                              final Uint8List? image =
                                  await screenshotController.capture();
                              if (image != null) {
                                final Directory tempDir =
                                    await getTemporaryDirectory();
                                final File file =
                                    await File('${tempDir.path}/screenshot.png')
                                        .create();
                                await file.writeAsBytes(image);
                                await Share.shareFiles([file.path],
                                    text: 'Compartir Código QR');
                              }
                            },
                            text: 'Compartir',
                            options: FFButtonOptions(
                              width:
                                  double.infinity, // Ocupar el ancho disponible
                              height: 40.0,
                              color: Color(0xFF011D45),
                              textStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 17.0),
                              borderRadius: BorderRadius.circular(34.0),
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        Text('Conoce más en',
                            style: TextStyle(
                                color: Color.fromARGB(255, 1, 29, 69),
                                fontSize: 18)),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Text('www.habitan-t.com',
                            style: TextStyle(
                                color: Color.fromARGB(255, 1, 29, 69),
                                fontSize: 18)),
                        SizedBox(height: constraints.maxHeight * 0.05),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showModal1(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromRGBO(1, 29, 69, 0),
      builder: (BuildContext context) {
        bool isFinished = false;
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: Color.fromRGBO(222, 222, 222, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(31.0), // Bordes redondeados
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(7, 176, 21, 21),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.1,
                              left: MediaQuery.of(context).size.width * 0.1,
                              top: MediaQuery.of(context).size.width * 0.0,
                              bottom: MediaQuery.of(context).size.width * 0.0,
                            ),
                            child: Text(
                              "Algun campo se encuentra vacío o no cumple los requisitos",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(1, 29, 69, 1),
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
