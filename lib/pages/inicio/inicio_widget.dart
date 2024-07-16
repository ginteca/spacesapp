import 'package:spacesclub/pages/avisosMenu/avisosWidget.dart';
import 'package:spacesclub/pages/soporteTecnico/soporteTecnicoWidget.dart';
import 'package:spacesclub/pages/subtoken/subtoken_widget.dart';
import 'package:spacesclub/pages/votaciones/votacionesWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../buzonFolder/buzonWidget.dart';
import '../comunicacion/comunicacionModal.dart';
import '../control_acceso/generaracceso.dart';
import '../inicio/carrito_widget.dart';
import '../mi_acceso/mi_acceso_widget.dart';
import '../mi_acceso/mi_cobro_widget.dart';
import '../profile/profile_widget.dart';
import '../seguridad_home_page/view_SOS.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'inicio_model.dart';
export 'inicio_model.dart';
import '../../components/propiedadesSlide.dart';
import 'package:flutter/services.dart';
import '../addtoken/addtoken_widget.dart';
import '../notificaciones/notificaciones_widget.dart';
import 'package:spacesclub/pages/reservaciones/reservaWidget.dart';

class InicioWidget extends StatefulWidget {
  final responseJson;
  const InicioWidget({Key? key, required this.responseJson}) : super(key: key);

  @override
  _InicioWidgetState createState() => _InicioWidgetState();
}

