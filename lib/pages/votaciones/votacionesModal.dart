import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class votacionesModal extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const votacionesModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });

  @override
  _votacionesModal createState() => _votacionesModal();
}

class _votacionesModal extends State<votacionesModal> {
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/SaveVoting/';
  late String idUser;
  late String associationId;
  late TextEditingController textFieldEnviarTitulo;
  late TextEditingController textFieldEnviarDescripcion;
  late TextEditingController textFieldEnviarOpcion1;
  late TextEditingController textFieldEnviarOpcion2;
  late TextEditingController textFieldEnviarOpcion3;
  late TextEditingController textFieldEnviarOpcion4;
  late TextEditingController textFieldEnviarDia;
  late TextEditingController textFieldEnviarMes;
  final textFieldEnviarAnho = TextEditingController();
  //late TextEditingController textFieldEnviarHora;
  //late TextEditingController textFieldEnviarMinutos;
  String selectedtext = '';
  String idAssociation = '';
  late int selectedYear = 2012;
  late List<int> yearsList;
  String? selectedMonth;
  int? selectedDay;

  List<int> daysList = [];

  List<String> monthsList = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  void updateDaysList(String selectedMonth) {
    int daysInMonth =
        DateTime(DateTime.now().year, monthsList.indexOf(selectedMonth) + 2, 0)
            .day;
    setState(() {
      daysList = List<int>.generate(daysInMonth, (index) => index + 1);
    });
  }

  void initState() {
    super.initState();
    idUser = '';
    associationId = '';
    idAssociation = '';
    textFieldEnviarTitulo = TextEditingController();
    textFieldEnviarDescripcion = TextEditingController();
    textFieldEnviarDia = TextEditingController();
    textFieldEnviarMes = TextEditingController();

    textFieldEnviarOpcion1 = TextEditingController();
    textFieldEnviarOpcion2 = TextEditingController();
    textFieldEnviarOpcion3 = TextEditingController();
    textFieldEnviarOpcion4 = TextEditingController();
    selectedYear = DateTime.now().year;
    yearsList = List.generate(15, (index) => DateTime.now().year - index);
  }

