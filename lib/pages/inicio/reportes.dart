import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(CaddyeApp());
}

class CaddyeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caddye',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Color(0xFF031091),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      home: ReportScreen(),
    );
  }
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isLoading = true;
  bool isSearching = false;
  List reportsData = [];
  List filteredReportsData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchReportsData();
  }

  Future<void> fetchReportsData() async {
    final response = await http
        .get(Uri.parse('https://jaus.azurewebsites.net/get_reports.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        reportsData = data['data'];
        filteredReportsData = reportsData;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List dummyListData = reportsData.where((item) {
        return item['UserProperty_Id'].toString().contains(query) ||
            item['Name_report'].toString().contains(query) ||
            item['LastName_report'].toString().contains(query);
      }).toList();
      setState(() {
        filteredReportsData = dummyListData;
      });
    } else {
      setState(() {
        filteredReportsData = reportsData;
      });
    }
  }

  String formatStatus(String status) {
    switch (status) {
      case 'standby':
        return 'Pendiente';
      case 'success':
        return 'Completado';
      default:
        return status;
    }
  }

  String formatDate(Map<String, dynamic> date) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date['date']));
  }

  @override
  Widget build(BuildContext context) {
    String currentDate =
        DateFormat('EEEE d MMMM y', 'es').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: filterSearchResults,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Buscar...",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              )
            : Text('CLUB DE GOLF'),
        backgroundColor: Color(0xFF031091),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  filteredReportsData = reportsData;
                  searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/FONDO_GENERAL.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconButton(Icons.report, 'Reportes', context),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/charlyLogo.png',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        _buildIconButton(Icons.search, 'Buscar', context),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        currentDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      isLoading
                          ? CircularProgressIndicator()
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                itemCount: filteredReportsData.length,
                                itemBuilder: (context, index) {
                                  final item = filteredReportsData[index];
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReportDetailScreen(
                                          report: item,
                                        ),
                                      ),
                                    ),
                                    child: Card(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      color: item['Status_report'] == 'standby'
                                          ? Colors.red
                                          : Colors.green,
                                      child: ListTile(
                                        leading: Icon(
                                          item['Status_report'] == 'standby'
                                              ? Icons.warning
                                              : Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          '${item['Name_report']} ${item['LastName_report']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          item['Descripcion_report'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        trailing: Text(
                                          formatDate(
                                              item['Fecha_Registro_report']),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
    );
  }

  Widget _buildIconButton(IconData icon, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'Reportes') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportScreen()),
          );
        } else if (label == 'Buscar') {
          // Aquí puedes agregar la lógica para la búsqueda si es necesario
        }
      },
      child: Column(
        children: [
          Icon(icon, size: 30),
          Text(label),
        ],
      ),
    );
  }
}

class ReportDetailScreen extends StatefulWidget {
  final Map<String, dynamic> report;

  ReportDetailScreen({required this.report});

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  late TextEditingController _descriptionController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.report['Descripcion_report']);
    _status = widget.report['Status_report'];
  }

  Future<void> _updateStatus() async {
    var response = await http.post(
      Uri.parse('https://jaus.azurewebsites.net/update_report_status.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'UserProperty_Id': widget.report['UserProperty_Id'],
        'Status_report': _status,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        // Mostrar diálogo de éxito
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Estado actualizado'),
              content: Text('El estado del reporte ha sido actualizado.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el modal
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Error: ${jsonResponse['message']}');
      }
    } else {
      print('Error en la solicitud: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Reporte'),
        backgroundColor: Color(0xFF031091),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID de Propiedad: ${widget.report['UserProperty_Id']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Nombre: ${widget.report['Name_report']} ${widget.report['LastName_report']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              controller: _descriptionController,
              readOnly: true,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF031091)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Estado:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            DropdownButton<String>(
              value: _status,
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: <String>['standby', 'success']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateStatus,
              child: Text('Actualizar Estado'),
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
    );
  }
}