class _InicioWidgetState extends State<InicioWidget>
    with SingleTickerProviderStateMixin {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;
  bool mostrarContenedor = false;
  bool _isRotated = true;
  late InicioModel _model;
  late String _fraccionamiento;
  late String _nombreCasa = '';
  late String _nombreFracc = '';
  late String _nombreUsuario;
  late String _tu;
  late String _imagenProfile;
  late String _roleUser;
  late String _imagenPropiedad;
  late String _idPropiedad = '';
  late String _idUsuario;
  late String _accessCode;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool autoLogin = false;
  bool useBiometrics = false;

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

    _model = createModel(context, () => InicioModel());
    String _usuario = widget.responseJson['Data'][0]['Value'];
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    String _assocation = widget.responseJson['Data'][1]['Value'][12];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    Map<String, dynamic> data0 = jsonDecode(_usuario);

    _nombreUsuario = (data0['Name'] + ' ' + data0['LastName']);
    _tu = 'Socio';
    _imagenProfile = data0['ImageProfile'];
    if (data['Type'] == 'Neighbor') {
      _roleUser = 'Socio';
    } else {
      _roleUser = 'Socio';
    }

    _idUsuario = data0['Id'].toString();
    _accessCode = data['AccessCode'].toString();
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
      autoLogin = prefs.getBool('autoLogin') ?? true;
      useBiometrics = prefs.getBool('useBiometrics') ?? false;
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
       statusBarColor: Color.fromRGBO(3, 16, 145, 1),
     ));
    final responseJson = widget.responseJson;

    return Scaffold(
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
        idUsuario: _idUsuario,
        accessCode: _accessCode,
      ),
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      drawer: Drawer(child: btnMenuDrawer()),
      body: Builder(
        builder: (context) => Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset(
                'assets/images/FONDO_GENERAL.jpg',
              ).image,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.08),
                      child: IconButton(
                        color: Color.fromRGBO(44, 255, 226, 1),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          Icons.menu_open,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                    ),
                    txtAppBar(),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.08),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Notificaciones()),
                          );
                        },
                        icon: Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: MediaQuery.of(context).size.width * 0.41,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
                Text(
                  _roleUser,
                  style: TextStyle(
                    color: Color.fromRGBO(160, 58, 251, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      menuCircular(),
                      Charlybot2Widget(
                        responseJson: responseJson,
                        idUsuario: _idUsuario,
                        idPropiedad: _idPropiedad,
                        accessCode: _accessCode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnMenuDrawer() {
    final responseJson = widget.responseJson;
    return Container(
      color: Color.fromARGB(255, 3, 16, 145),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(),
          ListTile(
            leading: Container(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.12,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.network(
                _imagenProfile,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              _nombreUsuario,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.white),
          ListTile(
            leading: Icon(
              Icons.volume_up,
              color: Color.fromARGB(255, 255, 255, 255),
              size: MediaQuery.of(context).size.width * 0.08,
            ),
            title: Text(
              'Avisos',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => avisosPage(
                            responseJson: responseJson,
                            idUsuario: _idUsuario,
                            idPropiedad: _idPropiedad,
                          )));
            },
          ),
          Divider(color: Colors.white),
          ListTile(
            leading: Icon(
              Icons.mail,
              color: Color.fromARGB(255, 255, 255, 255),
              size: MediaQuery.of(context).size.width * 0.08,
            ),
            title: Text(
              'Buzon',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buzonPage(
                            responseJson: responseJson,
                            idUsuario: _idUsuario,
                            idPropiedad: _idPropiedad,
                          )));
            },
          ),
          Divider(color: Colors.white),
          ListTile(
            leading: Icon(
              Icons.check_box,
              color: Color.fromARGB(255, 255, 255, 255),
              size: MediaQuery.of(context).size.width * 0.08,
            ),
            title: Text(
              'Votaciones/Encuestas',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => votacionesPage(
                            responseJson: responseJson,
                            idUsuario: _idUsuario,
                            idPropiedad: _idPropiedad,
                          )));
            },
          ),
          Divider(color: Colors.white),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 255, 255, 255),
              size: MediaQuery.of(context).size.width * 0.08,
            ),
            title: Text(
              'Soporte tecnico',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => soportePage(
                            responseJson: responseJson,
                            idUsuario: _idUsuario,
                            idPropiedad: _idPropiedad,
                          )));
            },
          ),
          Divider(color: Colors.white),
          SwitchListTile(
            title: Text('Autenticación por Huella Digital',
                style: TextStyle(color: Colors.white)),
            value: useBiometrics,
            onChanged: (bool newValue) {
              setState(() {
                useBiometrics = newValue;
              });
              _onBiometricChanged(newValue);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FFButtonWidget(
              onPressed: () async {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              text: 'CERRAR SESION',
              options: FFButtonOptions(
                width: 150.0,
                height: 40.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Color.fromRGBO(160, 58, 251, 1),
                textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 17.0,
                    ),
                borderSide: BorderSide(
                  color: Color.fromRGBO(160, 58, 251, 1),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(34.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget txtAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(160, 58, 251, 0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(50.0),
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
                        Color.fromRGBO(160, 58, 251, 1).withOpacity(0.5),
                    builder: (BuildContext context) {
                      bool isFinished = false;
                      return Container(
                        height: MediaQuery.of(context).size.height,
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
                                    fontFamily: 'Helvetica',
                                    color: Colors.white,
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
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
                                      text: 'NUEVO CLUB',
                                      options: FFButtonOptions(
                                        width: 150.0,
                                        height: 40.0,
                                        color: Colors.transparent,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontSize: 17.0,
                                            ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(160, 58, 251, 1),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(34.0),
                                      ),
                                    ),
                                    Spacer(),
                                    FFButtonWidget(
                                      onPressed: () async {
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
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontSize: 17.0,
                                            ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(160, 58, 251, 1),
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
                                padding: const EdgeInsets.all(10.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
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
                                    color: Color.fromRGBO(160, 58, 251, 1),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 17.0,
                                        ),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(160, 58, 251, 1),
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
                  constraints: BoxConstraints(maxWidth: 200),
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
      child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              bottom: MediaQuery.of(context).size.height * 0.00),
          child: Stack(
            children: [
              Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.42,
                    decoration: BoxDecoration(
                      color: Color(0xFF4D4D4D),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: Image.asset(
                          'assets/images/MENU.png',
                        ).image,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.2,
                                  top: MediaQuery.of(context).size.height *
                                      0.03),
                              child: IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width * 0.18,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GenerarAccesoPage()),
                                  );
                                },
                                icon: Image.asset(
                                  'assets/images/1.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.18,
                                  top: MediaQuery.of(context).size.height *
                                      0.04),
                              child: IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width * 0.22,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => viewSOS(
                                      responseJson: responseJson,
                                    ),
                                  ));
                                },
                                icon: Image.asset(
                                  'assets/images/S.O.S.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.04,
                              left: MediaQuery.of(context).size.width * 0.1),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width * 0.15,
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      isScrollControlled: true,
                                      backgroundColor:
                                          Color.fromRGBO(1, 29, 69, 1)
                                              .withOpacity(0.7),
                                      builder: (BuildContext context) {
                                        bool isFinished = false;
                                        return Container(
                                          child: comunicacionModal(
                                            responseJson: responseJson,
                                            idUsuario: _idUsuario,
                                            idPropiedad: _idPropiedad,
                                            AccessCode: _accessCode,
                                          ),
                                        );
                                      });
                                },
                                icon: Image.asset(
                                  'assets/images/2.png',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.41),
                                child: IconButton(
                                  iconSize:
                                      MediaQuery.of(context).size.width * 0.15,
                                  onPressed: () {
                                    NuevoModalconserge(context);
                                  },
                                  icon: Image.asset(
                                    'assets/images/CONCIERGE.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              Positioned(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.31),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: MediaQuery.of(context).size.width * 0.12,
                          onPressed: () {
                            NuevoModaljugar(context);
                          },
                          icon: Icon(
                            Icons.sports_golf,
                            color: Color.fromARGB(180, 255, 255, 255),
                          ),
                        ),
                        SizedBox(height: 0.7),
                        Text(
                          'Jugar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.025,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class Charlybot2Widget extends StatelessWidget {
  final Map<String, dynamic> responseJson;
  final String idUsuario;
  final String idPropiedad;
  final String accessCode;

  const Charlybot2Widget({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.accessCode,
  }) : super(key: key);

  Widget _customSizedFloatingActionButton(
      {required VoidCallback onPressed, required Widget child}) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: child,
      backgroundColor: Color.fromARGB(255, 3, 16, 145),
      shape: CircleBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: _customSizedFloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MiAccesoWidget(
                        responseJson: responseJson,
                        idUsuario: idUsuario,
                        idPropiedad: idPropiedad,
                        AccessCode: accessCode,
                      ),
                    ));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: MediaQuery.of(context).size.width * 0.1,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class barranavegacion extends StatelessWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final accessCode;

  const barranavegacion({
    super.key,
    required this.responseJson,
    required this.idPropiedad,
    required this.idUsuario,
    required this.accessCode,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.width * 0.15,
        child: ClipRRect(
          child: BottomNavigationBar(
            backgroundColor: Color.fromARGB(183, 3, 15, 145),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/icr.png',
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                label: 'Reservaciones',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/CARRITO.png',
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                label: 'Carrito',
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReservationsScreen()),
                );
              }
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PantallaCarrito()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class BotonFlotante extends StatelessWidget {
  final Map<String, dynamic> responseJson;
  final String idUsuario;
  final String idPropiedad;
  final String accessCode;

  const BotonFlotante({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.accessCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 10.0),
      ),
      child: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 3, 16, 145),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MiCobroWidget(
              responseJson: responseJson,
              idUsuario: idUsuario,
              idPropiedad: idPropiedad,
              AccessCode: accessCode,
            ),
          ));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/4.png',
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.14,
            ),
          ],
        ),
      ),
    );
  }
}

