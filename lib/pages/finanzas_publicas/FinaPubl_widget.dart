import 'dart:convert';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../inicio/inicio_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'FinaPubl_model.dart';
export 'FinaPubl_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FinaPublWidget extends StatefulWidget {
  final responseJson;
  const FinaPublWidget({Key? key, required this.responseJson})
      : super(key: key);

  @override
  _FinaPublWidgetState createState() => _FinaPublWidgetState();
}

class _FinaPublWidgetState extends State<FinaPublWidget>
    with SingleTickerProviderStateMixin {
  //para boton de fraccionamiento
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;
  // final mandarJson = responseJson;
  //-------
  bool mostrarContenedor = false;
  bool _isRotated = true;
  late FinaPublModel _model;
  //late String _fraccionamiento;
  late String _nombreCasa;
  late String _nombreUsuario;
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
  //boton detalles finanzas publicas inicio
  String informacion = '';
  //boton detalles finanzas publicas fin
  late double monto = 0.0;
  late double totalAmountIn = 0.0;
  late double totalAmountOut = 0.0;
  late double totalAmountBal = 0.0;
  late int pago = 0;
  late int sinPago = 0;
  late double porcentaje;
  late int porcentajeInt = 0;
  late String porcentajeFormateado = '';
  late TextEditingController textFieldEnviarMes;
  late TextEditingController textFieldEnviarDia;
  final textFieldEnviarAnho = TextEditingController();
  int? selectedYear;
  int? selectedDay;
  String? selectedMonth;
  late String dia = '01';
  late List<int> yearsList;
  late String idAssociation;
  List<int> daysList = [];

  List<String> monthsList = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  void updateDaysList(String selectedMonth) {
    int daysInMonth =
        DateTime(DateTime.now().year, monthsList.indexOf(selectedMonth) + 2, 0)
            .day;
    setState(() {
      daysList = List<int>.generate(daysInMonth, (index) => index + 1);
    });
  }

  @override
  void initState() {
    super.initState();

    textFieldEnviarMes = TextEditingController();
    textFieldEnviarDia = TextEditingController();
    yearsList = List.generate(20, (index) => DateTime.now().year + index);
    monto = 0;
    totalAmountIn = 0;
    totalAmountOut = 0;
    totalAmountBal = 0;

    obtenerFinanzas();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _model = createModel(context, () => FinaPublModel());
    print('que se va a imprimir');
    print(widget.responseJson['Data'][1]['Value'][1]);
    String _usuario = widget.responseJson['Data'][0]['Value'];
    String _fraccionamiento = widget.responseJson['Data'][1]['Value'];
    String _assocation = widget.responseJson['Data'][1]['Value'][12];
    Map<String, dynamic> data = jsonDecode(_fraccionamiento);
    Map<String, dynamic> data0 = jsonDecode(_usuario);
    //Map<String, dynamic> dataAsociation = jsonDecode(_assocation);

    _nombreCasa = data['Name'];
    _nombreUsuario = (data0['Name'] + ' ' + data0['LastName']);
    _imagenProfile = data0['ImageProfile'];
    _roleUser = data['Type'];
    _idPropiedad = data['Id'].toString();
    _idUsuario = data0['Id'].toString();
    _accessCode = data['AccessCode'].toString();
    //_imagenPropiedad = dataAsociation['Image'];
  }

  Future<void> obtenerFinanzas() async {
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetPublicFinances/'; // Reemplaza con la URL de tu API

    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    final idUser = data0['Id'].toString();

    String _associationId = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_associationId);
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();

    String? mes = textFieldEnviarMes.text.trim();
    String? anho = textFieldEnviarAnho.text.trim();
    String periodo = "$anho-$mes-$dia";
    print(periodo);

    // Datos que deseas enviar en el cuerpo de la solicitud
    final body = {
      'idUser': idUser,
      'AssociationId': idAssociation,
      'period': '$periodo'.toString()
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      setState(() {
        // La solicitud fue exitosa, analiza la respuesta JSON
        print('Entro a la Api');
        Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> financesData =
            json.decode(data['Data'][0]['Value']);
        monto = financesData['CurrentAmount'];
        pago = financesData['Pay'];
        sinPago = financesData['NoPay'];
        porcentaje = (pago / (pago + sinPago)) * 100;
        porcentajeInt = porcentaje.toInt();
        porcentajeFormateado = porcentaje.toStringAsFixed(1);
        monto;
        totalAmountIn = 0;
        totalAmountOut = 0;
        totalAmountBal = 0;
        porcentajeFormateado;

        // Acceder a la lista de elementos en "In"
        List<dynamic> inList = financesData['In'];

        // Inicializar una variable para mantener el total

        // Recorrer la lista de elementos en "In" y sumar los valores de "Amount"
        for (var entry in inList) {
          totalAmountIn += entry['Amount'];
        }

        // Acceder a la lista de elementos en "In"
        List<dynamic> inList2 = financesData['Out'];

        // Recorrer la lista de elementos en "In" y sumar los valores de "Amount"
        for (var entry in inList2) {
          totalAmountOut += entry['Amount'];
        }

        totalAmountBal = totalAmountIn + monto - totalAmountOut;
      });

      //codigoacceso
    } else {
      // La solicitud falló
      print('No entro a la Api');
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _model.dispose();

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
      //onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
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
        body: Container(
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
                        //ListTile(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.0,
                                left: MediaQuery.of(context).size.width * 0.03,
                                top: MediaQuery.of(context).size.width * 0.0,
                                bottom: MediaQuery.of(context).size.width * 0.0,
                              ),
                              child: IconButton(
                                  //rgba(44, 255, 226, 1)
                                  color: Color.fromRGBO(44, 255, 226, 1),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    //context.pushNamed('inicio');
                                  },
                                  icon: FaIcon(FontAwesomeIcons.arrowLeft)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  "FINANZAS \n PÚBLICAS",
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 17.0,
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.02,
                                left: MediaQuery.of(context).size.width * 0.0,
                                top: MediaQuery.of(context).size.width * 0.0,
                                bottom: MediaQuery.of(context).size.width * 0.0,
                              ),
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
                                icon: Image.asset('assets/images/ICONOP.png'),
                              ),
                            )
                          ],
                        ),

                        //boton nuevo ingreso inicio
                        /*
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.75,
                              top: MediaQuery.of(context).size.height * 0.1),
                          /*padding: EdgeInsetsDirectional.fromSTEB(
                              300.0, 10.0, 0.0, 0.0)*/
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InicioWidget(
                                    responseJson: responseJson,
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              elevation: MaterialStateProperty.all<double>(0),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(10.0, 10.0)),
                            ),
                            child: Image.asset(
                              'assets/images/FINANZAS.png',
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.width * 0.15,
                            ),
                          ),
                        ),
