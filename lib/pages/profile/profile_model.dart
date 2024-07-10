import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileModel extends FlutterFlowModel {
  /// Initialization and disposal methods.

 void initState(BuildContext context) {}
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

    TextEditingController? textFieldsexController;
  String? Function(BuildContext, String?)? textFieldsexControllerValidator;

    TextEditingController? textFieldschoolController;
  String? Function(BuildContext, String?)? textFieldschoolControllerValidator;

      TextEditingController? textFieldparentsController;
  String? Function(BuildContext, String?)? textFieldparentsControllerValidator;

    TextEditingController? textFieldtokenController;
  String? Function(BuildContext, String?)? textFieldtokenControllerValidator;

  /// Additional helper methods are added here.
  ///
  void dispose() {
    textFieldCorreoController?.dispose();
    textFieldPasswordController?.dispose();
    textFieldLastnameController?.dispose();
    textFieldNameController?.dispose();
    textFieldBirthdayController?.dispose();
    textFieldsexController?.dispose();
    textFieldschoolController?.dispose();
  }
}
