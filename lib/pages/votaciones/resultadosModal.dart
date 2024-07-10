import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_util.dart';

class resultadosPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const resultadosPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _resultadosPage createState() => _resultadosPage();
}

class _resultadosPage extends State<resultadosPage> {
  late String associationId = '';
  late String estatus2;
  late String idAssociation;

  List<dynamic> news = [];

  @override
  void initState() {
    super.initState();
    getVote();
  }

  Future<void> getVote() async {
    final url = 'https://appaltea.azurewebsites.net/api/Mobile/GetUserVoting/';
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    final idProperty = data1['Id'].toString();
    final type = data1['Type'].toString();
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();
    final body = {
      'idUser': widget.idUsuario,
      'AssociationId': idAssociation,
      'Owner': 'false'
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      print(body);
      // La solicitud fue exitosa, analiza la respuesta JSON
      print(
          'Entro a la Api de voting'); // este es el print que sale al principio
      final parsedJson = json.decode(response.body);
      print(parsedJson);
      final dataList = parsedJson['Data'] as List<dynamic>;
      final newsList = json.decode(dataList[0]['Value']) as List<dynamic>;

      setState(() {
        news = newsList;
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
    final _idUsuario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    // TODO: implement build

    return Container(
        height: MediaQuery.of(context).size.height * 0.53,
        width: MediaQuery.of(context).size.width * 1,
        child: Container(
          child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (BuildContext contex, int index) {
                final votacion = news[index];
                final idVotacion = votacion['Id'].toString();
                final titulo = votacion['Title'] as String;
                final fecha = votacion['RegisterDate'] as String;
                final estatus = votacion['Status'] as String;
                final descripcion = votacion['Description'] as String;
                final fechaLimite = votacion['LimitDate'] as String;
                final numVotos = votacion['TotalVotes'].toString();
                List<Widget> opcionesWidgets = [];
                final listaOpciones = votacion['OptionsList'] as List<dynamic>;

                final parsedDate = DateTime.parse(fechaLimite);
                final formattedDate =
                    DateFormat('dd/MM/yyyy').format(parsedDate);

                if (estatus == 'Active') {
                  // ignore: unnecessary_statements
                  estatus2 = 'Votacion abierta';
                } else {
                  estatus2 = 'Votacion cerrada';
                }

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03,
                            left: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              '$estatus2',
                              style: TextStyle(
                                  fontFamily: 'Helvetica, Oblique',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 38, 38)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03,
                            left: MediaQuery.of(context).size.width * 0.0,
                          ),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              '$titulo',
                              style: TextStyle(
                                  fontFamily: 'Helvetica, bold',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 36, 112)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.04,
                            left: MediaQuery.of(context).size.width * 0.0,
                          ),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              '$formattedDate',
                              style: TextStyle(
                                  fontFamily: 'Helvetica, Oblique',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 50, 158)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listaOpciones.length,
                        itemBuilder: (BuildContext context, int index) {
                          final option = listaOpciones[index];
                          final opcionId = option['Id'].toString();
                          final opcionTexto = option['Option'] as String?;
                          final opcionDescripcion =
                              option['Description'] as String?;
                          final opcionPercentVote =
                              option['PercentVote'] as double?;
                          final porcentaje;
                          porcentaje = (opcionPercentVote! / 10);
                          int porcentajeInt = porcentaje.toInt();
                          final opcionImagen = option['Image'] as String?;
                          return ListTile(
                            subtitle: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width * 0.0,
                                    bottom:
                                        MediaQuery.of(context).size.width * 0.0,
                                    right:
                                        MediaQuery.of(context).size.width * 0.0,
                                    left:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '$opcionTexto',
                                        style: TextStyle(
                                          fontFamily: 'Helvetica, Oblique',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 0, 50, 158),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.02,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.0,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.0,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      child: StepProgressIndicator(
                                        totalSteps: 10,
                                        currentStep: porcentajeInt,
                                        size: 20,
                                        roundedEdges: Radius.circular(10),
                                        selectedGradientColor: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF011D45),
                                            Color(0xFF011D45)
                                          ],
                                        ),
                                        unselectedGradientColor: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromARGB(255, 177, 176, 176),
                                            Color.fromARGB(255, 177, 176, 176)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.05,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.0,
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            '$opcionPercentVote%',
                                            style: TextStyle(
                                              fontFamily: 'Helvetica, Oblique',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 50, 158),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03,
                            left: MediaQuery.of(context).size.width * 0.08,
                          ),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Abstinencia: 99%',
                              style: TextStyle(
                                  fontFamily: 'Helvetica, Oblique',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 50, 158)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03,
                            left: MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Votos: $numVotos',
                              style: TextStyle(
                                  fontFamily: 'Helvetica, bold',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 36, 112)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ));
  }
}
