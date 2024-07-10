import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DeleteReservacionModal extends StatefulWidget {
  final idCodigo;
  final responseJson;
  final idUsuario;
  final idPropiedad;
  //final idAssociation;
  const DeleteReservacionModal({
    Key? key,
    required this.idCodigo,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    //required this.idAssociation
  });
  @override
  _DeleteReservacionModal createState() => _DeleteReservacionModal();
}

class _DeleteReservacionModal extends State<DeleteReservacionModal> {
  late String idUser;
  late String idAssociation;
  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteReservation() async {
    final url = 'https://appaltea.azurewebsites.net/api/Mobile/DeleteCodeUser/';
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();

    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();

    final codeId = widget.idCodigo;

    Map<String, String> data = {'idUser': idUser, 'CodeId': codeId.toString()};

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: data,
    );
    if (response.statusCode == 200) {
      // La solicitud fue exitosa, analiza la respuesta JSON
      print('Entro a la Api de Reservaciones');
      final parsedJson = json.decode(response.body);
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
    return Container(
        child: Column(
      children: [
        IconButton(
          iconSize: MediaQuery.of(context).size.width * 0.06,
          onPressed: () {
            print("Se presiono nuevo aviso");
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
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 1,
                          child: SingleChildScrollView(
                            child: Container(
                              width: 5000,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(104, 1, 29, 69),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(27),
                                            topRight: Radius.circular(27))),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.cancel_outlined,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  color: Color.fromARGB(
                                                      255, 0, 236, 205),
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(2.0, 2.0),
                                                      blurRadius: 3.0,
                                                      color: Color.fromARGB(
                                                          255, 68, 68, 68),
                                                    ),
                                                  ]),
                                              iconSize: 30,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "¿Deseas eliminar este codigo?",
                                            style: TextStyle(
                                                color: Color(0xFF2CFFE2),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035,
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.08,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: TextButton(
                                                  child: Text("Cancelar",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035)),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.12,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.08,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: TextButton(
                                                  child: Text("Confirmar",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035)),
                                                  onPressed: () async {
                                                    deleteReservation();
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ));
                    }),
                  );
                });
          },
          icon: Icon(Icons.disabled_by_default_outlined),
        ),
      ],
    ));
  }
}
