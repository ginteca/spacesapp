import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'reportes.dart';

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
      home: CaddyeScreen(),
    );
  }
}

class CaddyeScreen extends StatefulWidget {
  @override
  _CaddyeScreenState createState() => _CaddyeScreenState();
}

class _CaddyeScreenState extends State<CaddyeScreen> {
  List<bool> isSelected = [true, false, false];
  List caddyHouseData = [];
  List filteredData = [];
  List attendedData = [];
  List notAttendedData = [];
  bool isLoading = true;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCaddyHouseData();
  }

  Future<void> fetchCaddyHouseData() async {
    final response = await http
        .get(Uri.parse('https://jaus.azurewebsites.net/api_caddyhouse.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        caddyHouseData = data['data']['all'];
        filteredData = caddyHouseData;
        attendedData = data['data']['attended'];
        notAttendedData = data['data']['not_attended'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void filterSearchResults(String query) {
    List dummyListData = [];
    if (query.isNotEmpty) {
      List listData = isSelected[0]
          ? caddyHouseData
          : isSelected[1]
              ? attendedData
              : notAttendedData;
      dummyListData = listData
          .where((item) =>
              item['UserProperty_Id'].toString().contains(query) ||
              item['Devices'].toString().contains(query))
          .toList();
      setState(() {
        filteredData = dummyListData;
      });
    } else {
      setState(() {
        filteredData = isSelected[0]
            ? caddyHouseData
            : isSelected[1]
                ? attendedData
                : notAttendedData;
      });
    }
  }

  String formatStatus(String status) {
    switch (status) {
      case 'Enproceso':
        return 'En camino';
      case 'Active':
        return 'En uso';
      case 'Nuevo':
        return 'Nuevo';
      default:
        return status;
    }
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
                if (isSearching) {
                  isSearching = false;
                  filteredData = isSelected[0]
                      ? caddyHouseData
                      : isSelected[1]
                          ? attendedData
                          : notAttendedData;
                  searchController.clear();
                } else {
                  isSearching = true;
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
                image: AssetImage(
                    'assets/images/FONDO_GENERAL.jpg'), // Imagen de fondo
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
                        _buildIconButton(Icons.report, 'Reportes'),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/charlyLogo.png', // Imagen del logo
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        _buildIconButton(Icons.search, 'Buscar'),
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
                      ToggleButtons(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('TODOS'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('ATENDIDOS'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('NO ATENDIDOS'),
                          ),
                        ],
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == index;
                            }
                            filterSearchResults(searchController.text);
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        fillColor: Color(0xFF031091),
                        selectedColor: Colors.white,
                        color: Colors.grey,
                      ),
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
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  final item = filteredData[index];
                                  return GestureDetector(
                                    onTap: () =>
                                        _showModalBottomSheet(context, item),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: Icon(Icons.mail, size: 40),
                                        title: Row(
                                          children: [
                                            Text(
                                              item['UserProperty_Id']
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: index == 0
                                                    ? Color(0xFF031091)
                                                    : Colors.black,
                                              ),
                                            ),
                                            if (item['Status'] == 'Nuevo')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 12,
                                                  color: Colors.red,
                                                ),
                                              ),
                                          ],
                                        ),
                                        subtitle: Text(
                                            '${item['Devices']} / ${item['Fecha_inicial']} / ${item['Fecha_final']}'),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.golf_course,
                                                size: 30,
                                                color: index == 0
                                                    ? Color(0xFF031091)
                                                    : Colors.black),
                                            Text(formatStatus(item['Status'])),
                                          ],
                                        ),
                                        tileColor: index == 0
                                            ? Color(0xFF031091).withOpacity(0.2)
                                            : Colors.white,
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

  Widget _buildIconButton(IconData icon, String label) {
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

  void _showModalBottomSheet(BuildContext context, dynamic item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información del Registro',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text('ID: ${item['UserProperty_Id']}'),
              Text('Dispositivos: ${item['Devices']}'),
              Text('Fecha Inicial: ${item['Fecha_inicial']}'),
              Text('Fecha Final: ${item['Fecha_final']}'),
              Text('Estado: ${formatStatus(item['Status'])}'),
              Text('Fecha de Registro: ${item['Fecha_de_registro']}'),
            ],
          ),
        );
      },
    );
  }
}
