import 'package:flutter/material.dart';
import 'package:spacesclub/pages/seguridad_home_page/view_SOS.dart';
import 'package:spacesclub/pages/seguridad_home_page/view_vecino_vigilante.dart';
import 'package:spacesclub/pages/seguridad_home_page/view_vigilante.dart';

class seguridadModal extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const seguridadModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  }) : super(key: key);
  @override
  _seguridadModalState createState() => _seguridadModalState();
}

class _seguridadModalState extends State<seguridadModal> {
  get responseJson => null;

  @override
  Widget build(BuildContext context) {
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
                          left: MediaQuery.of(context).size.width * 0.25),
                      child: Text(
                        'SOS',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.35,
                        left: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(186, 243, 243, 243),
                          borderRadius: BorderRadius.all(Radius.circular(33)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => viewSOS(
                                responseJson: responseJson,
                              ),
                            ));
                            print('Hola Mundo');
                          },
                          icon: Icon(Icons.remove_red_eye_sharp),
                        ),
                      ),
                    )
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
                          left: MediaQuery.of(context).size.width * 0.55),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        left: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      //color: Colors.green
                      ),
                  child: Row()),
              Container(
                decoration: BoxDecoration(
                    // color: Colors.grey
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
    ]));
  }

  Widget buttonVecinoVigilante() {
    final responseJson = widget.responseJson;
    final idPropiedad = widget.idPropiedad;
    final idUsuario = widget.idUsuario;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 360.0, 5.0, 0.0),
            child: Text(
              'Vecino vigilante',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 345.0, 110.0, 0.0),
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
                        builder: (context) => viewVecinoVigilante(
                          responseJson: responseJson,
                          idPropiedad: idPropiedad,
                          idUsuario: idUsuario,
                        ),
                      ));
                },
                icon: Image.asset('assets/images/SEGURIDAD1.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonSOS() {
    final responseJson = widget.responseJson;
    String selectedText = " ";
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
            child: Text(
              'S.O.S',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 65.0, 0.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(186, 243, 243, 243),
                borderRadius: BorderRadius.all(Radius.circular(33)),
              ),
              child: IconButton(
                onPressed: () {
                  // Agregue aquí la lógica que se ejecutará cuando se presione el botón
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewSOS(
                          responseJson: responseJson,
                        ),
                      ));
                },
                icon: Image.asset('assets/images/SEGURIDAD2.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonVigilante() {
    final responseJson = widget.responseJson;
    final idPropiedad = widget.idPropiedad;
    final idUsuario = widget.idUsuario;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
            child: Text(
              'Vigilante',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 32.0, 0.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(186, 243, 243, 243),
                borderRadius: BorderRadius.all(Radius.circular(33)),
              ),
              child: IconButton(
                onPressed: () {
                  // Agregue aquí la lógica que se ejecutará cuando se presione el botón
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewVigilante(
                          responseJson: responseJson,
                          idPropiedad: idPropiedad,
                          idUsuario: idUsuario,
                        ),
                      ));
                },
                icon: Image.asset('assets/images/SEGURIDAD3.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
