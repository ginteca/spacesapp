import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacesclub/pages/reservaciones/reservacionesWidget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../inicio/inicio_widget.dart';

class reservacionDate extends StatefulWidget {
  final imagen;
  final name;
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final id;
  const reservacionDate(
      {Key? key,
      required this.name,
      required this.imagen,
      required this.responseJson,
      required this.idUsuario,
      required this.idPropiedad,
      required this.id});
  @override
  _reservaciones createState() => _reservaciones();
}

class _reservaciones extends State<reservacionDate> {
  int selectedButtonIndex = -1;
  int selectedButtonIndex2 = -1;
  bool isButtonSelected1 = false;
  bool isButtonSelected2 = false;
  late String fecha1;
  late String fecha2;
  String disponibleGlobal = '';
  String noDisponibilidadGlobal = '';
  late int selectedYear = 1922;
  late List<int> yearsList;
  String? selectedMonth;
  int? selectedDay;
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  //DateTime now = DateTime.now();

  List<int> daysList = [];
  List<dynamic> reservaciones = [];

  bool isAnyTimeSlotBusy(DateTime startTime, DateTime endTime) {
    for (final reserva in reservaciones) {
      final inicioReserva = DateTime.parse(reserva['Oclock']['TimeDisp']);
      final finalReserva = DateTime.parse(reserva['Half']['TimeDisp']);

      if ((startTime.isBefore(finalReserva) &&
              endTime.isAfter(inicioReserva)) &&
          (reserva['Oclock']['Status'] == 'Busy' ||
              reserva['Half']['Status'] == 'Busy')) {
        return true;
      }
    }
    return false;
  }

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

  final _descripcionController = TextEditingController();

