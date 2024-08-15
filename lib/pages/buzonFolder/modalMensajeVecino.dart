import 'dart:convert';
import 'package:flutter/material.dart';

class mensajeModal extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const mensajeModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _mensajeModalState createState() => _mensajeModalState();
}

class _mensajeModalState extends State<mensajeModal> {

  late Map<String, dynamic> association;

  @override
  void initState() {
    super.initState();
    // Parse the responseJson to access the Association property
    var lastPropertyJson = widget.responseJson['Data'].firstWhere((element) => element['Name'] == 'LastProperty')['Value'];
    Map<String, dynamic> lastPropertyMap = jsonDecode(lastPropertyJson);
    association = lastPropertyMap['Assocation'];
    
  }

  @override
  Widget build(BuildContext context) {
    print("abajo bro");
   print(association['Id']);
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
                                    "MENSAJE A SOCIO",
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
                              Icon(
                                Icons.circle,
                                size: 70,
                              ),
                              Text(
                                "Nombre del usuario",
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF011D45)),
                              ),
                              Text(
                                "Propiedad",
                                style: TextStyle(
                                    fontSize: 10, color: Color(0xFF011D45)),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.008,
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      TextField(
                                        //controller: textFieldEnviarComment,
                                        onChanged: (value) {
                                          setState(() {
                                            //selectedtext = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color.fromARGB(68, 0, 12,
                                              52), // Cambia el color de fondo aquí
                                          hintText: 'Escribe una respuesta',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                12.0), // Ajusta el radio del borde aquí
                                          ),
                                          // Ajusta el espaciado del texto dentro del TextField
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.006),
                              Text(
                                "Tu respuesta solo sera visible para el socio seleccionado",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: 'Helvetica',
                                    color: Color(0xFF4D4D4D)),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Color.fromARGB(173, 65, 85, 240),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(27.0), // Bordes redondeados
                                        ),
                                        child: StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState) {
                                          return Container(
                                            height: MediaQuery.of(context).size.height * 0.85,
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
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 160, 58, 251),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              34), // Ajusta el radio de borde para redondear el botón
                                        ),
                                      )),
                                  child: Text("Seleccionar Socio"))
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
