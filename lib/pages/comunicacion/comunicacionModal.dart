import 'package:flutter/material.dart';
import '../avisosMenu/avisosWidget.dart';
import '../buzonFolder/buzonWidget.dart';
import '../votaciones/votacionesWidget.dart';

class comunicacionModal extends StatefulWidget {
  @override
  _comunicacionModalState createState() => _comunicacionModalState();
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;
  const comunicacionModal(
      {Key? key,
      required this.responseJson,
      required this.idUsuario,
      required this.idPropiedad,
      required this.AccessCode})
      : super(key: key);
}

class _comunicacionModalState extends State<comunicacionModal> {
  bool isFinished = false;
  bool deslizado = false;
  @override
  Widget build(BuildContext context) {
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final responseJson = widget.responseJson;
    final _accessCode = widget.AccessCode;
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      //color: Colors.amber
                      ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.6,
                            left: MediaQuery.of(context).size.height * 0.0),
                        //izquierda,arriba,derecha,abajo
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(186, 243, 243, 243),
                            borderRadius: BorderRadius.all(Radius.circular(33)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              print("avisos");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => avisosPage(
                                          responseJson: responseJson,
                                          idUsuario: _idUsario,
                                          idPropiedad: _idPropiedad,
                                        )),
                              );
                            },
                            icon: Icon(Icons.volume_down),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.60,
                            left: MediaQuery.of(context).size.width * 0.04),
                        child: Text(
                          'Avisos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      //color: Colors.red
                      ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: MediaQuery.of(context).size.width * 0.1),
                        //izquierda,arriba,derecha,abajo
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(186, 243, 243, 243),
                            borderRadius: BorderRadius.all(Radius.circular(33)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              print("buzón");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => buzonPage(
                                          responseJson: responseJson,
                                          idUsuario: _idUsario,
                                          idPropiedad: _idPropiedad,
                                        )),
                              );
                            },
                            icon: Icon(Icons.email),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: MediaQuery.of(context).size.width * 0.04),
                        child: Text(
                          'Buzón',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        //color: Colors.green
                        ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                              left: MediaQuery.of(context).size.height * 0.11),
                          //izquierda,arriba,derecha,abajo
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(186, 243, 243, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                print("votaciones");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => votacionesPage(
                                            responseJson: responseJson,
                                            idUsuario: _idUsario,
                                            idPropiedad: _idPropiedad,
                                          )),
                                );
                              },
                              icon: Icon(Icons.check_box),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: MediaQuery.of(context).size.width * 0.04,
                          ),
                          child: Text(
                            'Votaciones/ Encuestas',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                Container(
                  decoration: BoxDecoration(
                      //color: Colors.grey
                      ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.08),
                      child: IconButton(
                          color: Color.fromARGB(186, 243, 243, 243),
                          iconSize: 60,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel_outlined)),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    ));
    /*return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 500.0, 0.0, 0.0),
                          //izquierda,arriba,derecha,abajo
                          child: Co
                                
                                  color: C
                                  borderRadius:
                                      BorderRadius.all(Radius
                                  
                                  ild: ElevatedButton(
                                  onPressed: () {
                                print("avisos");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.transparent,
                              ),
                              child: Image.asset(
                                'assets/images/AVISOS.png',
                                width: 57,
                                height: 57,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 500.0, 0.0, 0.0),
                          child: Text(
                            'Avisos',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      child: Row(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              25.0, 10.0, 0.0, 0.0),
                          //izquierda,arriba,derecha,abajo
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(0, 243, 243, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                print("buzón");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.transparent,
                              ),
                              
                                      'a
                                      width: 57,
                                      height: 57,
                                    ),
                                  ),
                                )
                              ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 10.0, 0.0, 0.0),
                          child: Text(
                            'Buzón',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )),
                  Positioned(
                      child: Row(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              70.0, 5.0, 0.0, 0.0),
                          //izquierda,arriba,derecha,abajo
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(0, 243, 243, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                print("votaciones");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.transparent,
                              ),
                              child: Image.asset(
                                'assets/images/VOTACIONES.png',
                                width: 57,
                                height: 57,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 10.0, 0.0, 0.0),
                          child: Te
                              
                                  style:
                                ),
                                
                                
                                
                              
                        Center(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 0.0),
                      child: IconButton(
                          color: Color.fromARGB(186, 243, 243, 243),
                          iconSize: 60,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel_outlined)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );*/
  }

  Widget btnAvisos() {
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final responseJson = widget.responseJson;
    return Container(
      child: Row(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 500.0, 0.0, 0.0),
              //izquierda,arriba,derecha,abajo
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(0, 243, 243, 243),
                  borderRadius: BorderRadius.all(Radius.circular(33)),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print("avisos");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => avisosPage(
                                  responseJson: responseJson,
                                  idUsuario: _idUsario,
                                  idPropiedad: _idPropiedad,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Image.asset(
                    'assets/images/AVISOS.png',
                    width: 57,
                    height: 57,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 500.0, 0.0, 0.0),
              child: Text(
                'Avisos',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget btnBuzon() {
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final responseJson = widget.responseJson;
    return Container(
      child: Positioned(
          child: Row(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(25.0, 10.0, 0.0, 0.0),
              //izquierda,arriba,derecha,abajo
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(0, 243, 243, 243),
                  borderRadius: BorderRadius.all(Radius.circular(33)),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print("buzón");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => buzonPage(
                                responseJson: responseJson,
                                idUsuario: _idUsario,
                                idPropiedad: _idPropiedad,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Image.asset(
                    'assets/images/BUZÓN.png',
                    width: 57,
                    height: 57,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
              child: Text(
                'Buzón',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget btnVotaciones() {
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final responseJson = widget.responseJson;
    return Container(
      child: Positioned(
          child: Row(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(70.0, 5.0, 0.0, 0.0),
              //izquierda,arriba,derecha,abajo
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(0, 243, 243, 243),
                  borderRadius: BorderRadius.all(Radius.circular(33)),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print("votaciones");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => votacionesPage(
                                responseJson: responseJson,
                                idUsuario: _idUsario,
                                idPropiedad: _idPropiedad,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Image.asset(
                    'assets/images/VOTACIONES.png',
                    width: 57,
                    height: 57,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
              child: Text(
                'Votaciones',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      )),
    );
  }
}
