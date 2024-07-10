import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spacesclub/pages/votaciones/registrarVotacionModal.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_util.dart';

class elegirVotacionesModal extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const elegirVotacionesModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });

  @override
  _elegirVotacionesModal createState() => _elegirVotacionesModal();
}

class _elegirVotacionesModal extends State<elegirVotacionesModal> {
  late String idUser;
  late String associationId = '';
  late String titulo;
  late String descripcion;
  late String fecha;
  late String propertyId;
  late String fechaLimite;
  late bool registroVotacion;
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
      // La solicitud fue exitosa, analiza la respuesta JSON
      print('Entro a la Api de voting');
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

    return Container(
        child: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 1,
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.0,
                  left: MediaQuery.of(context).size.width * 0.0,
                  top: MediaQuery.of(context).size.width * 0.0,
                  bottom: MediaQuery.of(context).size.width * 0.05,
                ),
                decoration: BoxDecoration(color: Colors.white10),
                child: ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (BuildContext context, int index) {
                      final votacion = news[index];
                      final idVotacion = votacion['Id'].toString();
                      final titulo = votacion['Title'] as String;
                      final fecha = votacion['RegisterDate'] as String;
                      final estatus = votacion['Status'] as String;
                      final descripcion = votacion['Description'] as String;
                      final fechaLimite = votacion['LimitDate'] as String;
                      final parsedDate = DateTime.parse(fechaLimite);
                      final formattedDate =
                          DateFormat('dd/MM/yyyy').format(parsedDate);
                      final parsedDateRegister = DateTime.parse(fecha);
                      final formattedDateRegister =
                          DateFormat('dd/MM/yyyy').format(parsedDateRegister);
                      List<Widget> opcionesWidgets = [];
                      final listaOpciones =
                          votacion['OptionsList'] as List<dynamic>;

                      registroVotacion = false;
                      if (estatus == 'Active') if (registroVotacion == false)
                        return Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.05,
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      right: MediaQuery.of(context).size.width *
                                          0.0,
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        '$formattedDateRegister',
                                        style: TextStyle(
                                            fontFamily: 'Helvetica, Oblique',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 0, 50, 158)),
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
                                      right: MediaQuery.of(context).size.width *
                                          0.04,
                                      left: MediaQuery.of(context).size.width *
                                          0.0,
                                    ),
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        '$formattedDate',
                                        style: TextStyle(
                                            fontFamily: 'Helvetica, Oblique',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 255, 38, 38)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$titulo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: listaOpciones.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final option = listaOpciones[index];
                                    final opcionId = option['Id'].toString();
                                    final opcionTexto =
                                        option['Option'] as String?;
                                    final opcionDescripcion =
                                        option['Description'] as String?;
                                    final opcionPercentVote =
                                        option['PercentVote'] as double?;
                                    final opcionImagen =
                                        option['Image'] as String?;
                                    return ListTile(
                                      subtitle: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                            ),
                                          ),
                                          registrarVotacionPage(
                                            responseJson: responseJson,
                                            idUsuario: _idUsuario,
                                            idPropiedad: _idPropiedad,
                                            titulo: titulo,
                                            opcionTexto: opcionTexto,
                                            idVotacion: idVotacion,
                                            opcionId: opcionId,
                                            estatus: estatus,
                                            registroVotacion: registroVotacion,
                                            onVotacionSuccess: () {
                                              setState(() {
                                                registroVotacion = true;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                            ],
                          ),
                        );
                    }))));
  }
}
