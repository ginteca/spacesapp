import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacesclub/pages/reservaciones/reservaWidget.dart';
import 'package:spacesclub/pages/reservaciones/reservacionDate.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
export 'accesosModal.dart';
import '../pages/control_acceso/control_acceso_widget.dart';
import '../pages/mi_acceso/mi_acceso_widget.dart';
import '../pages/tag/tag_widget.dart';

class accesosModal extends StatefulWidget {
  @override
  _accesosModalState createState() => _accesosModalState();
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;
  const accesosModal(
      {Key? key,
      required this.responseJson,
      required this.idUsuario,
      required this.idPropiedad,
      required this.AccessCode})
      : super(key: key);
}

class _accesosModalState extends State<accesosModal> {
  bool isFinished = false;
  bool deslizado = false;
  @override
  Widget build(BuildContext context) {
    final _idUsario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    final responseJson = widget.responseJson;
    final _accessCode = widget.AccessCode;

    return Container(
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
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
                          top: MediaQuery.of(context).size.height * 0.35,
                          left: MediaQuery.of(context).size.width * 0.45,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(186, 243, 243, 243),
                            borderRadius: BorderRadius.all(Radius.circular(33)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ControlAccesoWidget(
                                    responseJson: responseJson,
                                    idUsuario: _idUsario,
                                    idPropiedad: _idPropiedad,
                                  ),
                                ),
                              );
                              // context.pushNamed('miAcceso');
                            },
                            icon: Icon(Icons.security),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.35,
                            left: MediaQuery.of(context).size.width * 0.02),
                        child: Text(
                          'Acceso Controlado',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      //color: Colors.amber
                      ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                          left: MediaQuery.of(context).size.width * 0.35,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(186, 243, 243, 243),
                            borderRadius: BorderRadius.all(Radius.circular(33)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MiAccesoWidget(
                                    responseJson: responseJson,
                                    idUsuario: _idUsario,
                                    idPropiedad: _idPropiedad,
                                    AccessCode: _accessCode,
                                  ),
                                ),
                              );
                              // context.pushNamed('miAcceso');
                            },
                            icon: Icon(Icons.qr_code),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: MediaQuery.of(context).size.width * 0.02),
                        child: Text(
                          'Mi acceso',
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
                          left: MediaQuery.of(context).size.width * 0.2,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(186, 243, 243, 243),
                            borderRadius: BorderRadius.all(Radius.circular(33)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Agregue aquí la lógica que se ejecutará cuando se presione el botón
                              print('boton Tag');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => tag_Widget(
                                    responseJson: responseJson,
                                    idUsuario: _idUsario,
                                    idPropiedad: _idPropiedad,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: MediaQuery.of(context).size.width * 0.02),
                        child: Text(
                          'Tag',
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
                            left: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(186, 243, 243, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReservationsScreen()),
                                );
                              },
                              icon: Icon(Icons.mobile_friendly),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: Text(
                            'Reservaciones',
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
                          top: MediaQuery.of(context).size.height * 0.3),
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
            )
          ],
        )
      ]),
    );

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
                              110.0, 345.0, 0.0, 0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(186, 243, 243, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MiAccesoWidget(
                                      responseJson: responseJson,
                                      idUsuario: _idUsario,
                                      idPropiedad: _idPropiedad,
                                      AccessCode: _accessCode,
                                    ),
                                  ),
                                );
                                // context.pushNamed('miAcceso');
                              },
                              icon: Icon(Icons.qr_code),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 360.0, 0.0, 0.0),
                          child: Text(
                            'Mi acceso',
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
                              65.0, 0.0, 0.0, 0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(186, 243, 243, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Agregue aquí la lógica que se ejecutará cuando se presione el botón
                                print('boton Tag');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => tag_Widget(
                                      responseJson: responseJson,
                                      idUsuario: _idUsario,
                                      idPropiedad: _idPropiedad,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Tag',
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
                              32.0, 10.0, 0.0, 0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(186, 243, 243, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                print('hola amigos');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ControlAccesoWidget(
                                      responseJson: responseJson,
                                      idUsuario: _idUsario,
                                      idPropiedad: _idPropiedad,
                                      
                                    ),
                                  ),
                                );
                                // Agregue aquí la lógica que se ejecutará cuando se presione el botón
                              },
                              icon: Icon(Icons.mobile_friendly),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Control de accesos',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )),
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 180.0, 0.0, 0.0),
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
}