  Future<void> getDisponibilidad() async {
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetDisponibility/';

    String? day = _dayController.text.trim();
    String? month = _monthController.text.trim();
    String? year = _yearController.text.trim();
    final body = {
      'idUser': widget.idUsuario,
      'FacilityId': widget.id.toString(),
      'DateTimeReservation': '$day/$month/$year',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // La solicitud fue exitosa, analiza la respuesta JSON
        print('Entro a la Api de Disponibilidad');
        final parsedJson = json.decode(response.body);
        print('Contenido de parsedJson: $parsedJson');

        // Verifica si 'Data' y otros elementos existen en parsedJson
        if (parsedJson.containsKey('Data') &&
            parsedJson['Data'] is List<dynamic> &&
            parsedJson['Data'].isNotEmpty) {
          final disponibilidadesJson = parsedJson['Data'][0]['Value'] as String;
          final disponibilidadesList =
              json.decode(disponibilidadesJson) as List<dynamic>;

          // Actualiza el estado con la lista de disponibilidades
          setState(() {
            reservaciones = disponibilidadesList;
          });
        } else {
          print('El formato del JSON no es el esperado');
        }

        // Si esperas obtener información específica, puedes acceder a los valores
        // en parsedJson aquí y realizar las operaciones necesarias.
      } else {
        // La solicitud falló
        print(
            'Error en la solicitud. Código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (error) {
      // Capturar cualquier error que pueda ocurrir durante la solicitud
      print('Error al realizar la solicitud: $error');
    }
  }

  Future<void> saveReservation() async {
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/SaveReservation/';
    String descripcion = _descripcionController.text.trim();
    String fechaHora = fecha1.replaceAll('"', '');
    List<String> partes = fechaHora.split('T');
    String fecha = partes[0];
    String hora = partes[1];
    String horaInicial = "$fecha $hora";
    print("$horaInicial");
    // Parsear la fecha en un objeto DateTime
    DateTime parsedDate = DateTime.parse(horaInicial);
    // Extraer el día, mes y año del objeto DateTime
    String dia = DateFormat('dd').format(parsedDate);
    String mes = DateFormat('MM').format(parsedDate);
    String anio = DateFormat('yyyy').format(parsedDate);
    String hora1 = DateFormat('HH').format(parsedDate);
    String minutos = DateFormat('mm').format(parsedDate);
    String segundos = DateFormat('ss').format(parsedDate);
    String fechaIncial = "$dia/$mes/$anio $hora1:$minutos:$segundos";
    print("$fechaIncial");

    String fechaHora2 = fecha2.replaceAll('"', '');
    List<String> partes2 = fechaHora2.split('T');
    String fecha3 = partes2[0];
    String hora2 = partes2[1];
    String horaFinal = "$fecha3 $hora2";
    DateTime parsedDate2 = DateTime.parse(horaFinal);
    parsedDate2 = parsedDate2.add(Duration(minutes: 30));
    // Extraer el día, mes y año del objeto DateTime
    String dia2 = DateFormat('dd').format(parsedDate2);
    String mes2 = DateFormat('MM').format(parsedDate2);
    String anio2 = DateFormat('yyyy').format(parsedDate2);
    String hora3 = DateFormat('HH').format(parsedDate2);
    String minutos2 = DateFormat('mm').format(parsedDate2);
    String segundos2 = DateFormat('ss').format(parsedDate2);
    String fechaFinal = "$dia2/$mes2/$anio2 $hora3:$minutos2:$segundos2";
    print("$fechaFinal");

    Map<String, String> data = {
      'idUser': widget.idUsuario.toString(),
      'FacilityId': widget.id.toString(),
      'Description': descripcion,
      'DateStart': "$fechaIncial".toString(),
      'DateFinish': '$fechaFinal'.toString()
    };

    print("pasa o no");
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      //print(response.body);
      var jsonResponse = jsonDecode(response.body);
      print('hello buey');
      print(jsonResponse);
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
  void initState() {
    //isButtonSelected1 = false;
    super.initState();
    selectedYear = 2024;
    yearsList = List.generate(10, (index) => DateTime.now().year + index);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.name;
    return Container(
      child: Scaffold(
        body: Builder(
            builder: (context) => SafeArea(
                    child: Container(
                  child: SingleChildScrollView(
                      child: Column(children: [
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
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          content()
                        ],
                      ),
                    )
                  ])),
                ))),
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
            'RESERVACION',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
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
                        InicioWidget(responseJson: responseJson)),
              );
            },
            icon: Image.asset('assets/images/ICONOP.png'),
          ),
        )
      ],
    );
  }

  Widget content() {
    final imageUrl = widget.imagen;
    final name = widget.name;
    final id = widget.id;
    final responseJson = widget.responseJson;
    final idPropiedad = widget.idPropiedad;
    final idUsuario = widget.idUsuario;

    return Container(
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.35,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Text(
            "$name",
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text("Descripcion de tu reservacion",
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.bold,
              )),
          TextField(
            textAlign: TextAlign.center, // Alinea el texto al centro
            controller: _descripcionController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Color.fromARGB(197, 0, 0, 0),
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffe2e3e3), // Cambia el color de fondo aquí
              hintText: 'Descripcion',
              labelStyle: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),

              hintStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(
                    30.0), // Ajusta el radio del borde aquí
              ),
              // Ajusta el espaciado del texto dentro del TextField
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text("Fecha en la que deseas la instalacion",
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.bold,
              )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                functionDay(),
                SizedBox(width: 25),
                functionMonth(),
                SizedBox(width: 25),
                functionYear()
              ],
            ),
          ),
          mostrarFecha(),
          TextButton(
              onPressed: () async {
                getDisponibilidad();
                //saveReservation();
              },
              child: Container(
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 1, 29, 69),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: TextButton(
                  onPressed: () {
                    DateTime parsedFecha1 = DateTime.parse(fecha1);
                    DateTime parsedFecha2 = DateTime.parse(fecha2);

                    DateTime now = DateTime.now();

                    bool isPastDate(DateTime date) {
                      return date.isBefore(DateTime.now());
                    }

                    void showAlertDialog(
                        BuildContext context, String title, String content) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(title),
                          content: Text(content),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Ok'),
                            )
                          ],
                        ),
                      );
                    }

                    if (parsedFecha1.isBefore(parsedFecha2)) {
                      if (isPastDate(parsedFecha1)) {
                        showAlertDialog(
                          context,
                          'No se pudo guardar la reservación',
                          'La fecha de inicio está en el pasado. Escoge una fecha y hora futura.',
                        );
                      } else if (isAnyTimeSlotBusy(
                          parsedFecha1, parsedFecha2)) {
                        showAlertDialog(
                          context,
                          'No se pudo guardar la reservación',
                          'Hay una franja horaria ocupada en el rango seleccionado.',
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title:
                                Text('Se guardó correctamente la reservación'),
                            content: Text('Presiona ok'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReservacionesWidget(
                                        responseJson: responseJson,
                                        idPropiedad: idPropiedad,
                                        idUsuario: idUsuario,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Ok'),
                              )
                            ],
                          ),
                        );
                        saveReservation();
                      }
                    } else {
                      showAlertDialog(
                        context,
                        'No se pudo guardar la reservación',
                        'La fecha de inicio debe ser anterior a la fecha final.',
                      );
                    }
                  },
                  child: Text("Guardar",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Helvetica',
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ))
        ],
      ),
    );
  }

  Widget mostrarFecha() {
    return Container(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  //color: Colors.amber
                  ),
              child: ListView.builder(
                  itemCount: reservaciones.length,
                  itemBuilder: (BuildContext context, int index) {
                    final reserva = reservaciones[index];
                    final hora = reserva['HourLabel'].toString();
                    final horariosD = reserva['Oclock']['MinLabel'].toString();
                    final horariosDH = reserva['Half']['MinLabel'].toString();
                    final disponible = reserva['Oclock']['Status'].toString();
                    final noDisponibilidad =
                        reserva['Half']['Status'].toString();
                    final inicioR = reserva['Oclock']['TimeDisp'].toString();
                    final finalR = reserva['Half']['TimeDisp'].toString();

                    disponibleGlobal = disponible;
                    noDisponibilidadGlobal = noDisponibilidad;

                    return Container(
                      child: Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Row(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30)),
                                  color: Colors.blue,
                                ),
                                alignment: Alignment
                                    .center, // Centrar verticalmente el contenido
                                child: Text("$hora"),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                  //color: Color.fromARGB(68, 0, 12, 52)
                                ),
                                child: Column(
                                  children: [
                                    if (disponible == 'Enabled')
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Cambiar el índice del elemento seleccionado
                                            selectedButtonIndex = index;

                                            fecha1 = inicioR;
                                            print(index);
                                          });
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(0)),
                                            color: selectedButtonIndex == index
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                          child: Center(
                                            child: Text("$horariosD"),
                                          ),
                                        ),
                                      ),
                                    if (disponible == 'Busy')
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(0)),
                                            color: Color.fromARGB(
                                                102, 2, 95, 255)),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "$horariosD",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    if (noDisponibilidad == 'Enabled')
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            fecha2 = finalR;
                                            selectedButtonIndex2 =
                                                index; // Cambiar el estado al tocar el botón
                                          });
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(30)),
                                            color: selectedButtonIndex2 == index
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                          child: Center(
                                            child: Text("$horariosDH"),
                                          ),
                                        ),
                                      ),
                                    if (noDisponibilidad == 'Busy')
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(30)),
                                            color: Color.fromARGB(
                                                102, 2, 95, 255)),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: TextButton(
                                          onPressed: () async {},
                                          child: Text(
                                            "$horariosDH",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  //Esta funcion se encarga de hacer la logica del dia
  Widget functionDay() {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color((0x67FFFFFF)),
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton<int>(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 15.0,
            ),
            dropdownColor: Color(0x67FFFFFF),
            value: selectedDay,
            onChanged: (newValue) {
              setState(() {
                selectedDay = newValue;
                _dayController.text = newValue.toString().padLeft(2, '0');
                getDisponibilidad();
              });
            },
            hint: Text(
              "Dia",
              style: TextStyle(color: Colors.black),
            ),
            items: daysList.map((int day) {
              return DropdownMenuItem<int>(
                value: day,
                child: Text(day.toString()),
              );
            }).toList()));
  }

  //Esta funcion se encarga de hacer la logica del mes
  Widget functionMonth() {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0x67FFFFFF),
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton<String>(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 15.0,
          ),
          dropdownColor: Color(0x67FFFFFF),
          value: selectedMonth,
          onChanged: (newValue) {
            setState(() {
              selectedMonth = newValue;
              int monthIndex = monthsList.indexOf(newValue!);
              selectedDay = null;
              updateDaysList(selectedMonth!);
              _monthController.text =
                  (monthIndex + 1).toString().padLeft(2, '0');
            });
          },
          hint: Text(
            "Mes",
            style: TextStyle(color: Colors.black),
          ),
          items: monthsList.map((String month) {
            return DropdownMenuItem<String>(
              value: month,
              child: Text(month),
            );
          }).toList(),
        ));
  }

  //Esta funcion se encarga de hacer la logica del año
  Widget functionYear() {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0x67FFFFFF),
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton<int>(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 15.0,
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
              _yearController.text = newValue.toString();
              getDisponibilidad();
            });
          },
        ));
  }
}
