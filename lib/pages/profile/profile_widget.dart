import 'package:http_auth/http_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../inicio/carrito_widget.dart';
import '../mi_acceso/mi_acceso_widget.dart';
import '../reservaciones/reservaWidget.dart';
import '../seguridad_home_page/view_SOS.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile_model.dart';
export 'profile_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../index.dart';
import 'my_profile_modal.dart';
import 'package:spacesclub/pages/subtoken/subtoken_widget.dart';
import '../control_acceso/control_acceso_widget.dart';
import '../profile/profile_widget.dart';
import '../addtoken/addtoken_widget.dart';
import '../hik/hik_widget.dart';
import '../addsubtoken/addsubtoken_widget.dart';
import '../viewsub/viewsub_widget.dart';
import '../hikvision/hikvision_widget.dart';
import 'package:spacesclub/pages/codigoqr/codigoqr_widget.dart';
import 'package:spacesclub/pages/addtoken/tokenew_widget.dart';

class ProfileWidget extends StatefulWidget {
  final Map<String, dynamic> responseJson;
  final String idUsuario;

  ProfileWidget({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();

  int get userId =>
      responseJson.containsKey('userId') ? responseJson['userId'] : 0;
}

class UserIdWidget extends StatelessWidget {
  final int userId;
  final String? restorationId;

  const UserIdWidget({required this.userId, this.restorationId});

  @override
  Widget build(BuildContext context) {
    return Text('User ID: $userId');
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    if (newText.length >= 5) {
      final year = newText.substring(0, 4);
      String formattedDate = year;

      if (newText.length >= 7) {
        final month = newText.substring(5, 7);
        formattedDate = '$year-$month';

        if (newText.length >= 10) {
          final day = newText.substring(8, 10);
          formattedDate = '$year-$month-$day';
        }
      }

      return newValue.copyWith(
          text: formattedDate,
          selection: updateCursorPosition(formattedDate.length));
    }

    return newValue;
  }

  TextSelection updateCursorPosition(int newLength) {
    return TextSelection.collapsed(
        offset: newLength +
            (newLength ~/ 3)); // Agrega un offset para compensar los guiones
  }
}

//Class para el API incio
class ResponseAPI {
  String type;
  String message;

  ResponseAPI({required this.type, required this.message});

  factory ResponseAPI.fromJson(Map<String, dynamic> json) {
    return ResponseAPI(
      type: json['Type'] ?? '',
      message: json['Message'] ?? '',
    );
  }
}
//Class para el API fin

class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  //para boton de fraccionamiento
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;
  // final mandarJson = responseJson;
  //-------
  bool mostrarContenedor = false;
  bool _isRotated = true;
  late ProfileModel _model;
  //late String _fraccionamiento;
  late String _nombreCasa;
  late String _nombreUsuario;
  late String _imagenProfile;
  late String _imagenProfile1;
  late String _nombreCasa1;
  late String _idPropiedad1;
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
  ////////////////////////////

  /////////////

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();

  final _sexController = TextEditingController();
  final _schoolController = TextEditingController();
  final _parentsController = TextEditingController();
  final _tokenController = TextEditingController();

  bool _isHidden = true;

  // función para cargar la imagen usando API UploadImageUser

  Future<void> uploadImage(int userId, String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://appaltea.azurewebsites.net/api/Mobile/UploadImageUser'),
    );

    // Agrega el ID de usuario como parámetro
    request.fields['UserId'] = userId.toString();

    // Adjunta la imagen
    var imageFile = await http.MultipartFile.fromPath('file', imagePath);
    request.files.add(imageFile);

    // Envía la solicitud y obtén la respuesta
    var response = await request.send();

    // Lee la respuesta de la API
    var responseString = await response.stream.bytesToString();
    print(responseString);
  }

