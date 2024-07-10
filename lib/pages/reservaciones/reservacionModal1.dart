import 'dart:convert';
import 'package:spacesclub/pages/reservaciones/reservacionDate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class reservacionModal1 extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const reservacionModal1({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _reservacionModal1State createState() => _reservacionModal1State();
}

class _reservacionModal1State extends State<reservacionModal1> {
  late String idAssociation;
  List<dynamic> reservaciones2 = [];
  Future<void> getReservations() async {
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetReservations/';

    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();
    final body = {
      'idUser': widget.idUsuario,
      'AssociationId': idAssociation,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      // La solicitud fue exitosa, analiza la respuesta JSON
      print('Entro a la Api de Reservaciones jajajaja');
      final parsedJson = json.decode(response.body);
      final dataList1 = parsedJson['Data'] as List<dynamic>;
      final reservacionList1 =
          json.decode(dataList1[1]['Value']) as List<dynamic>;
      print("Facilities: $reservacionList1");

      setState(() {
        reservaciones2 = reservacionList1;
      });
    } else {
      // La solicitud falló
      print('No entro a la Api');
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  void initState() {
    super.initState();
    getReservations();
  }

  @override
  Widget build(BuildContext context) {
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final responseJson = widget.responseJson;
    return Container(
      child: IconButton(
        onPressed: () {
          getReservations();
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
                      height: MediaQuery.of(context).size.height * 1,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(children: [
                        Container(
                            alignment: Alignment.bottomCenter,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(104, 1, 29, 69),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(27),
                                    topRight: Radius.circular(27))),
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.cancel_outlined,
                                          size: 30,
                                          color:
                                              Color.fromARGB(255, 0, 236, 205),
                                          shadows: [
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Color.fromARGB(
                                                  255, 68, 68, 68),
                                            ),
                                          ]),
                                      iconSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Nueva Reservacion",
                                    style: TextStyle(
                                        color: Color(0xFF2CFFE2),
                                        fontSize: 16,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  width: MediaQuery.of(context).size.width * 1,
                                  decoration: BoxDecoration(
                                      //color: Colors.amber
                                      ),
                                  child: ListView.builder(
                                      itemCount: reservaciones2.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final reservacion =
                                            reservaciones2[index];
                                        final name =
                                            reservacion['Name'].toString();
                                        final imagen = reservacion['Image'];
                                        final id = reservacion['Id'];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          reservacionDate(
                                                              responseJson:
                                                                  responseJson,
                                                              idPropiedad:
                                                                  _idPropiedad,
                                                              idUsuario:
                                                                  _idUsario,
                                                              name: name,
                                                              imagen: imagen,
                                                              id: id)));
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1,
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          132, 0, 146, 126)),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                        child:
                                                            FractionallySizedBox(
                                                          widthFactor: 0.8,
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.5,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.5,
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Image
                                                                    .network(
                                                                  imagen,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            //color: Colors.green
                                                            ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                        child: Center(
                                                          child: Text(
                                                            "$name",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                    );
                  }),
                );
              });
        },
        icon: Icon(Icons.calendar_month_outlined),
        iconSize: MediaQuery.of(context).size.width * 0.15,
      ),
    );
  }
}
