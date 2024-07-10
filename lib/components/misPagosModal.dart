import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../pages/finanzas_publicas/FinaPubl_widget.dart';
import '../pages/subpago/subpago_widget.dart';
import '../pages/subpago/subpagonline_widget.dart';
import 'modalPagos/pagoParcialPage.dart';

class misPagosModal extends StatefulWidget {
  @override
  _misPagosModalState createState() => _misPagosModalState();
  final responseJson;
  final idUsuario;
  final idPropiedad;
  final AccessCode;
  const misPagosModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
    required this.AccessCode,
  }) : super(key: key);
}

class PaymentItem {
  String nombre;
  double payment;
  String anio;
  String mes;
  int idPayment;
  PaymentItem(
    this.nombre,
    this.payment,
    this.anio,
    this.mes,
    this.idPayment,
  );
}

class _misPagosModalState extends State<misPagosModal> {
  double totalapagar = 0.0;
  List<PaymentItem> name = [];
  late String idAssociation;
  double pendingAmount = 0.0;

  Future<ListView> getPays(int anuel) async {
    final url =
        'https://appaltea.azurewebsites.net/api/Mobile/GetAllDetailPayments/';
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    final idProperty = data1['Id'].toString();
    final associationId = data1['Assocation']['Id'] as int;
    idAssociation = associationId.toString();
    final body = {
      'idUser': widget.idUsuario,
      'PropertyId': widget.idPropiedad,
      'AssociationId': idAssociation,
      'period': '$anuel-01-01',
      'period2': '$anuel-12-31',
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String value = data['Data'][0]['Value'];
      Map<String, dynamic> valueObj = jsonDecode(value);
      final paymentsDetails = valueObj['PaymentsDetails'] as List<dynamic>;

      pendingAmount = valueObj['PendingAmount'];

      setState(() {
        pagoswidget =
            paymentsDetails.take(12).toList(); // Limitar a 12 elementos
      });

      List<bool> isCheckedList = [];
      String obtenerNombreDelMes(int month) {
        Map<int, String> monthNames = {
          1: 'Enero',
          2: 'Febrero',
          3: 'Marzo',
          4: 'Abril',
          5: 'Mayo',
          6: 'Junio',
          7: 'Julio',
          8: 'Agosto',
          9: 'Septiembre',
          10: 'Octubre',
          11: 'Noviembre',
          12: 'Diciembre',
        };
        return monthNames[month] ??
            'Mes Desconocido'; // Devuelve el nombre del mes o "Mes Desconocido" si el número de mes no se encuentra en el mapa.
      }

      Color obtenerColorPorEstado(String status) {
        if (status == 'Pay') {
          return Colors.green;
        } else if (status == 'NoPay') {
          return Colors.red;
        } else {
          return Colors.yellow;
        }
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: pagoswidget.length,
        itemBuilder: (BuildContext context, int index) {
          final widgetpagos = pagoswidget[index];
          final int month = widgetpagos['Month'];
          final mesjaja = monthsList[month - 1];
          final pendigAmountPayment = widgetpagos['Amount'];
          final payments = widgetpagos['Payments'] as List<dynamic>;

          if (isCheckedList.length != pagoswidget.length) {
            isCheckedList = List.generate(pagoswidget.length, (index) => false);
          }
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      color: Color.fromARGB(29, 1, 29, 69),
                    ),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$mesjaja $selectedYear',
                                  style: TextStyle(
                                    color: obtenerColorPorEstado(
                                        payments.first['Status']),
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                                Text(
                                  '\$$pendigAmountPayment',
                                  style: TextStyle(
                                    color: obtenerColorPorEstado(
                                        payments.first['Status']),
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              for (int i = 0; i < payments.length; i++)
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          payments[i]['Name'],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            color: obtenerColorPorEstado(
                                                payments[i]['Status']),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        payments[i]['PendingAmountPayment']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          color: obtenerColorPorEstado(
                                              payments[i]['Status']),
                                        ),
                                      ),
                                      Checkbox(
                                        value: isCheckedList[i],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isCheckedList[i] = value ?? false;
                                            if (isCheckedList[i] == false) {
                                              setState(() {
                                                totalapagar = totalapagar -
                                                    payments[i]['Payment'];
                                              });
                                            }
                                            if (isCheckedList[i] == true) {
                                              setState(() {
                                                totalapagar = totalapagar +
                                                    payments[i]['Payment'];
                                                int idPA = payments[i]
                                                    ['IdPaymentAssociation'];
                                                int mes =
                                                    payments[i]['MonthPay'];
                                                final String mesNombre =
                                                    obtenerNombreDelMes(mes);
                                                String nombre =
                                                    payments[i]['Name'];
                                                double pay = payments[i]
                                                    ['PendingAmountPayment'];
                                                PaymentItem newItem =
                                                    PaymentItem(
                                                        nombre,
                                                        pay,
                                                        anuel.toString(),
                                                        mesNombre,
                                                        idPA);
                                                name.add(newItem);
                                              });
                                            }
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        activeColor: Colors.blue,
                                        side:
                                            MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(
                                            width: 1.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      throw Exception('Error en la solicitud de la API');
    }
  }

  void _showTotalContainer(BuildContext context, double totalapagar) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.22,
          decoration: BoxDecoration(
            color: Color.fromARGB(71, 1, 29, 69),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TOTAL A PAGAR',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica',
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              ),
              Text(
                '\$$totalapagar',
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.28,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34)),
                                backgroundColor: Color.fromRGBO(1, 29, 69, 1)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubpagonlineWidget(
                                          responseJson: widget.responseJson,
                                          idUsuario: widget.idUsuario,
                                          idPropiedad: widget.idPropiedad,
                                          paymentItems: name,
                                          selectedPropertyId:
                                              widget.idPropiedad,
                                          selectedUserId: widget.idUsuario,
                                        )),
                              );
                            },
                            child: Text("PAGO EN LINEA",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.025))),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.28,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34)),
                              backgroundColor: Color.fromRGBO(1, 29, 69, 1)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => pagoParcialPage(
                                      responseJson: widget.responseJson,
                                      idUsuario: widget.idUsuario,
                                      idPropiedad: widget.idPropiedad,
                                      paymentItems: name)),
                            );
                          },
                          child: Text(
                            "PAGO PARCIAL",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.025),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.28,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34)),
                              backgroundColor: Color.fromRGBO(1, 29, 69, 1)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubpagoWidget(
                                      responseJson: widget.responseJson,
                                      idUsuario: widget.idUsuario,
                                      idPropiedad: widget.idPropiedad,
                                      paymentItems: name)),
                            );
                          },
                          child: Text("SUBIR PAGO",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.025)),
                        ),
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  late int selectedYear = DateTime.now().year;
  late List<int> yearsList;

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

  List<dynamic> pagoswidget = [];
  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year;
    yearsList = List.generate(12, (index) => DateTime.now().year - index + 2);
  }

  @override
  Widget build(BuildContext context) {
    final responseJson = widget.responseJson;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            children: [
              Column(
                children: <Widget>[
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.65),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(186, 243, 243, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FinaPublWidget(
                                        responseJson: responseJson),
                                  ),
                                );
                              },
                              icon: Icon(Icons.auto_graph),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Text(
                            'Finanzas Publicas',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Center(
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(186, 243, 243, 243),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(33)),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  selectedYear = DateTime.now().year;
                                  getPays(selectedYear);
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 243, 243, 243),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05),
                                                estadoCuentaTxt(),
                                                Column(
                                                  children: <Widget>[
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      12.0,
                                                                      0.0,
                                                                      12.0,
                                                                      0.0),
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.7,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            33),
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255)),
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10,
                                                                        0,
                                                                        10,
                                                                        0),
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(22.0, 0.0, 12.0, 0.0),
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      color: Color.fromRGBO(1, 29, 69, 1), // Color del borde
                                                                                      width: 2.0, // Ancho del borde
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(8.0), // Radio del borde
                                                                                  ),
                                                                                  child: DropdownButtonHideUnderline(
                                                                                    child: DropdownButton<int>(
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontFamily: 'Helvetica',
                                                                                        color: Color.fromARGB(255, 17, 16, 85),
                                                                                      ),
                                                                                      dropdownColor: Color.fromARGB(255, 255, 255, 255),
                                                                                      value: selectedYear,
                                                                                      icon: Icon(Icons.arrow_drop_down, color: Color.fromRGBO(1, 29, 69, 1)),
                                                                                      items: yearsList.map((int year) {
                                                                                        return DropdownMenuItem<int>(
                                                                                          value: year,
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                                            child: Text(year.toString()),
                                                                                          ),
                                                                                        );
                                                                                      }).toList(),
                                                                                      onChanged: (int? newValue) async {
                                                                                        setState(() {
                                                                                          selectedYear = newValue!;
                                                                                          totalapagar = 0.0;
                                                                                        });
                                                                                        await getPays(selectedYear);
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                                                                child: Text(
                                                                                  'Saldo pendiente: \$$pendingAmount',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontFamily: 'Helvetica',
                                                                                    color: Color.fromARGB(255, 17, 16, 85),
                                                                                    fontSize: MediaQuery.of(context).size.height * 0.015,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.6,
                                                                    child: FutureBuilder<
                                                                        ListView>(
                                                                      future: getPays(
                                                                          selectedYear),
                                                                      builder: (BuildContext
                                                                              context,
                                                                          AsyncSnapshot<ListView>
                                                                              snapshot) {
                                                                        return snapshot.hasData
                                                                            ? snapshot.data!
                                                                            : Center(
                                                                                child: CircularProgressIndicator(),
                                                                              );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                contentPagosbtn()
                                              ],
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.monetization_on),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Estado de cuenta',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: IconButton(
                          color: Color.fromARGB(45, 243, 243, 243),
                          iconSize: 60,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel_outlined)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget estadoCuentaTxt() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Color.fromARGB(255, 17, 16, 85)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'ESTADO DE CUENTA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        color: Color.fromARGB(255, 17, 16, 85),
                      ),
                    ),
                  ),
                ),
                // Espacio vacío para centrar el texto
                SizedBox(
                    width: 48), // Ajusta este valor según el tamaño del icono
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
            child: Text(
              'Selecciona los conceptos para realizar el pago',
              style: TextStyle(
                color: Color.fromARGB(255, 17, 16, 85),
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.015,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contentPagosbtn() {
    return Container(
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Color.fromRGBO(1, 29, 69, 1)),
                    onPressed: () {
                      _showTotalContainer(context, totalapagar);
                    },
                    child: Text("Pagar Ahora",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.06))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