  Future<void> enviarDatos() async {
    final String apiUrl6 =
        'http://4.151.55.143/ISAPI/AccessControl/UserInfo/Record?format=json&devIndex=37623F1A-7D9D-6940-9D7D-DC6F69245789';
    final Map<String, dynamic> userInfo = {
      "UserInfo": [
        {
          "employeeNo": "33",
          "name": "prueba Gera",
          "userType": "normal",
          "Valid": {
            "beginTime": "2017-01-01T00:00:00",
            "endTime": "2027-12-31T23:59:59",
            "timeType": "local"
          },
          "RightPlan": [
            {"doorNo": 1, "planTemplateNo": "1"}
          ],
          "password": "123456"
        }
      ]
    };

    var client = DigestAuthClient(
        'admin', 'Airton2023'); // Reemplaza con tus credenciales

    try {
      final response = await client.post(
        Uri.parse(apiUrl6),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userInfo),
      );

      if (response.statusCode == 200) {
        print("Datos enviados exitosamente");
        print(response.body);
      } else {
        print("Error al enviar los datos: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }
  }

  Future<void> changepass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString('idUsuario') ?? '';

    if (idUser.isEmpty) {
      print("No se encontró el ID del usuario");
      return;
    }

    String newpassword = _newpasswordController.text.trim();
    final String apiUrl2 =
        'https://appaltea.azurewebsites.net/api/Mobile/ChangePassword/';

    Map<String, String> data = {'idUser': idUser, 'password': newpassword};

    final response = await http.post(Uri.parse(apiUrl2),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      print('Contra cambiada');
      abrirNuevoModalreset(context);
      print(idUser);
    } else {
      throw Exception('Error al cambiar contraseña' + idUser + newpassword);
    }
  }

  // Fin función para cargar la imagen usando API UploadImageUser

  @override
  void initState() {
    super.initState();
    getValoresPropiedad();

    // Asignar el valor de widget.idUsuario a idUsuario
    _model = createModel(context, () => ProfileModel());
    _model.textFieldCorreoController ??= TextEditingController();
    _model.textFieldPasswordController ??= TextEditingController();
    _model.textFieldNameController ??= TextEditingController();
    _model.textFieldLastnameController ??= TextEditingController();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _model = createModel(context, () => ProfileModel());
    print('que se va a imprimir');
    print(widget.responseJson['Data'][1]['Value'][1]);
    String _usuario = widget.responseJson['Data'][0]['Value'];
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    String _assocation = widget.responseJson['Data'][1]['Value'][12];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    Map<String, dynamic> data0 = jsonDecode(_usuario);
    //Map<String, dynamic> dataAsociation = jsonDecode(_assocation);

    _nombreUsuario = (data0['Name']);
    _imagenProfile = data0['ImageProfile'];
    _roleUser = data['Type'];
    _idPropiedad = data['Id'].toString();
    _idUsuario = data0['Id'].toString();
    _accessCode = data['AccessCode'].toString();
    //_imagenPropiedad = dataAsociation['Image'];
  }

  Future<void> getValoresPropiedad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreCasa1 = prefs.getString('nombrePropiedad').toString();
      _idPropiedad1 = prefs.getString('idPropiedad').toString();
      _imagenProfile1 = prefs.getString('nombreFracc').toString();
    });
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  final String apiUrl =
      'https://jaus.azurewebsites.net/api/Mobile/RegisterUser/';

  Future<String> login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();
    String lastname = _lastnameController.text.trim();

    Map<String, String> data = {
      'email': email,
      'password': password,
      'name': name,
      'lastname': lastname,
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      //print(response.body);
      var jsonResponse = jsonDecode(response.body);
      print('hello buey');
      print(jsonResponse);
      if (jsonResponse['Message'] == 'Created') {
        print("si quedo");

        //Navigator.push(
        //context,
        //MaterialPageRoute(
        //    builder: (context) => InicioWidget(responseJson: jsonResponse)),
        // );
      } else {
        print('valio verdura');
      }
      return jsonResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  //String fraccionamiento = widget.responseJson['Message'];

  //En esta parte se usa la API UpdateProfileUser

  Future<void> UpdateProfileUser() async {
    final _idUsario = widget.idUsuario;
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/UpdateProfileUser/';

    String? name = _nameController.text.trim();

    String? phone = _phoneController.text.trim();

    String _serId = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> serIdData = jsonDecode(_serId);
    final serIdValue = serIdData['Id'].toString();
    final birthdayISO8601 = serIdData['BirthDay'];
    DateTime birthday = DateTime.parse(birthdayISO8601);
    String formattedBirthday = DateFormat('dd/MM/yyyy').format(birthday);
    final serEmailValue = serIdData['Email'];
    final serApellido = serIdData['LastName'];
    print("$formattedBirthday");

    Map<String, String> data = {
      'email': serEmailValue,
      'userId': serIdValue,
      'birthday': formattedBirthday,
      'name': name,
      'lastname': serApellido,
      'phone': phone,
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      name = (data['name']);

      if (jsonResponse['Type'] == 'Success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //await prefs.clear();
        await prefs.setString('name', name!); // Usar la variable 'name'

        // Actualizar los controladores de texto con los nuevos valores
        _nombreUsuario = name;

        // Actualizar la interfaz
        setState(() {
          // No es necesario hacer nada especial aquí, solo setState
        });
      }
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }
  //String fraccionamiento = widget.responseJson['Message'];

  @override
  Widget build(BuildContext context) {
    // Establecer el color de la barra de notificaciones en blanco
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(1, 29, 69, 1),
    ));
    final responseJson = widget.responseJson;
    String _nombreFracc;
    return Container(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: BotonFlotante(
          responseJson: widget.responseJson,
        ),
        bottomNavigationBar: barranavegacion(
          responseJson: responseJson,
          idPropiedad: _idPropiedad,
          idUsuario: _idUsuario,
          accessCode: _accessCode,
        ),
        key: scaffoldKey,
        body: Builder(
          builder: (context) {
            return Container(
              child: SingleChildScrollView(
                child: SafeArea(
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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //ListTile(),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.0),
                                  child: IconButton(
                                      //rgba(44, 255, 226, 1)
                                      color: Color.fromRGBO(44, 255, 226, 1),
                                      onPressed: () {
                                        print('hello');
                                        Navigator.of(context).pop();
                                      },
                                      icon: FaIcon(FontAwesomeIcons.arrowLeft)),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      _nombreCasa1,
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 21.0,
                                          ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 5.0, 0.0),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InicioWidget(
                                            responseJson: widget.responseJson,
                                          ),
                                        ),
                                      );
                                    },
                                    icon:
                                        Image.asset('assets/images/ICONOP.png'),
                                  ),
                                )
                              ],
                            ),

                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 20.0, 0.0, 0.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.41,
                                    height: MediaQuery.of(context).size.width *
                                        0.41,
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
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -15,
                                  right: -25,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: MyProfileModal(
                                      responseJson: responseJson,
                                      idUsuario: widget.idUsuario,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05,
                            ),
                            // nombre update
                            Container(
                              decoration: BoxDecoration(
                                  //color: Colors.amber
                                  ),
                              child: Column(
                                children: [
                                  Text(
                                    _nombreUsuario,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    _nombreCasa1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.07,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ), // espacio entre contraseña y texto cambiar contraseña

                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ), // espacio entre el texto cambiar contraseña y el boton guardar
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  // buttonEntrar
                                  abrirModalPasswordReset(context);
                                },
                                text: 'Cambiar Contraseña',
                                options: FFButtonOptions(
                                  width: 200.0,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF011D45),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 17.0,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                              ),
                            ),
                            // contraseña update

                            // Termina Formulario datos update
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.04,
                            ),
                            //Empieza imagenes botones
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  // buttonEntrar
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterPropertyScreen()),
                                  );
                                },
                                text: 'Eliminar Cuenta',
                                options: FFButtonOptions(
                                  width: 200.0,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color.fromARGB(255, 255, 0, 0),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 17.0,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.04,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget dialogboton() {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFF2CFFE2),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.05,
        child: TextButton(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  bool isFinished = false;
                  return Dialog(
                    alignment: Alignment.center,
                    backgroundColor: Color.fromRGBO(252, 252, 252, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(27.0), // Bordes redondeados
                    ),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.33,
                        width: MediaQuery.of(context).size.width * 1.4,
                        child: Column(children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.03,
                              left: MediaQuery.of(context).size.width * 0.03,
                              top: MediaQuery.of(context).size.width * 0.05,
                              bottom: MediaQuery.of(context).size.width * 0.08,
                            ),
                            child: Text(
                              '¿Deseas guardar los cambios realizaos de tus datos personales?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 0, 0, 1)),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.width * 0.15,
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.11,
                              left: MediaQuery.of(context).size.width * 0.11,
                              top: MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                UpdateProfileUser();
                                Navigator.of(context).pop();
                              },
                              child: Text("GUARDAR",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Helvetica',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                  )),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(34),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF2CFFE2))),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.width * 0.15,
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.11,
                              left: MediaQuery.of(context).size.width * 0.11,
                              top: MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("CANCELAR",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Helvetica',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                  )),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(34),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF2CFFE2))),
                            ),
                          ),
                        ]),
                      );
                    }),
                  ); //accesosModal();
                });
          },
          child: Text("GUARDAR",
              style: TextStyle(
                color: Color(0xFF011D45),
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              )),
        ));
  }

  final TextEditingController _nuevaContrasenaController =
      TextEditingController();
  final TextEditingController _repiteContrasenaController =
      TextEditingController();
  final _newpasswordController = TextEditingController();

  void abrirModalPasswordReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(255, 243, 243, 243),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo para la nueva contraseña
                TextFormField(
                  controller: _newpasswordController,
                  decoration: InputDecoration(
                    labelText: 'Repite la Contraseña',
                    labelStyle: TextStyle(
                        color: Colors
                            .black), // Cambia el color del label si es necesario
                  ),
                  obscureText: true, // Esto es para ocultar la contraseña
                  style: TextStyle(
                      color: Colors.blue), // Cambia el color del texto aquí
                ),
                SizedBox(height: 10), // Un pequeño espacio entre los campos
                // Campo para repetir la contraseña
                TextFormField(
                  controller: _newpasswordController,
                  decoration: InputDecoration(
                    labelText: 'Repite la Contraseña',
                    labelStyle: TextStyle(
                        color: Colors
                            .black), // Cambia el color del label si es necesario
                  ),
                  obscureText: true, // Esto es para ocultar la contraseña
                  style: TextStyle(
                      color: Colors.blue), // Cambia el color del texto aquí
                ),
                SizedBox(height: 20), // Un espacio antes del botón
                // Botón para aceptar
                FFButtonWidget(
                  onPressed: () async {
                    print('boton recuperarggg');
                    changepass();
                    print('paaaaa');
                  },
                  text: 'RECUPERA',
                  options: FFButtonOptions(
                    width: 150.0,
                    height: 40.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF011D45),
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(34.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void abrirNuevoModalreset(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Color.fromARGB(186, 243, 243, 243), // Color de fondo del Dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0), // Bordes redondeados
          ),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //rgba(0, 15, 36, 1)
                  width: 800,
                  color: Color.fromRGBO(0, 15, 36, 0.308),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 20.0),
                        child: Text(
                          'Confirmado',
                          style: TextStyle(
                              color: Color.fromARGB(255, 7, 236, 225),
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
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 20.0),
                        child: Container(
                          child: Icon(
                            Icons.password,
                            size: 75,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Se cambio tu contraseña Exitosamente Inicia sesion',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),

                //Boton de recuperar
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 15.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      // buttonEntendido
                      print('Entendido');
                      Navigator.of(context).pop();
                    },
                    text: 'ENTENDIDO',
                    options: FFButtonOptions(
                      width: 150.0,
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFF011D45),
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
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
        height: MediaQuery.of(context).size.width * 0.17,
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
  final responseJson;

  const BotonFlotante({
    super.key,
    required this.responseJson,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color.fromARGB(255, 225, 216, 216),
          width: 5.0,
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(1, 29, 69, 1),
        child: Image.asset(
          'assets/images/S.O.S.png',
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.15,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => viewSOS(responseJson: responseJson),
          ));
          print('Hola Mundo');
        },
      ),
    );
  }
}

void abrirmodalcuenta(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor:
            Color.fromARGB(255, 243, 243, 243), // Color de fondo del Dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                //rgba(0, 15, 36, 1)
                width: 800,
                color: Color.fromRGBO(0, 15, 36, 0.308),
                child: Column(
                  children: [
                    Text(
                      'Borrar cuenta',
                      style: TextStyle(
                          color: Color.fromARGB(255, 7, 236, 225),
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tus datos se enviaron y se eliminara tu cuenta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 7, 236, 225),
                  ),
                ),
              ),

              //Boton de recuperar
            ],
          ),
        ),
      );
    },
  );
}
