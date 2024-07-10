export 'tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../inicio/inicio_widget.dart';
import 'dart:async';
import 'dart:convert';

class tag_Widget extends StatefulWidget {
  @override
  _tag_WidgetState createState() => _tag_WidgetState();
  final responseJson;
  final idUsuario;
  final idPropiedad;

  const tag_Widget({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  }) : super(key: key);
}

class _tag_WidgetState extends State<tag_Widget> {
  List<dynamic> tags = [];
  void initState() {
    super.initState();
    apiCall();
  }

  Future<void> apiCall() async {
    print('ejecutanndo tags');
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetTagsProperty/';
    final String property = widget.idPropiedad;

    final body = {
      'PropertyId': property,
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
      print('Entro a la Api de tags');
      final parsedJson = json.decode(response.body);
      print(parsedJson);
      final dataList = parsedJson['Data'] as List<dynamic>;
      final tagsList = json.decode(dataList[0]['Value']) as List<dynamic>;

      setState(() {
        tags = tagsList;
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));
    final responseJson = widget.responseJson;
    //print(responseJson);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/FONDO_GENERAL.jpg',
              ), // Ruta de la imagen
              fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                    child: IconButton(
                        //rgba(44, 255, 226, 1)
                        color: Color.fromRGBO(44, 255, 226, 1),
                        onPressed: () {
                          print('hello');
                          Navigator.of(context).pop();
                        },
                        icon: FaIcon(FontAwesomeIcons.arrowLeft)),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'TAGS',
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InicioWidget(responseJson: responseJson)),
                        );
                      },
                      icon: Image.asset('assets/images/ICONOP.png'),
                    ),
                  )
                ],
              ),
              // Aquí puedes agregar otros wid gets o elementos
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 180.0, 0.0, 15.0),
                child: Text(
                  'TAGS REGISTRADOS',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 1, 49),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tags.length,
                  itemBuilder: (BuildContext context, int index) {
                    final tag = tags[index];
                    final code = tag['Code'] as String;
                    final nombreCarro = tag['CarBrand'] as String;
                    final CarPlates = tag['CarPlates'] as String;
                    final CarInfo = tag['CarInfo'] as String;

                    return Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                      child: Container(
                        //width: 60, //MediaQuery.of(context).size.width - 55,
                        // height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          color: Color.fromARGB(71, 1, 29, 69),
                        ),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  child: Container(
                                    //alignment: Alignment.center,
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(33),
                                    ),
                                    // Ajustar el padding a cero
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        print('activar/desactivar $index');
                                      },
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 55,
                                      ),
                                    ),
                                  )),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    70.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  '$nombreCarro\n $CarPlates',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 6, 3, 49),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Helvetica'),
                                ),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Flexible(
                                    child: Text(
                                      '$CarInfo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 6, 3, 49),
                                        fontSize: 13,
                                        fontFamily: 'Helvetica',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Ultima actividad: ',
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 6, 3, 49),
                                              fontSize: 13,
                                              fontFamily: 'Helvetica',
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                                height:
                                                    10), // Espaciado entre líneas
                                          ),
                                          TextSpan(
                                            text: 'Sin actividad',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 6, 3, 49),
                                                fontSize: 13,
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        print(
                                            'boton activar notificaciones $index');
                                      },
                                      icon: Icon(
                                        Icons.notifications_active_outlined,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );

                    /* return ListTile(
                      title: Text('Tag $index'),
                      subtitle: Text('Code: $code'),
                    );*/
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