*/
                        //boton nuevo ingreso fin

// grafica circulo inicio
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 140.0, 0.0, 0.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularStepProgressIndicator(
                                totalSteps: 100,
                                currentStep: porcentajeInt,
                                stepSize: 20,
                                selectedColor: Color.fromRGBO(25, 252, 52, 1),
                                unselectedColor:
                                    Color.fromARGB(255, 253, 10, 10),
                                padding: 0,
                                width: 170,
                                height: 170,
                                selectedStepSize: 20,
                              ),
                              Text(
                                '$porcentajeFormateado%', // Puedes reemplazar '90' con el valor que desees mostrar
                                style: TextStyle(
                                  fontSize: 24, // Tamaño de fuente deseado
                                  color: Colors.black, // Color de texto deseado
                                  fontWeight: FontWeight
                                      .bold, // Otras propiedades de estilo de texto
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 253, 10, 10),
                                    borderRadius: BorderRadius.circular(
                                        10), // Ajusta el valor según el radio deseado
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width * 0.0,
                                    bottom:
                                        MediaQuery.of(context).size.width * 0.0,
                                    left: MediaQuery.of(context).size.width *
                                        0.03,
                                    right:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  child: Text(
                                    'Sin Pagar',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'helvetica'),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(25, 252, 52, 1),
                                    borderRadius: BorderRadius.circular(
                                        10), // Ajusta el valor según el radio deseado
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width * 0.0,
                                    bottom:
                                        MediaQuery.of(context).size.width * 0.0,
                                    left: MediaQuery.of(context).size.width *
                                        0.03,
                                    right:
                                        MediaQuery.of(context).size.width * 0.0,
                                  ),
                                  child: Text(
                                    'Pagado',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'helvetica'),
                                  ),
                                )
                              ]),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.03),
