import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../inicio/inicio_widget.dart';

class avisosComents extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final String idUser2;
  final String title;
  final String content;
  final String image;
  final String formattedDate;
  final List<dynamic> comments;

  const avisosComents({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.idUser2,
    required this.title,
    required this.content,
    required this.image,
    required this.formattedDate,
    required this.comments,
  }) : super(key: key);

  @override
  _avisosComments createState() => _avisosComments();
}

class _avisosComments extends State<avisosComents> {
  late String idUser;
  late String idUser2 = widget.idUser2;
  late String propertyId;

  final _saveCommentController = TextEditingController();

  String apiSaveComments =
      "https://appaltea.azurewebsites.net/api/Mobile/SaveCommmentInNew/";

  Future<void> saveComments() async {
    String? comment = _saveCommentController.text.trim();
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    propertyId = data1['Id'].toString();

    Map<String, String> data = {
      'idUser': idUser,
      'PropertyId': propertyId,
      'NewAssociationId': idUser2,
      'Comment': comment,
    };

    final response = await http.post(Uri.parse(apiSaveComments),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['Message'] == 'Created') {
        print("Comment created");
      } else {
        print('Failed to create comment');
      }
    } else {
      throw Exception('Error in POST request');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));
    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) => SafeArea(
            child: Container(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  Image.asset('assets/images/FONDO_GENERAL.jpg')
                                      .image,
                            ),
                          ),
                          child: Column(
                            children: [
                              buttonsBackHome(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.16),
                              contentComments(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white, // Fondo blanco para el TextField
                      child: txtEnviarComments(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contentComments() {
    final String title = widget.title;
    final String content = widget.content;
    final String formattedDate = widget.formattedDate;
    final String imageUrl = widget.image;

    Widget imageWidget = imageUrl.isEmpty
        ? Image.asset("assets/images/main.png")
        : CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/main.png"),
            fadeInDuration: Duration(milliseconds: 500),
            fit: BoxFit.cover,
            memCacheHeight: 300,
            memCacheWidth: 300,
          );

    return Container(
      child: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: imageWidget,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          "$formattedDate",
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 10,
            color: Colors.black,
          ),
        ),
        Text(
          "$content",
          style: TextStyle(
            color: Color(0xFF011D45),
            fontFamily: 'Helvetica',
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.36,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: contentComents2(),
          ),
        ),
      ]),
    );
  }

  Widget txtEnviarComments() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: _saveCommentController,
            style: TextStyle(
              color: Colors.black, // Color del texto en negro
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(68, 0, 12, 52),
              hintText: 'Escribe tu comentario',
              hintStyle: TextStyle(
                color: Colors.black, // Color del hint en negro
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(34.0),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              onPressed: () {
                saveComments();
                _saveCommentController.clear();
              },
              icon: Icon(Icons.send, color: Colors.black), // Icono negro
            ),
          ),
        ],
      ),
    );
  }

  Widget contentComents2() {
    final List<dynamic> comments = widget.comments;
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.0),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.27,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white10),
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final comment = comments[index];
                        final content = comment['Content'];
                        final date = comment['RegisterDate'] as String;
                        final parsedDate = DateTime.parse(date);
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(parsedDate);

                        String name = '';
                        String lastName = '';
                        String imagePerfil = '';
                        String street = '';
                        String numExt = '';
                        dynamic owner = comment['Owner'];

                        if (owner is Map<String, dynamic>) {
                          dynamic neighbor = owner['Neighbor'];
                          dynamic property = owner['Property'];

                          if (property is Map<String, dynamic>) {
                            street = property['Street'].toString();
                            numExt = property['NumExt'].toString();
                          }

                          if (neighbor is Map<String, dynamic>) {
                            name = neighbor['Name'].toString();
                            lastName = neighbor['LastName'].toString();
                            imagePerfil = neighbor['ImageProfile'];
                          }
                        }

                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05,
                                  top: MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Color.fromARGB(68, 0, 12, 52),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              0.06,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.network(
                                                      imagePerfil,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('$name $lastName'),
                                                    Text(
                                                      '$street #$numExt',
                                                      style: TextStyle(
                                                        fontFamily: 'Helvetica',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                            Text(
                                              '$content',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03),
                                            Text(
                                              "$formattedDate",
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                                fontFamily: 'Helvetica',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonsBackHome() {
    final responseJson = widget.responseJson;
    String title = widget.title;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
          child: IconButton(
            color: Color.fromRGBO(255, 255, 255, 1),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            iconSize: MediaQuery.of(context).size.width * 0.1,
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            '$title',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InicioWidget(responseJson: responseJson)),
              );
            },
            icon: Image.asset('assets/images/ICONOP.png'),
            iconSize: MediaQuery.of(context).size.width * 0.1,
          ),
        ),
      ],
    );
  }
}
