import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageWidgetLoggedModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextFieldCorreo widget.
  TextEditingController? textFieldCorreoController;
  String? Function(BuildContext, String?)? textFieldCorreoControllerValidator;
  // State field(s) for TextFieldPassword widget.
  TextEditingController? textFieldPasswordController;
  String? Function(BuildContext, String?)? textFieldPasswordControllerValidator;
  TextEditingController? textFieldforgotpassController;
  String? Function(BuildContext, String?)?
      textFieldforgotpassControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    textFieldCorreoController?.dispose();
    textFieldPasswordController?.dispose();
  }

  /// Additional helper methods are added here.
  ///
}
