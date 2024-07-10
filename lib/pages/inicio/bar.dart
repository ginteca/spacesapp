import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../inicio/history.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Acceso',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Color(0xFF031091),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Color(0xFF031091),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      themeMode: ThemeMode.light,
      home: BarControlScreen(),
    );
  }
}

class BarControlScreen extends StatefulWidget {
  @override
  State<BarControlScreen> createState() => _BarControlScreenState();
}

class _BarControlScreenState extends State<BarControlScreen> {
  String accessCodeId = '';
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController amountController =
      TextEditingController(text: "0.00");
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String codigo = '';
  double amount = 0.0;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() {
        codigo = textEditingController.text;
      });
    });
    amountController.addListener(() {
      setState(() {
        amount = double.tryParse(amountController.text) ?? 0;
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
    textEditingController.removeListener(() {});
    textEditingController.dispose();
    amountController.removeListener(() {});
    amountController.dispose();
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
          codigo = result?.code ?? '';
          textEditingController.text = codigo;
          controller.pauseCamera();
          _validateCode();
        }
      });
    });
  }

  void _validateCode() async {
    final url = Uri.parse('https://jaus.azurewebsites.net/mount.php');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"codigo_qr": codigo, "amount": amount});

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'];
        final message = data['message'];

        if (status == 'valid') {
          _showAlert(context,
              'Código válido y actualizado. Nuevo monto: ${data['new_mount']}');
        } else if (status == 'used') {
          _showAlert(context, 'El boleto ya ha sido usado');
        } else if (status == 'invalid') {
          _showAlert(context, 'El código QR no es válido');
        } else if (status == 'insufficient_funds') {
          _showAlert(context, 'Fondos insuficientes');
        } else {
          _showAlert(context, 'Error: $message');
        }
      } else {
        _showAlert(context, 'Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      _showAlert(context, 'Excepción capturada al hacer la solicitud: $e');
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar sesión'),
          content: Text('¿Está seguro de que desea cerrar sesión?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Regresar a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  File? idImage;
  File? platesImage;
  bool isLoading = false;

  Future<void> pickImage(bool isIdImage) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          if (isIdImage) {
            idImage = File(pickedFile.path);
          } else {
            platesImage = File(pickedFile.path);
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
        title: Center(
          child: Text('CLUB DE GOLF'),
        ),
        backgroundColor: Color(0xFF031091),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/FONDO_GENERAL.jpg'), // Imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
            left: 0,
            right: 0,
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  @override
  Widget _buildMainContent() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/charlyLogo.png',
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixText: '\$',
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'Ingresa el monto a cobrar',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Escribe o escanea Código de Pago',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLength: 6,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _validateCode();
                },
                child: Text('Validar pago'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(150, 40), // Tamaño reducido
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              width: MediaQuery.of(context).size.width *
                  0.7, // Hacer el contenedor del escáner más pequeño
              height: MediaQuery.of(context).size.width *
                  0.7, // Hacer el contenedor del escáner más pequeño
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Color(0xFF011D45),
                  borderRadius: 10,
                  borderLength: 20, // Hacer el escáner más pequeño
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width *
                      0.6, // Hacer el escáner más pequeño
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Acción para el botón de historial
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistorialScreen(
                              userNeighborId: '',
                            )),
                  );
                },
                child: Text('Historial'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
