import 'package:flutter/material.dart';
import 'package:spacesclub/pages/soporteTecnico/induccionApp2.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class introduccionPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const introduccionPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _introduccionPage createState() => _introduccionPage();
}

class _introduccionPage extends State<introduccionPage> {
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
                        contentinduccion(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0,
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

  contentinduccion() {
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
          child: Image.asset('assets/images/ILL1.png'),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.0,
            bottom: MediaQuery.of(context).size.width * 0.03,
          ),
          child: Container(
            child: Text(
              'BIENVENIDO A TU GUÍA PERSONAL',
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
            right: MediaQuery.of(context).size.width * 0.06,
            left: MediaQuery.of(context).size.width * 0.06,
            top: MediaQuery.of(context).size.width * 0.03,
            bottom: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Container(
            child: Text(
              'Aquí te enseñamos paso a paso el correcto uso de '
              'esta plataforma móvil, veras lo sencillo que es...',
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
            right: MediaQuery.of(context).size.width * 0.11,
            left: MediaQuery.of(context).size.width * 0.11,
            top: MediaQuery.of(context).size.width * 0.25,
            bottom: MediaQuery.of(context).size.width * 0.01,
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => induccion2Page(
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
