import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacesclub/pages/buzonFolder/contentCommentsModal.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_util.dart';
import 'modalMensajeVecino.dart';
import 'modalQueja.dart';

class contentBuzon extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const contentBuzon({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _contentBuzon createState() => _contentBuzon();
}

class _contentBuzon extends State<contentBuzon> {
  final String apiSaveComments =
      "https://appaltea.azurewebsites.net/api/Mobile/SaveReplayCommmentboxUser/";
  String? currentButton;
  late String idUser;
  late String propertyId;
  late String neighborPropertyId;
  late String neighborId;
  late String comment;
  late String typeMessage;
  late TextEditingController textFieldEnviarComment;
  late String commenBuzon;

  String selectedtext = '';
  String selectedText2 = '';
  late String idAssociation;

  late String idUser2;

  List<dynamic> buzon = [];

  @override
  void initState() {
    super.initState();
    currentButton = 'No leído';
    idUser = '';
    propertyId = '';
    neighborPropertyId = '';
    neighborId = '';
    comment = '';
    typeMessage = '';
    getCommentBuzon();
    textFieldEnviarComment = TextEditingController();
    commenBuzon = '';
  }

  Future<void> getCommentBuzon() async {
    final url = "https://appaltea.azurewebsites.net/api/Mobile/GetCommentBox/";
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    final idProperty = data1['Id'].toString();
    final type = data1['Type'].toString();
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();
    final body = {
      'idProperty': idProperty,
      'AssociationId': idAssociation,
      'UserType': type
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
      print('Entro a la Api de buzon');
      final parsedJson = json.decode(response.body);
      print(parsedJson);
      print("$idProperty, $idAssociation, $type");
      final dataList = parsedJson['Data'] as List<dynamic>;
      final buzonList = json.decode(dataList[0]['Value']) as List<dynamic>;
      print("Esto traE: $dataList");

      setState(() {
        buzon = buzonList;
      });
      //codigoacceso

      // setText();
    } else {
      // La solicitud falló
      print('No entro a la Api');
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  Future<String> enviarComment() async {
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();
    //PROPIEDAD
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    propertyId = data1['Id'].toString();
    commenBuzon = selectedText2.toString();

    print("eset $idUser2");
    print("esetw$idUser");
    print("Este es: $commenBuzon");

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
    return Container(
      child: Column(
        children: [
          buttonsBackHome(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.16),
          content()
        ],
      ),
    );
  }

  Widget content() {
    final responseJson = widget.responseJson;
    final idUsuario = widget.idUsuario;
    final idPropiedad = widget.idPropiedad;
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    currentButton = 'No leído';
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'NO LEIDO',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: currentButton == 'No leído'
                            ? Color(0xFF011D45)
                            : Color(0xFF011D45),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: currentButton == 'No leído'
                          ? Color(0xFF011D45)
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    currentButton = 'Leído';
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'LEIDO',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: currentButton == 'Leído'
                            ? Color(0xFF011D45)
                            : Color(0xFF011D45),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: currentButton == 'Leído'
                          ? Color(0xFF011D45)
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          child: Column(
            children: [
              if (currentButton == 'No leído')
                SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(color: Colors.white10),
                      child: ListView.builder(
                          itemCount: buzon.length,
                          itemBuilder: (BuildContext context, int index) {
                            final noticia = buzon[index];
                            final idUser = noticia['Id'].toString();
                            final content = noticia['Content'] as String;
                            final newDate = noticia['CommentDate'] as String;
                            final read = noticia['Status'] as String;
                            final parsedDate = DateTime.parse(newDate);
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(parsedDate);

                            final user =
                                noticia['User']['Neighbor']['Name'] as String;
                            final lastName = noticia['User']['Neighbor']
                                ['LastName'] as String;
                            final image =
                                noticia['User']['Neighbor']['ImageProfile'];

                            final street =
                                noticia['User']['Property']['Street'] as String;
                            final numExt =
                                noticia['User']['Property']['NumExt'] as int;

                            print("El mensaje es: $read");
                            print("$user");
                            print("$idUser");
                            print("$content");

                            if (read == 'NotRead')
                              return Container(
                                  child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        top: MediaQuery.of(context).size.width *
                                            0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.12,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color:
                                                Color.fromARGB(68, 0, 12, 52)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Alineación del contenido al inicio (izquierda)
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.008,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start, // Alineación del contenido al inicio (izquierda)
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Image.network(
                                                            image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start, // Alineación del contenido al inicio (izquierda)
                                                        children: [
                                                          Text(
                                                              '$user $lastName'),
                                                          Text(
                                                            '$street #$numExt',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.01),
                                                        child: Text(
                                                            "$formattedDate",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                  Container(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                        child: Text(
                                                          '$content',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Helvetica',
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.03),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7, // Establece el ancho deseado
                                      height: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.035, // Establece la altura deseada
                                      padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                selectedText2 = value;
                                                idUser2 = idUser;
                                                print("$idUser");
                                              });
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color.fromARGB(
                                                  68,
                                                  0,
                                                  12,
                                                  52), // Cambia el color de fondo aquí
                                              hintText: 'Escribe una respuesta',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
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
                                                //txtMessageComment.clear();
                                              },
                                              icon: Icon(Icons.send),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                                  //child: Text('Elemento $index'),
                                  );
                            else {
                              return Container();
                            }
                          })),
                ),
              if (currentButton == 'Leído')
                SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(color: Colors.white10),
                      child: ListView.builder(
                          itemCount: buzon.length,
                          itemBuilder: (BuildContext context, int index) {
                            final noticia = buzon[index];
                            final idUser = noticia['Id'].toString();
                            final content = noticia['Content'] as String;
                            final newDate = noticia['CommentDate'] as String;
                            final read = noticia['Status'] as String;
                            final parsedDate = DateTime.parse(newDate);
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(parsedDate);

                            final user =
                                noticia['User']['Neighbor']['Name'] as String;
                            final lastName = noticia['User']['Neighbor']
                                ['LastName'] as String;
                            final image =
                                noticia['User']['Neighbor']['ImageProfile'];

                            final street =
                                noticia['User']['Property']['Street'] as String;
                            final numExt =
                                noticia['User']['Property']['NumExt'] as int;

                            final messages =
                                noticia['Messages'] as List<dynamic>;

                            print("El mensaje es: $read");
                            print("$user");
                            print("$idUser");
                            print("$content");
                            print("$noticia");

                            if (read == 'Read')
                              return Container(
                                  child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        top: MediaQuery.of(context).size.width *
                                            0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color:
                                                Color.fromARGB(68, 0, 12, 52)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Alineación del contenido al inicio (izquierda)
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.008,
                                                left: MediaQuery.of(context)
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
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Image.network(
                                                            image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start, // Alineación del contenido al inicio (izquierda)
                                                        children: [
                                                          Text(
                                                              '$user $lastName'),
                                                          Text(
                                                            '$street #$numExt',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.01),
                                                        child: Text(
                                                            "$formattedDate",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.66,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Text(
                                                                '$content',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Helvetica',
                                                                    fontSize: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.03),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        contentComents(
                                                            responseJson:
                                                                responseJson,
                                                            idUsuario:
                                                                idUsuario,
                                                            idUser: idUser,
                                                            idPropiedad:
                                                                idPropiedad,
                                                            lastName: lastName,
                                                            street: street,
                                                            number: numExt,
                                                            name: user,
                                                            content: content,
                                                            image: image,
                                                            messages: messages)
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              )
                                  //child: Text('Elemento $index'),
                                  );
                            else {
                              return Container();
                            }
                          })),
                ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mensajeModal(
                responseJson: responseJson,
                idUsuario: idUsuario,
                idPropiedad: idPropiedad,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              quejaModal(
                responseJson: responseJson,
                idUsuario: idUsuario,
                idPropiedad: idPropiedad,
              )
            ],
          ),
        )
      ],
    ));
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
              color: Color.fromRGBO(255, 255, 255, 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'BUZÓN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
          child: IconButton(
            onPressed: () {
              getCommentBuzon();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
