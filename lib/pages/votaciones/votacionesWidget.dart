import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spacesclub/pages/votaciones/resultadosModal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../pages/inicio/inicio_widget.dart';
import 'elegirVotacionModal.dart';

class votacionesPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const votacionesPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _votacionesPage createState() => _votacionesPage();
}

class _votacionesPage extends State<votacionesPage> {
  String? currentButton;
  late String _accessCode;
  late String _idUsuario;

  @override
  void initState() {
    super.initState();
    currentButton = 'resultados';
    String _usuario = widget.responseJson['Data'][0]['Value'];
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    Map<String, dynamic> data0 = jsonDecode(_usuario);
    _accessCode = data['AccessCode'].toString();
    _idUsuario = data0['Id'].toString();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    bool isChecked = false;
    final responseJson = widget.responseJson;
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    return Container(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BotonFlotante(
        responseJson: responseJson,
        accessCode: _accessCode,
        idPropiedad: _idPropiedad,
        idUsuario: _idUsuario,
      ),
      bottomNavigationBar: barranavegacion(
        responseJson: responseJson,
        idPropiedad: _idPropiedad,
        idUsuario: _idUsario,
        accessCode: _accessCode,
      ),
      body: Builder(
          builder: (context) => SafeArea(
                  child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        height: MediaQuery.of(context).size.height * 1.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.asset(
                              'assets/images/FONDO_GENERAL.jpg',
                            ).image,
                          ),
                        ),
                        child: Column(
                          children: [
                            buttonsBackHome(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.16),
                            votacionesPage(),
                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                  checkColor:
                                      Colors.white, // color of tick Mark
                                  activeColor:
                                      Colors.green, // color of the checkbox
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Si el texto es presionado, también se cambia el estado del checkbox
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  },
                                  child: Text(
                                    'Todas mis acciones',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 6, 8,
                                          163), // Cambia el color del texto aquí
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (currentButton == 'resultados')
                              resultadosPage(
                                responseJson: responseJson,
                                idUsuario: _idUsario,
                                idPropiedad: _idPropiedad,
                              ),
                            if (currentButton == 'votar')
                              elegirVotacionesModal(
                                responseJson: responseJson,
                                idUsuario: _idUsario,
                                idPropiedad: _idPropiedad,
                              ),
                            /*
                            ----Esta función es para administración----
                            if (currentButton == 'votar')
                              votacionesModal(
                                responseJson: responseJson,
                                idUsuario: _idUsario,
                                idPropiedad: _idPropiedad,
                              ),*/
                            if (currentButton == 'votar')
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    ));
  }

  buttonsBackHome() {
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
            'VOTACIONES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
          child: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InicioWidget(
                    responseJson: widget.responseJson,
                  ),
                ),
              );
            },
            icon: Image.asset('assets/images/ICONOP.png'),
          ),
        )
      ],
    );
  }

  Widget votacionesPage() {
    return Container(
        child: Column(children: [
      Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  currentButton = 'votar';
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VOTAR',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentButton == 'votar'
                          ? Color(0xFF011D45)
                          : Color(0xFF011D45),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: currentButton == 'votar'
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
                  currentButton = 'resultados';
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'RESULTADOS',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentButton == 'resultados'
                          ? Color(0xFF011D45)
                          : Color(0xFF011D45),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: currentButton == 'resultados'
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
        child: Column(children: [
          if (currentButton == 'resultados') Container(),
          if (currentButton == 'votar') Container(),
        ]),
      ),
    ]));
  }
}
