import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:spacesclub/components/tiles/tileCodes.dart';

import '../../flutter_flow/flutter_flow_util.dart';
import 'dart:io';

class ControlAccesoPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;

  const ControlAccesoPage({
    Key? key,
    required this.responseJson,
    required this.idPropiedad,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _ControlAccesoPageState createState() => _ControlAccesoPageState();
}

class _ControlAccesoPageState extends State<ControlAccesoPage> {
  late String idUser;
  late int codeId;
  late String estatus2;
  Uint8List? qrImageData;
  List<dynamic> codigos = [];
  List<dynamic> codigosPermanentes = [];
  List<dynamic> codigosOtros = [];
  String searchQuery = '';
  bool showPermanentes = true;
  bool isLoading = false;
  bool isHistoryLoading = false;

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
                  child: IconButton(
                    icon: Icon(
                      Icons.share,
                      size: 30,
                      color: Color.fromRGBO(1, 29, 69, 1),
                    ),
                    onPressed: () async {
                      final imageBytes = snapshot.data!;
                      await shareImage(imageBytes, 'Hola');
                    },
                  ),
                )
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
      final ByteData bytes = ByteData.view(imageBytes.buffer);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$imageName.png');
      await file.writeAsBytes(bytes.buffer.asUint8List());

      await Share.shareFiles(
        ['${tempDir.path}/$imageName.png'],
        text: 'Compartir imagen generada',
        subject: 'Compartir imagen',
      );
    } catch (e) {
      print('Error al compartir la imagen: $e');
    }
  }

  Future<void> getCodigos() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('idUsuario') ?? '';
    final idProperty = prefs.getString('idPropiedad') ?? '';

    final url = 'https://appaltea.azurewebsites.net/api/Mobile/GetCodesUser/';
    final body = {
      'idUser': idUser,
      'PropertyId': idProperty,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      try {
        final parsedJson = json.decode(response.body);
        final dataList = parsedJson['Data'] as List<dynamic>;
        final valueStr = dataList[0]['Value'] as String;
        final codigosList = json.decode(valueStr) as List<dynamic>;

        setState(() {
          codigos = codigosList;
          codigosPermanentes = codigosList
              .where((codigo) => codigo['Type'] == 'Permanente')
              .toList();
          codigosOtros = codigosList
              .where((codigo) => codigo['Type'] != 'Permanente')
              .toList();
        });
      } catch (e) {
        print('Error al decodificar el JSON: $e');
      }
    } else {
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> deleteReservation(int idCodigo) async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('idUsuario') ?? '';

    final url = 'https://appaltea.azurewebsites.net/api/Mobile/DeleteCodeUser/';
    Map<String, String> data = {
      'idUser': idUser,
      'CodeId': idCodigo.toString()
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: data,
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      await getCodigos(); // Recargar la lista de códigos después de eliminar
    } else {
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchVisitHistory(String visitCode) async {
    final url = 'https://jaus.azurewebsites.net/historialcode.php';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'VisitCode_Code': visitCode}),
    );
    print('holaa');
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data['data'] as List<dynamic>;
      } catch (e) {
        print('Error al decodificar el historial de visitas: $e');
        throw e;
      }
    } else {
      print(
          'Error en la solicitud del historial de visitas. Código de estado: ${response.statusCode}');
      throw Exception('Failed to load visit history');
    }
  }

  void showVisitHistory(BuildContext context, List<dynamic> history) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Historial de Visitas'),
              content: isHistoryLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: history.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = history[index];
                          final fechaMap = item['VisitCode_Fecha'];
                          final fecha = DateTime.parse(fechaMap['date']);
                          final formattedDate =
                              DateFormat('dd/MM/yyyy').format(fecha);
                          final formattedTime =
                              DateFormat('HH:mm').format(fecha);
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Descripción: ${item['VisitCode_Description']}'),
                                Text('Código: ${item['VisitCode_Code']}'),
                                Text('Fecha: $formattedDate $formattedTime'),
                                Text(
                                    'Validado por: ${item['VisitCode_Validacion']}'),
                                Text('Dirección: ${item['VisitCode_Dir']}'),
                              ],
                            ),
                          );
                        },
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
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCodigos();
  }

  List<dynamic> getFilteredCodigos() {
    final filteredCodigos = showPermanentes ? codigosPermanentes : codigosOtros;
    if (searchQuery.isEmpty) {
      return filteredCodigos;
    }
    return filteredCodigos
        .where((codigo) =>
            codigo['Code'].toString().contains(searchQuery) ||
            codigo['Description'].toString().contains(searchQuery))
        .toList();
  }

  @override
  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onHorizontalDragEnd: (details) {
      // Detecta si el deslizamiento fue hacia la izquierda o derecha
      if (details.primaryVelocity! > 0) {
        // Deslizó hacia la derecha
        setState(() {
          showPermanentes = true;
        });
      } else if (details.primaryVelocity! < 0) {
        // Deslizó hacia la izquierda
        setState(() {
          showPermanentes = false;
        });
      }
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 16, 145, 1),
        title: Text(
          "MIS CODIGOS",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/FONDO_GENERAL.jpg"), // Ruta de tu imagen en assets
            fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el fondo
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            showPermanentes = true;
                          });
                        },
                        child: Text(
                          "Permanentes",
                          style: TextStyle(
                            color: showPermanentes ? Color.fromRGBO(255, 255, 255, 1) : Colors.grey,
                            shadows: showPermanentes
                                ? [Shadow(
                                    color: Color.fromRGBO(6, 35, 153, 1),
                                    offset: Offset(0, 2), // Sombra debajo del texto
                                    blurRadius: 2,
                                  )]
                                : null,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.transparent, // Sin efecto de fondo al hacer clic
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showPermanentes = false;
                        });
                      },
                      child: Text(
                        "Otros",
                        style: TextStyle(
                          color: showPermanentes ? Colors.grey : Color.fromRGBO(255, 255, 255, 1),
                          shadows: !showPermanentes
                              ? [Shadow(
                                  color: Color.fromRGBO(6, 35, 153, 1),
                                  offset: Offset(0, 2), // Sombra debajo del texto
                                  blurRadius: 2,
                                )]
                              : null,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.transparent, // Sin efecto de fondo al hacer clic
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: getFilteredCodigos().length,
                    itemBuilder: (BuildContext context, int index) {
                      final codigoGuardados = getFilteredCodigos()[index];
                      final idCodigo = codigoGuardados['Id'];
                      final codigo = codigoGuardados['Code'];
                      final tipo = codigoGuardados['Type'];
                      final estatus = codigoGuardados['StatusVigilant'];

                      final fecha = codigoGuardados['Validity'] as String;
                      final parsedDate = DateTime.parse(fecha);
                      final formattedDate =
                          DateFormat('dd/MM/yyyy').format(parsedDate);
                      final formattedTime =
                          DateFormat('HH:mm').format(parsedDate);

                      final fechaR = codigoGuardados['RegisterDate'] as String;
                      final parsedDate2 = DateTime.parse(fechaR);
                      final formattedDate2 =
                          DateFormat('dd/MM/yyyy').format(parsedDate2);

                      final fechaV = codigoGuardados['ViglantDate'] as String;
                      final parsedDateV = DateTime.parse(fechaV);
                      final formattedDateV =
                          DateFormat('dd/MM/yyyy').format(parsedDateV);

                      final descripcion =
                          codigoGuardados['Description'].toString();
                      final validado =
                          codigoGuardados['StatusVigilant'];
                      print(codigoGuardados);

                      if (estatus == 'NoValidated') {
                        estatus2 = 'sin usar';
                      } else {
                        estatus2 = 'usado';
                      }

                      return TileCodes(codigo: codigo, fechaCreado: formattedDate2, fechaValidado: formattedDate, fechaSalida: formattedDateV, observaciones: descripcion, context: context);
                    },
                  ),
                ),
              ],
            ),
            if (isLoading)
              Center(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
}
