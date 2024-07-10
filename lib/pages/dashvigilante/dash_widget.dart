import 'package:spacesclub/pages/subtoken/subtoken_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/misPagosModal.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../buzonFolder1/buzonWidget.dart';
import '../profile/profile_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '../../components/propiedadesSlide.dart';
import 'package:flutter/services.dart';
import '../addtoken/addtoken_widget.dart';
import '../notificaciones/notificaciones_widget.dart';
import 'package:spacesclub/pages/codigoqr/codigoqr_widget.dart';
import 'package:spacesclub/pages/codigoqr/sos_widget.dart';
import 'package:spacesclub/pages/codigoqr/sos1_widget.dart';

class IniciovigWidget extends StatefulWidget {
  final responseJson;
  const IniciovigWidget({Key? key, required this.responseJson})
      : super(key: key);

  @override
  _IniciovigWidgetState createState() => _IniciovigWidgetState();
}

class _IniciovigWidgetState extends State<IniciovigWidget>
    with SingleTickerProviderStateMixin {
  //para boton de fraccionamiento
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;
  // final mandarJson = responseJson;
  //-------
  bool mostrarContenedor = false;
  bool _isRotated = true;
  late String _fraccionamiento;
  late String _nombreCasa = '';
  late String _nombreFracc = '';
  late String _nombreUsuario;
  late String _tu;
  late String _imagenProfile;
  late String _roleUser;
  late String _imagenPropiedad;
  late String _idPropiedad;
  late String _idUsuario;
  late String _accessCode;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool autoLogin = false;
  bool useBiometrics = false;
  late String _secondImage;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();

    getValoresPropiedad();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    print('que se va a imprimir');
    print(widget.responseJson['Data'][1]['Value'][1]);
    String _usuario = widget.responseJson['Data'][0]['Value'];
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    String _assocation = widget.responseJson['Data'][1]['Value'][12];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    Map<String, dynamic> data0 = jsonDecode(_usuario);
    //Map<String, dynamic> dataAsociation = jsonDecode(_assocation);
    _secondImage = data['Assocation']['Image'].toString();
    _nombreUsuario = (data0['Name'] + ' ' + data0['LastName']);
    _tu = 'Vigilante';
    _imagenProfile = data0['ImageProfile'];
    if (data['Type'] == 'Neighbor') {
      _roleUser = 'Vigilante';
    } else {
      _roleUser = 'Vigilante'; // O asignar un valor por defecto si es necesario
    }

    _idUsuario = data0['Id'].toString();
    _accessCode = data['AccessCode'].toString();
    //_imagenPropiedad = dataAsociation['Image'];
  }

  void _onAutoLoginChanged(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoLogin', newValue);
    setState(() {
      autoLogin = newValue;
    });
  }

  void _onBiometricChanged(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useBiometrics', newValue);
    setState(() {
      useBiometrics = newValue;
    });
  }

  Future<void> getValoresPropiedad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreCasa = prefs.getString('nombrePropiedad').toString();
      _idPropiedad = prefs.getString('idPropiedad').toString();
      _nombreFracc = prefs.getString('nombreFracc').toString();
    });
  }

  void _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoLogin =
          prefs.getBool('autoLogin') ?? true; // Valor predeterminado como true
      useBiometrics = prefs.getBool('useBiometrics') ??
          false; // Valor predeterminado como true
    });
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  //String fraccionamiento = widget.responseJson['Message'];

  @override
  Widget build(BuildContext context) {
    // Establecer el color de la barra de notificaciones en blanco
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));
    final responseJson = widget.responseJson;

    return Container(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Builder(
          builder: (context) => Container(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      height: MediaQuery.of(context).size.height * 1.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.asset(
                            'assets/images/FONDO_GENERAL.jpg',
                          ).image,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02),
                                child: IconButton(
                                  color: Color.fromRGBO(44, 255, 226, 1),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: Icon(
                                    Icons.menu_open,
                                    color: Colors.white,
                                    size:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ),
                              ),
                              txtAppBar(),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.02),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Notificaciones()),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.notifications_none_outlined,
                                    color: Colors.white,
                                    size:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.41,
                              height: MediaQuery.of(context).size.width * 0.41,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(_imagenProfile),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileWidget(
                                            responseJson: widget.responseJson,
                                            idUsuario: _idUsuario,
                                          ),
                                        ),
                                      );
                                    },
                                    customBorder: CircleBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            _nombreUsuario,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                          ),
                          Text(
                            _roleUser,
                            style: TextStyle(
                              color: Color.fromRGBO(50, 104, 181, 1),
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Center(
                            child: Stack(
                              children: [],
                            ),
                          ),
                          menuCircular(),

                          // The rest of your widget code
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customSizedFloatingActionButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: MediaQuery.of(context).size.width *
              0.003, // Escala del botón flotante (ajusta según tus necesidades)
          child: FloatingActionButton(
            onPressed: onPressed,
            child: child,
            backgroundColor: Color(0x4D011D45),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ), // Espacio entre el botón y el texto
      ],
    );
  }

  Widget txtAppBar() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centra los elementos horizontalmente
      crossAxisAlignment:
          CrossAxisAlignment.center, // Centra los elementos verticalmente
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(44, 255, 227, 0), // Color del borde
              width: 2.0, // Grosor del borde
            ),
            borderRadius: BorderRadius.circular(
                50.0), // Ajusta el radio de los bordes redondeados
          ),
          child: Container(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor:
                        Color.fromRGBO(1, 29, 69, 1).withOpacity(0.5),
                    builder: (BuildContext context) {
                      bool isFinished = false;
                      return Container(
                        //de aqui pa abajo es el contenido del bodal
                        height: MediaQuery.of(context).size.height * 1,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(1, 29, 69, 1).withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              ListTile(),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.41,
                                  height:
                                      MediaQuery.of(context).size.width * 0.41,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Container(
                                      width: 150.0,
                                      height: 150.0,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        _imagenProfile,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _nombreUsuario,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily:
                                        'Helvetica', // Cambiado a Helvetica
                                    color: Colors.white,
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.5, // 80% del ancho de la pantalla
                                height: MediaQuery.of(context).size.height *
                                    0.07, // 20% de la altura de la pantalla
                                child: Column(
                                  children: [
                                    Text(
                                      _nombreCasa,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Text(
                                        _nombreFracc,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: propiedadesSlide(
                                    responseJson: widget.responseJson),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    FFButtonWidget(
                                      onPressed: () async {
                                        // Acciones del botón NUEVA PROPIEDAD
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddtokenWidget(
                                              idUsuario: _idUsuario,
                                            ),
                                          ),
                                        );
                                      },
                                      text: 'NUEVA PROPIEDAD',
                                      options: FFButtonOptions(
                                        width: 150.0,
                                        height: 40.0,
                                        color: Colors.transparent,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily:
                                                  'Poppins', // Cambia a 'Helvetica' si así lo deseas
                                              color: Colors.white,
                                              fontSize: 17.0,
                                            ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(44, 255, 226, 1),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(34.0),
                                      ),
                                    ),
                                    Spacer(), // Este widget ocupa todo el espacio disponible
                                    FFButtonWidget(
                                      onPressed: () async {
                                        // Acciones del botón SUBTOKEN
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SubtokenWidget(
                                              idUsuario: _idUsuario,
                                            ),
                                          ),
                                        );
                                      },
                                      text: 'SUBTOKEN',
                                      options: FFButtonOptions(
                                        width: 150.0,
                                        height: 40.0,
                                        color: Colors.transparent,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily:
                                                  'Poppins', // Cambia a 'Helvetica' si así lo deseas
                                              color: Colors.white,
                                              fontSize: 17.0,
                                            ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(44, 255, 226, 1),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(34.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    // buttonEntrar
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                  text: 'CERRAR SESION',
                                  options: FFButtonOptions(
                                    width: 150.0,
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color.fromRGBO(44, 255, 226, 1),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 17.0,
                                        ),
                                    borderSide: BorderSide(
                                      //rgba(44, 255, 226, 1)
                                      color: Color.fromRGBO(44, 255, 226, 1),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(34.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: 200), // ancho máximo disponible aquí
                  child: Text(
                    _nombreCasa,
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          color: Color.fromRGBO(44, 255, 226, 1),
                          fontSize: 15.0,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget menuCircular() {
    final responseJson = widget.responseJson;
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.02,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.42,
      decoration: BoxDecoration(
        color: Color(0xFF4D4D4D),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('assets/images/m.png'),
        ),
      ),
      child: Stack(
        alignment: Alignment.center, // Alinea el contenido al centro del Stack
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.45,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AlertHistoryScreen()),
                );
              },
              child: Text(
                'S.O.S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      MediaQuery.of(context).size.width * 0.04, // Responsivo
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.18,
            child: Row(
              mainAxisSize: MainAxisSize.min, // Minimiza el tamaño del Row
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AlertHistoryScreen3()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02),
                    width: MediaQuery.of(context).size.width *
                        0.3, // Ancho al 50% del ancho de la pantalla
                    height: MediaQuery.of(context).size.height *
                        0.1, // Altura al 10% del alto de la pantalla
                    alignment: Alignment
                        .center, // Alinea el texto al centro del contenedor
                    decoration: BoxDecoration(
                      color:
                          Colors.transparent, // Color de fondo del contenedor
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
                    ),
                    child: Text(
                      'VECINO VIGILANTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width *
                            0.035, // Responsivo
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.30),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AccessControlScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: Text(
                      'ACCESOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width *
                            0.035, // Responsivo
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.06,
            left: MediaQuery.of(context).size.width * 0.35,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buzonPage(
                            responseJson: responseJson,
                            idUsuario: _idUsuario,
                            idPropiedad: _idPropiedad,
                          )),
                );
              },
              child: Text(
                'REPORTE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      MediaQuery.of(context).size.width * 0.04, // Responsivo
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
