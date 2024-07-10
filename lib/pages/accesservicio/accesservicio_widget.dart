import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../inicio/inicio_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;

String _selectedOption = ''; // Variable para almacenar la opción seleccionada
List<String> _options = ['Opción 1', 'Opción 2'];

class AccesservicioWidget extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;
  const AccesservicioWidget(
      {Key? key,
      required this.responseJson,
      required this.idPropiedad,
      required this.idUsuario,
      required this.AccessCode})
      : super(key: key);

  @override
  _AccesservicioWidgetState createState() => _AccesservicioWidgetState();
}

class _AccesservicioWidgetState extends State<AccesservicioWidget> {
  String? selectcode;
  final ScreenshotController screenshotController = ScreenshotController();

  List<String> selectcodelist = ['Servicio', 'Permanente'];
  late String _idPropiedad = '';
  late TextEditingController textFieldEnviarselect;
  late String textoQR = codigo;
  late String usuarioId = widget.idUsuario;
  late String propiedadId = widget.idPropiedad;
  late String codigo = '';
  late TextEditingController descriptionController;
  late String Validity = '';
  late String TypePermanent = '';
  late String Type = 'Servicio';
  late TextEditingController _dateController;
  late String Description1 = descriptionController.text;
  String _nombreCasa1 = '';
  String _idPropiedad1 = '';
  String _imagenProfile1 = '';
  Uint8List? qrImageData;
  String _nombre1 = '';
  String _direccion = '';
  String _numint = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _dateController.text = _formatCurrentDate();
    descriptionController = TextEditingController();
  }

  String _formatCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
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

  Future<void> generarCodigo() async {
    String? Description1 = descriptionController.text.trim();
    late String fecha = _dateController.text;
    DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(fecha);
    DateTime nextDay = parsedDate.add(Duration(days: 1));
    String fecha2 = "${nextDay.month}/${nextDay.day}/${nextDay.year}";
    print(usuarioId);
    print(propiedadId);
    print('entrando a generar codigo');
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetAccessCode/'; // Reemplaza con la URL de tu API

    // Datos que deseas enviar en el cuerpo de la solicitud
    final body = {
      'IdUser': usuarioId,
      'PropertyId': propiedadId,
      'Description': Description1,
      'Type': Type,
      'Validity': fecha2,
      'TypePermanent': TypePermanent,
    };

    print(fecha);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (Description1.isNotEmpty & fecha.isNotEmpty) {
      if (response.statusCode == 200) {
        // La solicitud fue exitosa, analiza la respuesta JSON
        print('Entro a la Api');
        print(Validity);

        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        //codigoacceso
        codigo = jsonResponse['Data'][0]['Value'];
        //codigo1 = parsedJson['Value'].toString();
        print(codigo);
        // setText();
        showModal(context);
      } else {
        // La solicitud falló
        print('No entro a la Api');
        print(
            'Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } else {
      showModal1(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el color de la barra de notificaciones en blanco
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));

    final responseJson = widget.responseJson;
    //print(responseJson);
    final String textoQR = '123456';
    return Container(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Builder(
          builder: (context) => SafeArea(
            child: Container(
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
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.48,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Describe tu Servicio',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Helvetica'),
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
                                  hintText:
                                      'Gas, jardinería, contratista, mudanza, etc…',
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
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.09,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              'Vigencia de acceso',
                              style: TextStyle(
                                color: Color(0xFF011D45),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.004,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              'La hora de vigencia será a las 23:59 del día seleccionado',
                              style: TextStyle(
                                color: Color(0xFF011D45),
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centra los elementos verticalmente
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.35, // Ancho del campo de entrada de fecha
                                  child: TextFormField(
                                    controller: _dateController,
                                    readOnly: true,
                                    onTap: () async {
                                      final selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate:
                                            DateTime(DateTime.now().year + 10),
                                      );

                                      if (selectedDate != null) {
                                        final nextDay =
                                            selectedDate.add(Duration(days: 1));
                                        _dateController.text =
                                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Fecha',
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
                                        borderRadius:
                                            BorderRadius.circular(34.0),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(34.0),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(34.0),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(34.0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0x4D011D45),
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
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
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (Description1.isNotEmpty) {
                                generarCodigo();
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor:
                                            Color.fromARGB(255, 243, 243, 243),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              50.0), // Bordes redondeados
                                        ),
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.23,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            child: Column(children: [
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1)),
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
                                                  child: Text("Ok",
                                                      style: TextStyle(
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 16,
                                                      )),
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(34),
                                                        ),
                                                      ),
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all<Size>(Size(
                                                                  120, 43)),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Color(
                                                                  0xFF011D45))),
                                                ),
                                              )
                                            ]),
                                          );
                                        }),
                                      );
                                    });
                              }
                            },
                            child: Text("GENERAR ACCESO",
                                style: TextStyle(
                                  fontFamily: 'Helvetica Neue, Bold',
                                  fontSize: 14,
                                )),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        34), // Ajusta el radio de borde para redondear el botón
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(260, 44)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF011D45))),
                          ),
                          Text(
                            'Una vez generando el código lo podrás compartir con tu visita',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF011D45)),
                          ),
                        ],
                      ),
                    ),

                    //Aqui pon tu codigo xD
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonsBackHome() {
    final responseJson = widget.responseJson;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
          child: IconButton(
              //rgba(44, 255, 226, 1)
              color: Color.fromRGBO(44, 255, 226, 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'Acceso Servicio',
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
                  builder: (context) => InicioWidget(
                    responseJson: widget.responseJson,
                  ),
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
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(7, 176, 21, 21),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35))),
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
                            "Algun campo se encuentra vacío",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(1, 29, 69, 1),
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            }),
          ); //accesosModal();
        });
  }
}

class barranavegacion extends StatelessWidget {
  const barranavegacion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.width *
          0.16, // Ajusta el valor del ancho según sea necesario
      child: ClipRRect(
        child: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(
              1, 29, 69, 1), // Set the background color of the navigation bar
          selectedItemColor: Colors.white, // Set the color of the selected item
          unselectedItemColor:
              Colors.white, // Set the color of the unselected items
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/RESERVACIONES.png',
                  width: 40, height: 25), // Cambia el icono por la imagen
              label: 'Reservaciones',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/MIACCESO.png',
                  width: 40, height: 24), // Cambia el icono por la imagen
              label: 'Mi Acceso',
            ),
          ],
        ),
      ),
    );
  }
}

class BotonFlotante extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.90, // Ajusta el valor del ancho según sea necesario
      height: MediaQuery.of(context).size.width *
          0.2, // Ajusta el valor del alto según sea necesario
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Establece la forma del botón como un círculo
        border: Border.all(
            color: Colors.white,
            width: 10.0), // Agrega un borde blanco alrededor del botón
      ),
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(
            1, 29, 69, 1), // Establece el color de fondo del botón
        child: Image.asset('assets/images/S.O.S.png',
            width: 80, height: 60), // Cambia el icono por la imagen
        onPressed: () {
          print('Hola Mundo');
        },
      ),
    );
  }
}
