import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class registrarVotacionPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final String titulo;
  final String? opcionTexto;
  final String idVotacion;
  final String opcionId;
  final String estatus;
  final bool registroVotacion;
  final VoidCallback onVotacionSuccess;
  final Future<void> Function() getVotacion;
  const registrarVotacionPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.titulo,
    required this.opcionTexto,
    required this.idVotacion,
    required this.opcionId,
    required this.estatus,
    required this.registroVotacion,
    required this.onVotacionSuccess,
    required this.getVotacion,
  });
  @override
  _registrarVotacionPage createState() => _registrarVotacionPage();
}

class _registrarVotacionPage extends State<registrarVotacionPage> {
  final url = 'https://appaltea.azurewebsites.net/api/Mobile/RegisterVoting/';
  late String idUser;
  late String propertyId;
  late String votingId;
  late String optionVoteId;
  late String estatus = '';

  void initState() {
    super.initState();
  }

  List<String> listId = [];

  Future<List<String>> getIdVotacionList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('idVotacionList') ?? [];
  }

  Future<void> addIdVotacion(String newIdVotacion) async {
  List<String> idVotacionList = await getIdVotacionList();
  idVotacionList.add(newIdVotacion);
  await saveIdVotacionList(idVotacionList);
}

  Future<void> saveIdVotacionList(List<String> idVotacionList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('idVotacionList', idVotacionList);
  }

  Future<String> registrarVotacion() async {
    final prefs = await SharedPreferences.getInstance();
    //Usuario
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();

    //Property
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    propertyId = data1['Id'].toString();
    String titulo = widget.titulo;
    String idVotacion = widget.idVotacion;
    String opcionId = widget.opcionId;

    Map<String, String> data = {
      'idUser': idUser,
      'PropertyId': propertyId,
      'VotingId': idVotacion,
      'OptionVoteId': opcionId
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      await addIdVotacion(idVotacion);
      await widget.getVotacion();
    // Imprimir la lista actualizada para verificar
    List<String> updatedList = await getIdVotacionList();
    print("asi quedo la lisya bro");
    print(updatedList);
      var jsonResponse = jsonDecode(response.body);
      print('hello buey');
      print(jsonResponse);
      print(propertyId);
      if (jsonResponse['Message'] == 'Created') {
        print("si quedo");
        await widget.getVotacion();
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
    String titulo = widget.titulo;
    String? opcionTexto = widget.opcionTexto;
    bool registroVot = widget.registroVotacion;

    // TODO: implement build
    return Container(
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Color.fromRGBO(44, 44, 44, 0).withOpacity(0.7),
              builder: (BuildContext context) {
                bool isFinished = false;
                return Dialog(
                  alignment: Alignment.center,
                  backgroundColor:
                      Color.fromRGBO(30, 59, 100, 0.086).withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(27.0), // Bordes redondeados
                  ),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(children: [
                        Container(
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
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$titulo",
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 20,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.03,
                            left: MediaQuery.of(context).size.width * 0.03,
                            top: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.08,
                          ),
                          child: Text(
                            '¿Estas seguro de votar por la opcion?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                            left: MediaQuery.of(context).size.width * 0.05,
                            top: MediaQuery.of(context).size.width * 0.0,
                            bottom: MediaQuery.of(context).size.width * 0.08,
                          ),
                          child: Text(
                            '$opcionTexto',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.0,
                            right: MediaQuery.of(context).size.width * 0.08,
                            left: MediaQuery.of(context).size.width * 0.08,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      registrarVotacion();
                                      setState(() {
                                        registroVot = true;
                                      });

                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Votar",
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(34),
                                          ),
                                        ),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(120, 38)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFF011D45))),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancelar",
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(34),
                                          ),
                                        ),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(120, 38)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFF011D45))),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                    );
                  }),
                ); //accesosModal();
              });
        },
        child: Text("$opcionTexto",
            style: TextStyle(
              fontFamily: 'Helvetica Neue, Bold',
              fontSize: 14,
            )),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    34), // Ajusta el radio de borde para redondear el botón
              ),
            ),
            minimumSize: MaterialStateProperty.all<Size>(Size(260, 44)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF011D45))),
      ),
    );
  }
}
