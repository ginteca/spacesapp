import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../pages/inicio/inicio_widget.dart';

class preguntasPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const preguntasPage({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _preguntasPage createState() => _preguntasPage();
}

class _preguntasPage extends State<preguntasPage> {
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
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            contentPreguntas(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
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
            'SOPORTE TÉCNICO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2.4,
              fontFamily: 'Helvetica Neue, Bold',
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
        ),
      ],
    );
  }

  contentPreguntas() {
    return Container(
      child: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.1,
          child: Image.asset('assets/images/preguntasFrecuentes.png'),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.08,
            left: MediaQuery.of(context).size.width * 0.08,
            bottom: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Container(
            child: Text(
              'PREGUNTAS FRECUENTES',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 12,
                  color: Color.fromRGBO(255, 255, 255, 1)),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.70,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: Container(
                    child: Text(
                      '¿Cómo genero un Subtoken?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      'Paso 1. Entrar al perfil de usuario, dónde se muestran los datos generales de la propiedad cargados previamente en el registro. \n En la parte inferior se encuentra un botón “SUBTOKENS DE ACCESO” Seleccionar el botón “ +SUBTOKEN”\n'
                      '\n'
                      'Paso 2. Se muestra una pantalla donde solicita ingresar una breve descripción del subtoken (está puede ser el nombre de la persona a la que  se le va a asignar dicho subtoken” \n Posteriormente debe seleccionar las funcionalidades que el usuario principal le permitirá al sub usuario.\n'
                      '\n'
                      'Paso 3. Seleccionar el botón de crear SUBTOKEN De esta manera se habrá creado un código alfanumérico que podrá ser compartido para poder registrarse en la aplicación.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      '¿Qué hago si olvide mi correo?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      'Ponerse en contacto a los números de soporte, un asesor se encargara de buscar el correo dentro de nuestra base de datos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(67, 66, 93, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      '¿Qué hago si olvide mi contraseña?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      'En el panel de inicio de sesión, dar click a la opción de “olvide mi contraseña” La reposición será enviada al correo electrónico con el que te registraste.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      '¿Como validar un pago?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.0,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      'La opción para validar pagos únicamente está asignada al perfil de finanzas o administrador. Los cuales podrán validar los pagos que los usuarios han subido anteriormente realizando los siguientes pasos \n'
                      '\n'
                      'Pasó 1. Seleccionar el residente usuario.\n'
                      '\n'
                      'Pasó 2. Seleccionar el el periodo de pago y la fecha'
                      '\n'
                      'Pasó.3. Corroborar los datos de dicho pago y seleccionar el botón subir pago que se encuentra en la parte inferior derecha.\n'
                      '\n'
                      'De esta manera se irá cargando los pagos al balance los ingresos según el mes que corresponda donde podrá ser analizado en el área de finanzas públicas.\n'
                      '\n'
                      'Por otro lado al usuario se le enviará una notificación del pago realizado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      '¿La app no me deja acceder?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.0,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      'En caso de no tener acceso a su cuenta, reportarlo inmediatamente al administrador de tu fraccionamiento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      'No recibo notificaciones…',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(67, 66, 93, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.08,
                    left: MediaQuery.of(context).size.width * 0.08,
                    bottom: MediaQuery.of(context).size.width * 0.0,
                    top: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: Container(
                    child: Text(
                      'Verifica que tú sesión no este abierta en más de 3 dispositivos. En caso de persistir el problema, comunícate a los números de soporte técnico.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