NuevoModalconserge(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 800,
                color: Color.fromRGBO(183, 183, 183, 1),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                      child: Text(
                        'CONSERGE',
                        style: TextStyle(
                            color: Color.fromARGB(255, 160, 58, 251),
                            fontSize: 22),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 20.0),
                      child: Container(
                        child: Icon(
                          Icons.delivery_dining,
                          size: 75,
                          color: Color.fromARGB(255, 160, 58, 251),
                        ),
                      ),
                    ),
                    Text(
                      'PROXIMAMENTE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 160, 58, 251),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 15.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    Navigator.pop(context);
                    print('Entendido');
                  },
                  text: 'ENTENDIDO',
                  options: FFButtonOptions(
                    width: 150.0,
                    height: 40.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color.fromARGB(255, 160, 58, 251),
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 160, 58, 251),
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
}

NuevoModaljugar(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 800,
                color: Color.fromRGBO(127, 127, 127, 1),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                      child: Text(
                        'Jugar',
                        style: TextStyle(
                            color: Color.fromARGB(255, 160, 58, 251),
                            fontSize: 22),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 20.0),
                      child: Container(
                        child: Icon(
                          Icons.sports_golf,
                          size: 75,
                          color: Color.fromARGB(255, 160, 58, 251),
                        ),
                      ),
                    ),
                    Text(
                      'PROXIMAMENTE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 160, 58, 251),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 15.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    Navigator.pop(context);
                    print('Entendido');
                  },
                  text: 'ENTENDIDO',
                  options: FFButtonOptions(
                    width: 150.0,
                    height: 40.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color.fromARGB(255, 160, 58, 251),
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 160, 58, 251),
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
}
