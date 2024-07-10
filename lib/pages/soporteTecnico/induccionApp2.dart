import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'induccionApp3.dart';

class induccion2Page extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const induccion2Page({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _induccion2Page createState() => _induccion2Page();
}

class _induccion2Page extends State<induccion2Page> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Scaffold(
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
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Column(
                      children: [
                        contentinduccion2(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  contentinduccion2() {
    final responseJson = widget.responseJson;
    final _idUsuario = widget.idUsuario;
    final _idPropiedad = widget.idPropiedad;
    return Container(
      child: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width * 0.65,
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.0,
            left: MediaQuery.of(context).size.width * 0.0,
            top: MediaQuery.of(context).size.width * 0.25,
            bottom: MediaQuery.of(context).size.width * 0.0,
          ),
          child: Image.asset('assets/images/ILL2.png'),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.01,
            bottom: MediaQuery.of(context).size.width * 0.03,
          ),
          child: Container(
            child: Text(
              'BRINDA ACCESO SEGURO',
              style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 50, 120, 1)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.11,
            left: MediaQuery.of(context).size.width * 0.11,
            top: MediaQuery.of(context).size.width * 0.03,
            bottom: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Container(
            child: Text(
              'Realiza acceso dinámico, para tus visitas, equipos de '
              'trabajo, amigos y familiares de manera instantánea...',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 14,
                  color: Color.fromRGBO(0, 0, 0, 1)),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.06,
            left: MediaQuery.of(context).size.width * 0.06,
            top: MediaQuery.of(context).size.width * 0.25,
            bottom: MediaQuery.of(context).size.width * 0.01,
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => induccion3Page(
                          responseJson: responseJson,
                          idUsuario: _idUsuario,
                          idPropiedad: _idPropiedad,
                        )),
              );
            },
            child: Text("SIGUIENTE",
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                )),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(130, 36)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF011D45))),
          ),
        )
      ]),
    );
  }
}