  Future<String> votacion() async {
    String titulo = textFieldEnviarTitulo.text.trim();
    String descripcion = textFieldEnviarDescripcion.text.trim();
    String? dia = textFieldEnviarDia.text.trim();
    String? mes = textFieldEnviarMes.text.trim();
    String? anho = textFieldEnviarAnho.text.trim();
    String opcion1 = textFieldEnviarOpcion1.text.trim();
    String opcion2 = textFieldEnviarOpcion2.text.trim();
    String opcion3 = textFieldEnviarOpcion3.text.trim();
    String opcion4 = textFieldEnviarOpcion4.text.trim();
    String fecha = "$anho/$mes/$dia";

    //Usuario
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();

    //Association
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();

    Map<String, String> data = {
      'idUser': idUser,
      'AssociationId': idAssociation,
      'Title': titulo,
      'Description': descripcion,
      'LimitDate': '$fecha'.toString(),
      'Option1': opcion1,
      'Option2': opcion2,
      'Option3': opcion3,
      'Option4': opcion4,
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse = jsonDecode(response.body);
      print('hello buey');
      print(jsonResponse);
      print(associationId);
      if (jsonResponse['Message'] == 'Created') {
        print("si quedo");

        //Navigator.push(
        //context,
        //MaterialPageRoute(
        //    builder: (context) => InicioWidget(responseJson: jsonResponse)),
        // );
      } else {
        print('valio verdura');
      }
      return jsonResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Color.fromARGB(164, 243, 243, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(27.0), // Bordes redondeados
                  ),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          Column(children: [
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(104, 1, 29, 69),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(27),
                                      topRight: Radius.circular(27))),
                              child: Text(
                                "CREAR VOTACIÓN",
                                style: TextStyle(
                                    color: Color(0xFF2CFFE2),
                                    fontSize: 22,
                                    fontFamily: 'Helvetica Neue, Bold',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.73,
                                height:
                                    MediaQuery.of(context).size.width * 0.16,
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.0,
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    TextField(
                                      controller: textFieldEnviarTitulo,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedtext = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color.fromARGB(124, 105, 117,
                                            134), // Cambia el color de fondo aquí
                                        labelText: 'Titulo...',
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                              30.0), // Ajusta el radio del borde aquí
                                        ),
                                        // Ajusta el espaciado del texto dentro del TextField
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.73,
                                height:
                                    MediaQuery.of(context).size.width * 0.16,
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.0,
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    TextField(
                                      controller: textFieldEnviarDescripcion,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedtext = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color.fromARGB(124, 105, 117,
                                            134), // Cambia el color de fondo aquí
                                        labelText: 'Descripción...',
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                              30.0), // Ajusta el radio del borde aquí
                                        ),
                                        // Ajusta el espaciado del texto dentro del TextField
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.73,
                                height:
                                    MediaQuery.of(context).size.width * 0.16,
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.0,
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    TextField(
                                      controller: textFieldEnviarOpcion1,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedtext = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color.fromARGB(124, 105, 117,
                                            134), // Cambia el color de fondo aquí
                                        labelText: 'Opción 1...',
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                              30.0), // Ajusta el radio del borde aquí
                                        ),
                                        // Ajusta el espaciado del texto dentro del TextField
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.73,
                                height:
                                    MediaQuery.of(context).size.width * 0.16,
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.0,
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    TextField(
                                      controller: textFieldEnviarOpcion2,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedtext = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color.fromARGB(124, 105, 117,
                                            134), // Cambia el color de fondo aquí
                                        labelText: 'Opción 2...',
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                              30.0), // Ajusta el radio del borde aquí
                                        ),
                                        // Ajusta el espaciado del texto dentro del TextField
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.73,
                                height:
                                    MediaQuery.of(context).size.width * 0.16,
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.0,
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    TextField(
                                      controller: textFieldEnviarOpcion3,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedtext = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color.fromARGB(124, 105, 117,
                                            134), // Cambia el color de fondo aquí
                                        labelText: 'Opción 3...',
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                              30.0), // Ajusta el radio del borde aquí
                                        ),
                                        // Ajusta el espaciado del texto dentro del TextField
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.73,
                                height:
                                    MediaQuery.of(context).size.width * 0.16,
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.0,
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    TextField(
                                      controller: textFieldEnviarOpcion4,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedtext = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color.fromARGB(124, 105, 117,
                                            134), // Cambia el color de fondo aquí
                                        labelText: 'Opción 4...',
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                              30.0), // Ajusta el radio del borde aquí
                                        ),
                                        // Ajusta el espaciado del texto dentro del TextField
                                      ),
                                    ),
                                  ],
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 10.0, 0.0, 0.0),
                                    child: DropdownButton<int>(
                                        style: TextStyle(
                                          fontFamily:
                                              'Helvetica Neue, Light Italic',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        dropdownColor:
                                            Color.fromARGB(103, 255, 255, 255),
                                        value: selectedDay,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedDay = newValue;
                                            textFieldEnviarDia.text = newValue
                                                .toString()
                                                .padLeft(2, '0');
                                          });
                                        },
                                        hint: Text(
                                          "Dia",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  254, 254, 254, 1)),
                                        ),
                                        icon: Icon(
                                          Icons
                                              .arrow_drop_down, // Icono de flecha hacia abajo
                                          color:
                                              Color.fromRGBO(254, 254, 254, 1),
                                          size: 25,
                                          // Cambiar el color de la flecha
                                        ),
                                        items: daysList.map((int day) {
                                          return DropdownMenuItem<int>(
                                            value: day,
                                            child: Text(day.toString()),
                                          );
                                        }).toList())),
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        15.0, 10.0, 0.0, 0.0),
                                    child: DropdownButton<String>(
                                        style: TextStyle(
                                          fontFamily:
                                              'Helvetica Neue, Light Italic',
                                          fontSize: 16,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          /*fontSize:
                                                                              15.0,*/
                                        ),
                                        dropdownColor: Color(0x67FFFFFF),
                                        value: selectedMonth,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedMonth = newValue;
                                            int monthIndex =
                                                monthsList.indexOf(newValue!);
                                            selectedDay = null;
                                            updateDaysList(selectedMonth!);
                                            textFieldEnviarMes.text =
                                                (monthIndex + 1)
                                                    .toString()
                                                    .padLeft(2, '0');
                                          });
                                        },
                                        hint: Text(
                                          "Mes",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1)),
                                        ),
                                        icon: Icon(
                                          Icons
                                              .arrow_drop_down, // Icono de flecha hacia abajo
                                          color:
                                              Color.fromRGBO(254, 254, 254, 1),
                                          size:
                                              25, // Cambiar el color de la flecha
                                        ),
                                        items: monthsList.map((String month) {
                                          return DropdownMenuItem<String>(
                                            value: month,
                                            child: Text(month),
                                          );
                                        }).toList())),
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 0.0, 0.0),
                                    child: DropdownButton<int>(
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                      icon: Icon(
                                        Icons
                                            .arrow_drop_down, // Icono de flecha hacia abajo
                                        color: Color.fromRGBO(254, 254, 254, 1),
                                        size:
                                            25, // Cambiar el color de la flecha
                                      ),
                                      dropdownColor: Color(0x67FFFFFF),
                                      value: selectedYear,
                                      items: yearsList.map((int year) {
                                        return DropdownMenuItem<int>(
                                          value: year,
                                          child: Text(year.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedYear = newValue!;
                                          textFieldEnviarAnho.text =
                                              newValue.toString();
                                        });
                                      },
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.width *
                                        0.16,
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.03,
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                      right: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    child: Stack(
                                      children: [
                                        TextField(
                                          //controller: textFieldEnviarHora,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedtext = value;
                                            });
                                          },
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromARGB(
                                                124,
                                                105,
                                                117,
                                                134), // Cambia el color de fondo aquí
                                            labelText: 'Hora',

                                            labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(
                                                  30.0), // Ajusta el radio del borde aquí
                                            ),
                                            // Ajusta el espaciado del texto dentro del TextField
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.width *
                                        0.16,
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.03,
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        TextField(
                                          //controller: textFieldEnviarMinutos,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedtext = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromARGB(
                                                124,
                                                105,
                                                117,
                                                134), // Cambia el color de fondo aquí
                                            labelText: 'Minutos',
                                            labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(
                                                  30.0), // Ajusta el radio del borde aquí
                                            ),
                                            // Ajusta el espaciado del texto dentro del TextField
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.11,
                                left: MediaQuery.of(context).size.width * 0.11,
                                top: MediaQuery.of(context).size.width * 0.03,
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  votacion();
                                },
                                child: Text("GUARDAR",
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    )),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(34),
                                      ),
                                    ),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(190, 36)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF011D45))),
                              ),
                            )
                          ]),
                        ],
                      )),
                    );
                  }),
                );
              });
        },
        child: Text("Crear votación",
            style: TextStyle(
              fontFamily: 'Helvetica Neue, Bold',
              fontSize: 12,
            )),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    34), // Ajusta el radio de borde para redondear el botón
              ),
            ),
            minimumSize: MaterialStateProperty.all<Size>(Size(160, 36)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF011D45))),
      ),
    );
  }
}
