import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class contentComents extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final idUser;
  final name;
  final lastName;
  final street;
  final number;
  final content;
  final image;
  final List<dynamic> messages;

  const contentComents(
      {Key? key,
      required this.responseJson,
      required this.idUsuario,
      required this.idPropiedad,
      required this.name,
      required this.lastName,
      required this.street,
      required this.number,
      required this.content,
      required this.image,
      required this.messages,
      required this.idUser});
  @override
  _contentComents createState() => _contentComents();
}

class _contentComents extends State<contentComents> {
  late String idUser;
  late String propertyId;
  late String commenBuzon;
  late String idUser2;

  String selectedText2 = '';
  final String apiSaveComments =
      "https://appaltea.azurewebsites.net/api/Mobile/SaveReplayCommmentboxUser/";

  Future<String> enviarComment() async {
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();
    //PROPIEDAD
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    propertyId = data1['Id'].toString();
    commenBuzon = selectedText2.toString();

    Map<String, String> data = {
      'idUser': idUser,
      'PropertyId': propertyId,
      'CommentboxId': idUser2,
      'Comment': commenBuzon,
    };

    final response = await http.post(Uri.parse(apiSaveComments),
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
    String user = widget.name;
    String lastName = widget.lastName;
    String street = widget.street;
    int numExt = widget.number;
    String content = widget.content;
    final image = widget.image;
    final List<dynamic> messages = widget.messages;
    String idUser3 = widget.idUser;

    return Container(
        decoration: BoxDecoration(
            //color: Colors.blue
            ),
        child: Column(
          children: [
            IconButton(
                onPressed: () {
                  print("Se presiono nuevo aviso");
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Color.fromARGB(255, 0, 12, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                27.0), // Bordes redondeados
                          ),
                          child: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.64,
                              width: MediaQuery.of(context).size.width * 1,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.bottomCenter,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
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
                                                  icon: Icon(
                                                      Icons.cancel_outlined,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                      color: Color.fromARGB(
                                                          255, 0, 236, 205),
                                                      shadows: [
                                                        Shadow(
                                                          offset:
                                                              Offset(2.0, 2.0),
                                                          blurRadius: 3.0,
                                                          color: Color.fromARGB(
                                                              255, 68, 68, 68),
                                                        ),
                                                      ]),
                                                  iconSize: 30,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  //color: Colors.white
                                                  ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            1,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color:
                                                                Color.fromARGB(
                                                                    105,
                                                                    254,
                                                                    254,
                                                                    255)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start, // Alineación del contenido al inicio (izquierda)
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.008,
                                                                left: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.08,
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start, // Alineación del contenido al inicio (izquierda)
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.08,
                                                                        height: MediaQuery.of(context).size.width *
                                                                            0.08,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          child:
                                                                              Image.network(
                                                                            image,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.02,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start, // Alineación del contenido al inicio (izquierda)
                                                                        children: [
                                                                          Text(
                                                                              '$user $lastName'),
                                                                          Text(
                                                                            '$street #$numExt',
                                                                            style:
                                                                                TextStyle(fontFamily: 'Helvetica', fontSize: MediaQuery.of(context).size.width * 0.03),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.1),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.01),
                                                                  Container(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.05,
                                                                        child:
                                                                            Text(
                                                                          '$content',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Helvetica',
                                                                              fontSize: MediaQuery.of(context).size.width * 0.03),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Text("Comentarios", style: TextStyle(
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context).size.width*0.04
                                            ))
                                          ],
                                        )),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.27,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      105, 254, 254, 255)),
                                              child: ListView.builder(
                                                  itemCount: messages.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final message =
                                                        messages[index];
                                                    final content =
                                                        message['Content']
                                                            as String;
                                                    print("$message");
                                                    return Container(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                          top: MediaQuery.of(context).size.height*0.01
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                                          ),
                                                          child:  Align(
                                                            alignment: Alignment.center,
                                                            child: Padding(padding: EdgeInsets.only(
                                                              right: MediaQuery.of(context).size.width*0.04,
                                                              left: MediaQuery.of(context).size.width*0.04
                                                            ),child: Text("$content"),),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height*0.01,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.85, // Establece el ancho deseado
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.035, // Establece la altura deseada
                                        padding: EdgeInsets.only(),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            TextField(
                                              //controller: textFieldEnviarComment,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedText2 = value;
                                                  idUser2 = idUser3;
                                                  print("$idUser3");
                                                });
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color.fromARGB(
                                                    105,
                                                    254,
                                                    254,
                                                    255), // Cambia el color de fondo aquí
                                                hintText:
                                                    'Escribe una respuesta',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0), // Ajusta el radio del borde aquí
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    right:
                                                        40), // Ajusta el espaciado del texto dentro del TextField
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: IconButton(
                                                onPressed: () {
                                                  enviarComment();
                                                },
                                                icon: Icon(Icons.send),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      });
                },
                icon: Icon(
                  Icons.remove_red_eye_sharp,
                  size: MediaQuery.of(context).size.width * 0.06,
                )),
          ],
        ));
  }
}