// grafica circulo fin

                        //inicio texto periodo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Periodo: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.33,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(0, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(0, 255, 255, 255)),
                                    borderRadius: BorderRadius.circular(30)),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  icon: Icon(Icons
                                      .arrow_drop_down), // Icono de flecha hacia abajo
                                  iconSize: 24,
                                  alignment: Alignment.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(197, 0, 0, 0),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                  dropdownColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  value: selectedMonth,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMonth = newValue;
                                      int monthIndex =
                                          monthsList.indexOf(newValue!);
                                      selectedDay = null;
                                      updateDaysList(selectedMonth!);
                                      textFieldEnviarMes.text = (monthIndex + 1)
                                          .toString()
                                          .padLeft(2, '0');
                                      obtenerFinanzas();
                                    });
                                  },
                                  hint: Text(
                                    "Mes",
                                    style: TextStyle(
                                        color: Color.fromARGB(197, 87, 87, 87)),
                                    textAlign: TextAlign.center,
                                  ),
                                  items: monthsList.map((String month) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: month,
                                      child: Text(month),
                                    );
                                  }).toList(),
                                  underline: Container(),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(0, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(0, 255, 255, 255)),
                                    borderRadius: BorderRadius.circular(30)),
                                child: DropdownButton<int>(
                                  alignment: Alignment.center,
                                  isExpanded: true,
                                  icon: Icon(Icons
                                      .arrow_drop_down), // Icono de flecha hacia abajo
                                  iconSize: 24,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(197, 0, 0, 0),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                  hint: Text(
                                    "Año",
                                    style: TextStyle(
                                        color: Color.fromARGB(197, 87, 87, 87)),
                                  ),
                                  dropdownColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  value: selectedYear,
                                  items: yearsList.map((int year) {
                                    return DropdownMenuItem<int>(
                                      alignment: Alignment.center,
                                      value: year,
                                      child: Text(year.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedYear = newValue!;
                                      textFieldEnviarAnho.text =
                                          newValue.toString();

                                      obtenerFinanzas();
                                    });
                                  },
                                  underline: Container(),
                                )),
                          ],
                        ),
                        //fin texto periodo

                        //inicio texto saldo inicial

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SALDO INICIAL:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,

                                  fontFamily: 'Poppins', // fuente
                                  color: Color(0xFF5565c6),
                                  height: 2.0,
                                ),
                              ),

                              SizedBox(width: 16), // Espacio entre los textos
                              Text(
                                "\$$monto.ºº ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,

                                  fontFamily: 'Poppins', // fuente
                                  color: Color(0xFF5565c6),
                                  height: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //fin texto saldo inicial

                        //inicio BALANCE FINANCIERO
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 40.0, 0.0, 0.0),
                          child: Text(
                            "BALANCE FINANCIERO",
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF011D45),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        //fin BALANCE FINANCIERO

                        //inicio datos balanceo
                        //Inicio INGRESOS
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ingresos:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,

                                      fontFamily: 'Poppins', // fuente
                                      color: Color(0xFFF011D45),
                                      height: 2.0,
                                    ),
                                  ),

                                  SizedBox(
                                      width: 16), // Espacio entre los textos
                                  Text(
                                    "\$$totalAmountIn.ºº",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,

                                      fontFamily: 'Poppins', // fuente
                                      color: Color(0xFFF011D45),
                                      height: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Fin INGRESOS
                            //Inicio EGRESOS
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 3.0, 0.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Egresos:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,

                                      fontFamily: 'Poppins', // fuente
                                      color: Color(0xFFF011D45),
                                      height: 2.0,
                                    ),
                                  ),

                                  SizedBox(
                                      width: 16), // Espacio entre los textos
                                  Text(
                                    "\$$totalAmountOut.ºº",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,

                                      fontFamily: 'Poppins', // fuente
                                      color: Color(0xFFF011D45),
                                      height: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Fin EGRESOS
                            //Inicio BALANCE
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 3.0, 0.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Balance:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,

                                      fontFamily: 'Poppins', // fuente
                                      color: Color(0xFFF011D45),
                                      height: 2.0,
                                    ),
                                  ),

                                  SizedBox(
                                      width: 16), // Espacio entre los textos
                                  Text(
                                    "\$$totalAmountBal.ºº",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,

                                      fontFamily: 'Poppins', // fuente
                                      color: Color(0xFFF011D45),
                                      height: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        //Fin BALANCE
                        //fin datos balanceo

                        //fin CUENTAS POR COBRAR
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
