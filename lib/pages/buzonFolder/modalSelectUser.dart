import 'dart:convert';
import 'package:flutter/material.dart';

class SelectUserModal extends StatefulWidget {
  final idUsuario;
  final idAsociacion;
  const SelectUserModal({
    Key? key,
    required this.idUsuario,
    required this.idAsociacion,
  });
  @override
  _SelectUserModalState createState() => _SelectUserModalState();
}

class _SelectUserModalState extends State<SelectUserModal> {



  @override
  void initState() {
    super.initState();
    
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
                                    "SELECCIONA A TU SOCIO",
                                    style: TextStyle(
                                        color: Color(0xFF011D45),
                                        fontSize: 12,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          child: Column(
                            children: [
                              const Text("data"),
                            ],
                          ),
                        )
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
