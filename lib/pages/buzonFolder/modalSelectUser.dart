import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectUserModal extends StatefulWidget {
  final int idUsuario;
  final int idAsociacion;
  
  const SelectUserModal({
    Key? key,
    required this.idUsuario,
    required this.idAsociacion,
  }) : super(key: key);

  @override
  _SelectUserModalState createState() => _SelectUserModalState();
}

class _SelectUserModalState extends State<SelectUserModal> {
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    print("inicial");
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    print("obteniendo usuarios");
    final url = Uri.parse('https://appaltea.azurewebsites.net/api/Mobile/GetUsersVigilant');
    final headers = {"Content-Type": "application/x-www-form-urlencoded"};
    final body = {
      "idUser": widget.idUsuario.toString(),
      "AssociationId": widget.idAsociacion.toString(),
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          usuarios = jsonResponse['Data'] ?? [];
          print(usuarios);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
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
                  backgroundColor: Color.fromARGB(255, 243, 243, 243),
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
                                color: Color.fromARGB(255, 159, 159, 159),
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
                                          size: 20,
                                          color:
                                              Color.fromARGB(255, 160, 58, 251),
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
                                    "SELECCIONA A TU SOCIO ss",
                                    style: TextStyle(
                                        color: Color(0xFF011D45),
                                        fontSize: 12,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                          child: ListView.builder(
                            itemCount: usuarios.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(usuarios[index]['Name']),
                              );
                            },
                          ),
                        ),
                      ]),
                    );
                  }),
                );
              });
        },
        child: Text("Mensaje a socio",
            style: TextStyle(
                fontFamily: 'Helvetica', fontWeight: FontWeight.bold)),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    34), // Ajusta el radio de borde para redondear el botón
              ),
            ),
            minimumSize: MaterialStateProperty.all<Size>(Size(150, 30)),
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 160, 58, 251),
            )),
      ),
    );
  }
}
