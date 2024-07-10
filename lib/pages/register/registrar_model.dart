import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegistrarModel extends FlutterFlowModel {
  /// Initialization and disposal methods.

  TextEditingController? textFieldCorreoController;
  String? Function(BuildContext, String?)? textFieldCorreoControllerValidator;
  // State field(s) for TextFieldPassword widget.
  TextEditingController? textFieldPasswordController;
  String? Function(BuildContext, String?)? textFieldPasswordControllerValidator;

  TextEditingController? textFieldNameController;
  String? Function(BuildContext, String?)? textFieldNameControllerValidator;

  TextEditingController? textFieldLastnameController;
  String? Function(BuildContext, String?)? textFieldLastnameControllerValidator;

  TextEditingController? textFieldBirthdayController;
  String? Function(BuildContext, String?)? textFieldBirthdayControllerValidator;

  TextEditingController? textFielDayController;
  String? Function(BuildContext, String?)? textFielDayControllerValidator;

  TextEditingController? textFielMonthController;
  String? Function(BuildContext, String?)? textFielMonthControllerValidator;

  TextEditingController? textFielYearController;
  String? Function(BuildContext, String?)? textFielYearControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    textFieldCorreoController?.dispose();
    textFieldPasswordController?.dispose();
    textFieldLastnameController?.dispose();
    textFieldNameController?.dispose();
    textFielDayController?.dispose();
    textFielMonthController?.dispose();
    textFielYearController?.dispose();
    textFieldBirthdayController?.dispose();
  }
}
