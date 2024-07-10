import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class quejaModal extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const quejaModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _quejaModalState createState() => _quejaModalState();
}

class _quejaModalState extends State<quejaModal> {
  String? currentButton;
  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/SaveMessageNeighbor/';
  late String idUser;
  late String propertyId;
  late TextEditingController textFieldEnviarComment;

  late String selectedtext;

  List<dynamic> buzon = [];

  @override
  void initState() {
    super.initState();
    idUser = '';
    propertyId = '';
    textFieldEnviarComment = TextEditingController();
    selectedtext = '';
  }

  Future<String> enviarQoS() async {
    //USUARIO
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();
    //PROPIEDAD
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    propertyId = data1['Id'].toString();
    String comment2 = selectedtext.toString();

    Map<String, String> data = {
      'idUser': idUser,
      'PropertyId': propertyId,
      'NeighborPropertyId': propertyId,
      'NeighborId': idUser,
      'Comment': comment2,
      'TypeMessage': 'Comment',
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var codeApiResponse = jsonDecode(response.body);
      print('hello buey');
      print(idUser);
      print(propertyId);
      return codeApiResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
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
                      height: MediaQuery.of(context).size.height * 0.45,
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
                                      iconSize: 30,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "QUEJA O SUGERENCIA",
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
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                // Definir la altura deseada aquí
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    SingleChildScrollView(
                                      reverse:
                                          true, // Invierte el orden del texto para que se escriba hacia abajo
                                      child: TextField(
                                        controller: textFieldEnviarComment,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedtext = value;
                                          });
                                        },
                                        maxLines:
                                            null, // Permite que el TextField tenga múltiples líneas
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor:
                                              Color.fromARGB(68, 0, 12, 52),
                                          hintText: 'Escribe una respuesta',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08), // Ajusta la altura aquí
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.006),
                              Text(
                                "Tu respuesta solo sera visible para el vecino seleccionado",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: 'Helvetica',
                                    color: Color(0xFF4D4D4D)),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              ElevatedButton(
                                  onPressed: () {
                                    enviarQoS();
                                    textFieldEnviarComment.clear();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFF011D45)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20), // Ajusta el radio de borde para redondear el botón
                                        ),
                                      )),
                                  child: Text("ENVIAR"))
                            ],
                          ),
                        )
                      ]),
                    );
                  }),
                );
              });
        },
        child: Text("Queja o sugerencia",
            style: TextStyle(
                fontFamily: 'Helvetica', fontWeight: FontWeight.bold)),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    34), // Ajusta el radio de borde para redondear el botón
              ),
            ),
            minimumSize: MaterialStateProperty.all<Size>(Size(173, 36)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF011D45))),
      ),
    );
  }
}
