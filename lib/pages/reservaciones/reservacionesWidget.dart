import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacesclub/pages/reservaciones/reservacionModal1.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';

class ReservacionesWidget extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const ReservacionesWidget({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _ReservacionesWidget createState() => _ReservacionesWidget();
}

class _ReservacionesWidget extends State<ReservacionesWidget> {
  late String idAssociation;
  late String _accessCode;
  List<dynamic> reservaciones = [];
  void initState() {
    super.initState();
    getReservations();
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    _accessCode = data['AccessCode'].toString();
  }

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
      print('Entro a la Api de Reservaciones');
      final parsedJson = json.decode(response.body);
      print(parsedJson);
      print(" $idAssociation");
      final dataList = parsedJson['Data'] as List<dynamic>;
      final reservacionList =
          json.decode(dataList[0]['Value']) as List<dynamic>;
      print("Esto traE: $dataList");

      setState(() {
        reservaciones = reservacionList;
      });
      //codigoacceso

      // setText();
    } else {
      // La solicitud falló
      print('No entro a la Api');
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responseJson = widget.responseJson;
    final idUsuario = widget.idUsuario;
    final idPropiedad = widget.idPropiedad;
    return Container(
      child: Scaffold(
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
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                              ),
                              contentReservaciones(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              Center(
                                child: Container(
                                  child: Column(
                                    children: [
                                      reservacionModal1(
                                          responseJson: responseJson,
                                          idUsuario: idUsuario,
                                          idPropiedad: idPropiedad),
                                      Text(
                                        "Crear Reservacion",
                                        style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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
              icon: FaIcon(FontAwesomeIcons.arrowLeft),
              iconSize: MediaQuery.of(context).size.width * 0.07),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'RESERVACIONES',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
          child: IconButton(
              onPressed: () {
                getReservations();
              },
              icon: Icon(Icons.refresh_outlined, color: Colors.white),
              iconSize: MediaQuery.of(context).size.width * 0.07),
        )
      ],
    );
  }

  Widget contentReservaciones() {
    return Container(
      //decoration: BoxDecoration(color: Colors.green),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(color: Colors.white10),
                    child: ListView.builder(
                        itemCount: reservaciones.length,
                        itemBuilder: (BuildContext context, int index) {
                          final reservacion = reservaciones[index];
                          final idReservacion = reservacion['Id'].toString();

                          final name =
                              reservacion['Facility']['Name'] as String;
                          final image = reservacion['Facility']['Image'];

                          final fechaReservacion =
                              reservacion['DateStart'] as String;
                          final date = DateTime.parse(fechaReservacion);
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(date);

                          final time = DateTime.parse(fechaReservacion);
                          final formattedHour =
                              DateFormat('HH:mm').format(time);

                          final fechaTerminacion =
                              reservacion['DateFinish'] as String;
                          final timeT = DateTime.parse(fechaTerminacion);
                          final formattedHourT =
                              DateFormat('HH:mm').format(timeT);

                          final descripcion =
                              reservacion['Description'] as String;
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                      top: MediaQuery.of(context).size.width *
                                          0.03,
                                      right: MediaQuery.of(context).size.width *
                                          0.05,
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.00),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color.fromARGB(68, 0, 12, 52)),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            "$name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Helvetica',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.008,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  decoration: BoxDecoration(
                                                      //color: Colors.red
                                                      ),
                                                  child: Image.network(image),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  decoration: BoxDecoration(
                                                      //color: Colors.amber
                                                      ),
                                                  child: Column(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                            "$formattedDate",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.035)),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              "De: $formattedHour",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Helvetica',
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.035)),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.02,
                                                          ),
                                                          Text(
                                                              "hasta: $formattedHourT",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Helvetica',
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.035))
                                                        ],
                                                      ),
                                                      Center(
                                                        child: Text(
                                                            "$descripcion",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.035)),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
