import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Asegúrate de tener esta dependencia en pubspec.yaml

class HistorialScreen extends StatefulWidget {
  final String userNeighborId;

  HistorialScreen({required this.userNeighborId});

  @override
  _HistorialScreenState createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  List history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final url = 'https://jaus.azurewebsites.net/Historypaymentuser.php';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"UserNeighbor_Id": widget.userNeighborId}),
    );

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          history = jsonResponse['history'];
          isLoading = false;
        });
      } else {
        print('Error: ${jsonResponse['message']}');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return DateFormat('EEEE, dd MMMM yyyy', 'es').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Historial de Pagos'),
        ),
        backgroundColor: Color(0xFF031091),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Icono vacío para mantener el título centrado
          IconButton(
            icon: Icon(Icons.settings, color: Colors.transparent),
            onPressed: () {},
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
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (history.isEmpty)
            Center(child: Text('No hay datos de historial disponibles'))
          else
            Positioned(
              top: MediaQuery.of(context).size.height * 0.20,
              left: 0,
              right: 0,
              bottom:
                  0, // Para asegurar que el ListView ocupe el espacio disponible
              child: Container(
                height: MediaQuery.of(context).size.height * 0.80,
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final statusColor = item['Status'] == 'Validated'
                        ? Colors.green
                        : Colors.red;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Color.fromARGB(
                            255, 237, 237, 237), // Color gris medio
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            item['Description']?.toUpperCase() ??
                                'SIN DESCRIPCIÓN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(
                                  0xFF031091), // Mismo color que la AppBar
                            ),
                          ),
                          subtitle: Text(
                            formatDate(item['fecha_pago']),
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${item['Mount']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 5,
                                height: double.infinity,
                                color: statusColor,
                              ),
                            ],
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
