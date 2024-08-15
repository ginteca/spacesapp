import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:spacesclub/pages/pedidos/MisPedidos.dart';
import 'dart:convert';
import 'pantallareporte.dart';



class PantallaCarrito extends StatefulWidget {
  final idUsuario;
  final responseJson;
  final idPropiedad;
  const PantallaCarrito({
    Key? key,
    required this.idUsuario,  
    required this.responseJson,
    required this.idPropiedad,
  });
  @override
  _PantallaCarritoState createState() => _PantallaCarritoState();
}

class _PantallaCarritoState extends State<PantallaCarrito> {
  Set<int> _selectedItemsIndices = {};
  String ubicacion = "Hoyo 1";
  String nombre = "";
  String apellido = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('nombre') ?? '';
      apellido = prefs.getString('lastname') ?? '';
    });
  }

  Future<void> _sendRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPropertyId = prefs.getString('idPropiedad') ??
        '1'; // Asume '1' si no se encuentra el valor

    String devices =
        _selectedItemsIndices.map((index) => _getDeviceName(index)).join(', ');
    DateTime now = DateTime.now();
    String fechaInicial =
        '${now.toLocal().toString().split(' ')[0]} ${TimeOfDay.now().format(context)}';
    String fechaFinal =
        '${now.toLocal().toString().split(' ')[0]} ${TimeOfDay.fromDateTime(now.add(Duration(hours: 8))).format(context)}';

    var response = await http.post(
      Uri.parse('https://jaus.azurewebsites.net/prueba.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'UserProperty_Id': userPropertyId,
        'Devices': devices,
        'Fecha_inicial': fechaInicial,
        'Fecha_final': fechaFinal,
        'Nombre': nombre,
        'Apellido': apellido,
        'Ubicacion': ubicacion,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        // Mostrar diálogo de éxito
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 16),
                    Text(
                      'PEDIDO EXITOSO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 16),
                    Image.asset('assets/images/12.png'),
                    SizedBox(height: 24),
                    Text(
                      'Tu equipo se encuentra\nEn camino',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      devices,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Future.microtask(() => Navigator.of(context).pop());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 160, 58, 251),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Manejar error en la respuesta
        print('Error: ${jsonResponse['message']}');
      }
    } else {
      // Manejar error en la solicitud
      print('Error en la solicitud: ${response.reasonPhrase}');
    }
  }

  String _getDeviceName(int index) {
    switch (index) {
      case 0:
        return 'Caddie Trek';
      case 1:
        return 'Equipo';
      case 2:
        return 'Carrito de Golf';
      case 3:
        return 'Caddie';
      default:
        return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 16, 145, 1),
        title: Text('Pide tu Equipo', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/FONDO_GENERAL.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: screenHeight * 0.04),
              Text(
                'Selecciona el equipo que desees utilizar:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: screenHeight * 0.5,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 1),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: EdgeInsets.all(16),
                      children: List.generate(4, (index) {
                        String assetName =
                            'assets/images/equipo${index + 1}.png';
                        bool isSelected = _selectedItemsIndices.contains(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedItemsIndices.remove(index);
                              } else {
                                _selectedItemsIndices.add(index);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset(assetName,
                                      fit: BoxFit.contain),
                                ),
                                Text(
                                  _getDeviceName(index),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.12,
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: ElevatedButton(
              onPressed: _selectedItemsIndices.isNotEmpty
                  ? () {
                      _sendRequest();
                    }
                  : null,
              child: Text('Pedir'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 160, 58, 251),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(screenWidth * 0.5, 40),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.04,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => misPedidosPage(idUsuario: widget.idUsuario, responseJson: widget.responseJson, idPropiedad: widget.idPropiedad)),
                );
                    // Acción para mis pedidos
                  },
                  child: Text('Mis Pedidos'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(3, 16, 145, 1),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PantallaReporte()),
                    );
                  },
                  child: Text('Reportar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
