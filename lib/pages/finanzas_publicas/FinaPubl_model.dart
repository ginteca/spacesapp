import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class FinaPublModel extends FlutterFlowModel {
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

  /// Additional helper methods are added here.
  ///
  void dispose() {
    textFieldCorreoController?.dispose();
    textFieldPasswordController?.dispose();
    textFieldLastnameController?.dispose();
    textFieldNameController?.dispose();
    textFieldBirthdayController?.dispose();
  }
}
