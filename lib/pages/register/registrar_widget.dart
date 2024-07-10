import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'registrar_model.dart';
export 'registrar_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class RegistrarWidget extends StatefulWidget {
  const RegistrarWidget({Key? key}) : super(key: key);

  @override
  _RegistrarWidgetState createState() => _RegistrarWidgetState();
}

class _RegistrarWidgetState extends State<RegistrarWidget> {
  late RegistrarModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _birthdayController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _isLoading = false;

  final String apiUrl =
      'https://appaltea.azurewebsites.net/api/Mobile/RegisterUser/';

  Future<void> registrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();
    String lastname = _lastnameController.text.trim();
    String birthday = _birthdayController.text.trim();

    Map<String, String> data = {
      'email': email,
      'password': password,
      'name': name,
      'lastname': lastname,
      'birthday': birthday,
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['Message'] == 'Created') {
        _showCustomDialog(
            context,
            'Confirmado',
            'Revisa tu correo para validar tu usuario',
            Icons.check_circle,
            Colors.green,
            true);
      } else {
        _showCustomDialog(context, 'No se ha creado el usuario',
            jsonResponse['Message'], Icons.error, Colors.red, false);
      }
    } else {
      _showCustomDialog(context, 'Error al crear el usuario',
          'Error al realizar la petición POST', Icons.error, Colors.red, false);
    }
  }

  void _showCustomDialog(BuildContext context, String title, String message,
      IconData icon, Color iconColor, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(186, 243, 243, 243),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  color: Color.fromRGBO(0, 15, 36, 0.308),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Icon(
                    icon,
                    size: 75,
                    color: iconColor,
                  ),
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (success) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'ENTENDIDO',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 17.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF011D45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(34.0),
                      ),
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegistrarModel());
    _model.textFieldCorreoController ??= TextEditingController();
    _model.textFieldPasswordController ??= TextEditingController();
    _model.textFieldNameController ??= TextEditingController();
    _model.textFieldLastnameController ??= TextEditingController();
    _model.textFielDayController ??= TextEditingController();
    _model.textFielMonthController ??= TextEditingController();
    _model.textFielYearController ??= TextEditingController();
    _model.textFieldBirthdayController ??= TextEditingController();

    _birthdayController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Set the app to full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _model.dispose();
    _unfocusNode.dispose();
    // Restore the UI mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _selectBirthday() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value != _confirmPasswordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La confirmación de contraseña es obligatoria';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/images/fondop.png').image,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: height * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Color.fromARGB(255, 1, 29, 69)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Container(
                  width: width * 0.8,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/Logo3.png',
                          width: width * 0.2),
                      SizedBox(height: height * 0.05),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextFormField(
                              controller: _emailController,
                              hintText: 'Correo electronico...',
                              icon: Icons.person,
                              validator: _validateEmail,
                            ),
                            SizedBox(height: height * 0.03),
                            _buildPasswordFormField(
                              controller: _passwordController,
                              hintText: 'Contraseña...',
                              validator: _validatePassword,
                              isPasswordHidden: _isPasswordHidden,
                              togglePasswordView: () {
                                setState(() {
                                  _isPasswordHidden = !_isPasswordHidden;
                                });
                              },
                            ),
                            SizedBox(height: height * 0.03),
                            _buildPasswordFormField(
                              controller: _confirmPasswordController,
                              hintText: 'Confirmar contraseña...',
                              validator: _validateConfirmPassword,
                              isPasswordHidden: _isConfirmPasswordHidden,
                              togglePasswordView: () {
                                setState(() {
                                  _isConfirmPasswordHidden =
                                      !_isConfirmPasswordHidden;
                                });
                              },
                            ),
                            SizedBox(height: height * 0.03),
                            _buildTextFormField(
                              controller: _nameController,
                              hintText: 'Nombre',
                              icon: Icons.person,
                              validator: _validateRequired,
                            ),
                            SizedBox(height: height * 0.03),
                            _buildTextFormField(
                              controller: _lastnameController,
                              hintText: 'Apellidos',
                              icon: Icons.person,
                              validator: _validateRequired,
                            ),
                            SizedBox(height: height * 0.03),
                            TextFormField(
                              controller: _birthdayController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Fecha de nacimiento',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 15.0,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF011D45),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF011D45),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(34.0),
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(0, 255, 255, 255),
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                              textAlign: TextAlign.start,
                              onTap: _selectBirthday,
                              validator: _validateRequired,
                            ),
                            SizedBox(height: height * 0.03),
                            _isLoading
                                ? CircularProgressIndicator()
                                : FFButtonWidget(
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        await registrar();
                                      }
                                    },
                                    text: 'REGISTRAR',
                                    options: FFButtonOptions(
                                      width: width * 0.5,
                                      height: 40.0,
                                      padding: EdgeInsets.all(0.0),
                                      color: Color(0xFF5464C6),
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
                          ],
                        ),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
              fontFamily: 'Poppins',
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 15.0,
            ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF011D45),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(34.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF011D45),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(34.0),
        ),
        filled: true,
        fillColor: Color.fromARGB(0, 255, 255, 255),
        prefixIcon: Icon(
          icon,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Poppins',
            color: Color.fromARGB(255, 0, 0, 0),
          ),
      textAlign: TextAlign.start,
      validator: validator,
    );
  }

  Widget _buildPasswordFormField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    required bool isPasswordHidden,
    required VoidCallback togglePasswordView,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPasswordHidden,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
              fontFamily: 'Poppins',
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 15.0,
            ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF011D45),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(34.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF011D45),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(34.0),
        ),
        filled: true,
        fillColor: Color.fromARGB(0, 255, 255, 255),
        prefixIcon: Icon(
          Icons.lock,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: togglePasswordView,
        ),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Poppins',
            color: Color.fromARGB(255, 0, 0, 0),
          ),
      textAlign: TextAlign.start,
      validator: validator,
    );
  }
}
