import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../controlpage/contolpage.dart';
import '../inicio/inicio_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      home: GenerarAccesoPage(),
    );
  }
}

class GenerarAccesoPage extends StatefulWidget {
  var responseJson;

  var idUsuario;

  var idPropiedad;

  @override
  _GenerarAccesoPageState createState() => _GenerarAccesoPageState();
}

class _GenerarAccesoPageState extends State<GenerarAccesoPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  String? selectcode;
  List<String> selectcodelist = ['Servicio', 'Permanente'];
  late String _idPropiedad = '';
  late TextEditingController textFieldEnviarselect;
  late String textoQR = '';
  late String usuarioId = '';
  late String propiedadId = '';
  late String codigo = '';
  late TextEditingController descriptionController;
  late String Validity = '';
  late String TypePermanent = '';
  late String Type = 'Personal';
  late TextEditingController _dateController;
  Uint8List? qrImageData;
  String _nombre1 = '';
  String _direccion = '';
  String _numint = '';
  String _nombreCasa1 = '';
  String _imagenProfile1 = '';
  bool _isLoading = false;
  String visitType = 'Personal';
  late int greenfeVisitsRemaining = 4;

  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late TextEditingController textController4;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _dateController.text = _formatLastDateOfMonth();
    descriptionController = TextEditingController();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    textController4 = TextEditingController();
    getValoresPropiedad();
    getGreenfeVisitsRemaining();
  }

  String _formatLastDateOfMonth() {
    DateTime now = DateTime.now();
    DateTime lastDay = DateTime(now.year, now.month + 1, 0);
    return "${lastDay.day}/${lastDay.month}/${lastDay.year}";
  }

  Future<void> getValoresPropiedad() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreCasa1 = prefs.getString('nombrePropiedad') ?? '';
      _idPropiedad = prefs.getString('idPropiedad') ?? '';
      _imagenProfile1 = prefs.getString('nombreFracc') ?? '';
      _nombre1 = prefs.getString('nombre1') ?? '';
      _direccion = prefs.getString('direccion') ?? '';
      _numint = prefs.getString('numint') ?? '';
      usuarioId = prefs.getString('idUsuario') ?? '';
      propiedadId = prefs.getString('idPropiedad') ?? '';
      greenfeVisitsRemaining = prefs.getInt('greenfeVisitsRemaining') ?? 4;
      _isLoading = false;
    });
  }

  Future<void> getGreenfeVisitsRemaining() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      greenfeVisitsRemaining = prefs.getInt('greenfeVisitsRemaining') ?? 4;
    });
  }

  Future<void> updateGreenfeVisitsRemaining(int visitsRemaining) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('greenfeVisitsRemaining', visitsRemaining);
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

      final a = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = a!.buffer.asUint8List();

      final imagePng = img.decodeImage(pngBytes)!;
      final jpgBytes = img.encodeJpg(imagePng, quality: 100);

      return Uint8List.fromList(jpgBytes);
    } catch (e) {
      throw e;
    }
  }

  Future<void> shareImage(Uint8List imageBytes, String imageName) async {
    try {
      final img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) return;

      final int margin = (originalImage.width < originalImage.height
              ? originalImage.width
              : originalImage.height) ~/
          10;

      final img.Image newImage = img.Image(
          originalImage.width + 2 * margin, originalImage.height + 2 * margin);

      img.fill(newImage, img.getColor(255, 255, 255, 255));
      img.copyInto(newImage, originalImage, dstX: margin, dstY: margin);
      final Uint8List newImageBytes =
          Uint8List.fromList(img.encodePng(newImage));

      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/$imageName.png');

      await file.writeAsBytes(newImageBytes);

      await Share.shareFiles(
        [file.path],
        text:
            codigo + ' Te invito a visitarme utiliza este código para ingresar',
        subject: 'Compartir imagen',
      );
    } catch (e) {
      print('Error al compartir la imagen: $e');
    }
  }

  Future<void> generarCodigo() async {
    if (visitType == 'Greenfe' && greenfeVisitsRemaining <= 0) {
      // Mostrar mensaje de error si no hay visitas Greenfe disponibles
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Límite alcanzado'),
            content:
                Text('Has alcanzado el límite de 4 visitas Greenfe por mes.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    String Description1 =
        "${textController1.text.trim()} ${textController2.text.trim()} ${textController3.text.trim()} ${textController4.text.trim()}";
    String fecha = _dateController.text;
    DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(fecha);
    DateTime lastDayOfMonth =
        DateTime(parsedDate.year, parsedDate.month + 1, 0);
    String fecha2 =
        "${lastDayOfMonth.month}/${lastDayOfMonth.day}/${lastDayOfMonth.year}";

    final url = 'https://appaltea.azurewebsites.net/api/Mobile/GetAccessCode/';

    final body = {
      'IdUser': usuarioId,
      'PropertyId': propiedadId,
      'Description': Description1,
      'Type': visitType,
      'Validity': fecha2,
      'TypePermanent': TypePermanent,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (Description1.isNotEmpty && fecha.isNotEmpty) {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        codigo = jsonResponse['Data'][0]['Value'];

        if (visitType == 'Greenfe') {
          setState(() {
            greenfeVisitsRemaining -= 1;
          });
          await updateGreenfeVisitsRemaining(greenfeVisitsRemaining);
        }

        showModal(context);
      } else {
        print(
            'Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } else {
      showModal1(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));

    final responseJson = ''; // Replace with actual response JSON if needed

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/FONDO_GENERAL.jpg',
                    ).image,
                  ),
                ),
                child: Column(
                  children: [
                    buttonsBackHome(),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.35),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Rellena el siguiente formulario para continuar:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            customTextField(textController1, 'Nombre'),
                            customTextField(textController2, 'Apellido'),
                            customTextField(
                                textController3, 'Marca de Vehículo'),
                            customTextField(textController4, 'Placas'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Selecciona el tipo de visita:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          customVisitTypeButton(
                              'Invitación Personal', 'Personal'),
                          customVisitTypeButton(
                              'Greenfee\n${greenfeVisitsRemaining} accesos disponibles',
                              'Greenfe'),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    ElevatedButton(
                      onPressed: () {
                        if (textController1.text.isNotEmpty &&
                            textController2.text.isNotEmpty &&
                            textController3.text.isNotEmpty &&
                            textController4.text.isNotEmpty) {
                              if(textController4.text.length >= 8 && textController4.text.length <= 12){
                                generarCodigo();
                              } else{
                                showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor:
                                    Color.fromARGB(255, 243, 243, 243),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.23,
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                            ),
                                            child: Text(
                                              'No se ha guardado, las placas deben deter entro 8 y 12 caracteres',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Ok",
                                                style: TextStyle(
                                                  fontFamily: 'Helvetica',
                                                  fontSize: 16,
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            34),
                                                  ),
                                                ),
                                                minimumSize:
                                                    MaterialStateProperty.all<
                                                        Size>(Size(120, 43)),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.purple),
                                              ),
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
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor:
                                    Color.fromARGB(255, 243, 243, 243),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.23,
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                            ),
                                            child: Text(
                                              'No se ha guardado, llena todos los campos',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Ok",
                                                style: TextStyle(
                                                  fontFamily: 'Helvetica',
                                                  fontSize: 16,
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            34),
                                                  ),
                                                ),
                                                minimumSize:
                                                    MaterialStateProperty.all<
                                                        Size>(Size(120, 43)),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.purple),
                                              ),
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
                      },
                      child: Text(
                        "GENERAR ACCESO",
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue, Bold',
                          fontSize: 14,
                        ),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34),
                          ),
                        ),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(260, 44)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.purple),
                      ),
                    ),
                    ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar la lógica para verificar el acceso a la URL
                  bool hasAccess = true; // Suponiendo que no tiene acceso

                  if (!hasAccess) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'No tienes acceso a www.habitan-t.com/API/MOBILE/ACCESOSPACES ora jajaj'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    var responseJson;
                    var idUsuario;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ControlAccesoPage(
                                responseJson: widget.responseJson,
                                idPropiedad: widget.idPropiedad,
                                idUsuario: widget.idUsuario)));
                  }
                },
                child: Text('VER HISTORIAL DE CÓDIGOS'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
              const Text(
                      'Una vez generando el código lo podrás compartir con tu visita',
                      style: TextStyle(fontSize: 12, color: Color(0xFF011D45)),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        autofocus: true,
        obscureText: false,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Poppins',
                color: Colors.grey,
                fontSize: 15.0,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(34.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(34.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(34.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
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
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget customVisitTypeButton(String text, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          visitType = value;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: visitType == value ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value == 'Personal' ? Icons.mail : Icons.golf_course,
              color: Colors.blue,
            ),
            SizedBox(height: 8.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonsBackHome() {
    final responseJson = ''; // Replace with actual response JSON if needed
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
          child: IconButton(
            color: Color.fromRGBO(44, 255, 226, 1),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'Acceso Personal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2.4,
              fontWeight: FontWeight.bold,
              fontFamily: 'Helvetica',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
          child: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InicioWidget(responseJson: responseJson),
                ),
              );
            },
            icon: Image.asset('assets/images/ICONOP.png'),
          ),
        ),
      ],
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: Screenshot(
            controller: screenshotController,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        SizedBox(height: constraints.maxHeight * 0.05),
                        Image.asset(
                          'assets/images/ef/spaces.png',
                          height: constraints.maxHeight * 0.1,
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        FutureBuilder<Uint8List?>(
                          future: toQrImageData(codigo),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return Text('No se pudo generar el código QR');
                            } else {
                              return Container(
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.30,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
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
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
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
                            color: Colors.blueAccent,
                          ),
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
                            text: 'Compartir Código QR',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 40.0,
                              color: Colors.purple,
                              textStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                              borderRadius: BorderRadius.circular(34.0),
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        Text(
                          'Conoce más en',
                          style: TextStyle(
                              color: Color.fromARGB(255, 1, 29, 69),
                              fontSize: 18),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Text(
                          'www.habitan-t.com',
                          style: TextStyle(
                              color: Color.fromARGB(255, 1, 29, 69),
                              fontSize: 18),
                        ),
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
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: Color.fromRGBO(222, 222, 222, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(31.0),
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
                              height: MediaQuery.of(context).size.height * 0.2),
                          Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.1,
                              left: MediaQuery.of(context).size.width * 0.1,
                              top: MediaQuery.of(context).size.width * 0.0,
                              bottom: MediaQuery.of(context).size.width * 0.0,
                            ),
                            child: Text(
                              "Algun campo se encuentra vacío",
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
