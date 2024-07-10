import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../pages/inicio/inicio_widget.dart';
import '../../components/misPagosModal.dart';

class SubpagoWidget extends StatefulWidget {
  final List<PaymentItem> paymentItems;
  final responseJson;
  final idUsuario;
  final idPropiedad;

  const SubpagoWidget({
    Key? key,
    required this.paymentItems,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  }) : super(key: key);

  @override
  _SubpagoWidgetState createState() => _SubpagoWidgetState();
}

class _SubpagoWidgetState extends State<SubpagoWidget> {
  late String _IdUsuario = widget.idUsuario;
  late String idUser;
  late String propertyId;
  List<String> mformaPagoList = [
    'Efectivo',
    'T. Debito',
    'T. Credito',
    'Transferencia'
  ];
  String? selectedPago;
  final _monthController = TextEditingController();

  File? selectedImage;
  File? image;
  bool isLoading = false;

  void _resetSelected() {
    setState(() {
      selectedImage = null;
    });
  }

  void _resetTakePhoto() {
    setState(() {
      image = null;
    });
  }

  final _token = TextEditingController();
  final _alias = TextEditingController();
  final _street = TextEditingController();
  final _numExt = TextEditingController();
  final _numInt = TextEditingController();
  final _zipCode = TextEditingController();

  Future<void> _openImagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      await _takePicture();
    } else {
      // El usuario denegó el permiso de la cámara, puedes mostrar un mensaje o realizar alguna otra acción.
      print('Permiso de cámara denegado');
    }
  }

  Future<void> _requestGalleryPermission() async {
    final PermissionStatus status = await Permission.photos.request();
    if (status.isGranted) {
      await _openImagePicker();
    } else {
      // El usuario denegó el permiso de la galería, puedes mostrar un mensaje o realizar alguna otra acción.
      print('Permiso de galería denegado');
    }
  }

  @override
  void initState() {
    super.initState();
    selectedImage = null;
    isLoading = false;
    image = null;
  }

  Future<String> enviarImagenPagos() async {
    final apiUrl =
        'https://appaltea.azurewebsites.net/api/Mobile/UploadImagePayment/';
    // USUARIO
    String _idUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(_idUser);
    idUser = data0['Id'].toString();
    // PROPIEDAD
    String _idProperty = widget.responseJson['Data'][1]['Value'];
    Map<String, dynamic> data1 = jsonDecode(_idProperty);
    propertyId = data1['Id'].toString();
    List<PaymentItem> paymentItem = widget.paymentItems;
    // Metodo de pago
    String? mPago = _monthController.text;
    print("$mPago");
    print("$idUser");

    Map<String, int> mesesMap = {
      'Enero': 1,
      'Febrero': 2,
      'Marzo': 3,
      'Abril': 4,
      'Mayo': 5,
      'Junio': 6,
      'Julio': 7,
      'Agosto': 8,
      'Septiembre': 9,
      'Octubre': 10,
      'Noviembre': 11,
      'Diciembre': 12,
    };

    List<Map<String, dynamic>> paymentsJsonList = [];
    for (var paymentItem in paymentItem) {
      int mes = mesesMap[paymentItem.mes] ?? 0;
      paymentsJsonList.add({
        "Payment": paymentItem.payment,
        "MonthPay": mes,
        "YearPay": paymentItem.anio,
        "IdPaymentAssociation": paymentItem.idPayment,
        "PendingAmountPayment": paymentItem.payment,
        "Surcharge": 0.0,
        "Subtotal": paymentItem.payment,
        "Name": "Payment 1",
        "AditionalInfo": "Additional Info 1"
      });
    }

    // Convertir la lista de objetos JSON a una cadena JSON
    String paymentJson = jsonEncode(paymentsJsonList);

    Map<String, String> data = {
      'idUser': idUser,
      'PropertyId': propertyId,
      'paymentMethod': mPago,
      'Payments': paymentJson
    };

    // Crear la solicitud HTTP multipart con el formulario y la imagen adjunta
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Agregar los campos del formulario al cuerpo de la solicitud
    request.fields.addAll(data);

    // Agregar la imagen si está disponible
    if (selectedImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', selectedImage!.path));
    } else if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('file', image!.path));
    }

    // Enviar la solicitud
    var response = await request.send();

    // Leer la respuesta de la solicitud
    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseString);
      enviarDatosModal();
      print('hello buey');
      print(jsonResponse);
      print("$selectedImage");
      return jsonResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  void enviarDatosModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isFinished = false;
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: Color.fromARGB(255, 0, 12, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27.0), // Bordes redondeados
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.33,
                width: MediaQuery.of(context).size.width * 1.4,
                child: Column(
                  children: [
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
                        'Se han enviado los datos correctamente',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InicioWidget(
                                responseJson: widget.responseJson,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Helvetica',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ); //accesosModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/FONDO_GENERAL.jpg'),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                buttonsBackHome(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                contentList(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                contenImagen(),
                functionMetodoPago(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                dialogboton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
        itemCount: widget.paymentItems.length,
        itemBuilder: (context, index) {
          PaymentItem paymentItem = widget.paymentItems[index];
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.width * 0.00,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(68, 0, 12, 52),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    paymentItem.mes,
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      color: Color(0xFF011D45),
                                    ),
                                  ),
                                  Text(
                                    paymentItem.anio,
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      color: Color(0xFF011D45),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                paymentItem.nombre,
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: Color(0xFF011D45),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.004,
                              ),
                              Text(
                                'Pago: ${paymentItem.payment.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Color(0xFF011D45),
                                  fontFamily: 'Helvetica',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.032,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buttonsBackHome() {
    final responseJson = widget.responseJson;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
          child: IconButton(
            //rgba(44, 255, 226, 1)
            color: Color.fromRGBO(44, 255, 226, 1),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InicioWidget(
                    responseJson: widget.responseJson,
                  ),
                ),
              );
            },
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'Subir Pagos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
          child: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
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
        ),
      ],
    );
  }

  Widget functionMetodoPago() {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05,
        top: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.05,
        bottom: MediaQuery.of(context).size.width * 0.00,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 12, 52),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 15.0,
                ),
                dropdownColor: Color.fromARGB(255, 0, 12, 52),
                value: selectedPago,
                onChanged: (newValue) {
                  setState(() {
                    selectedPago = newValue;
                    _monthController.text = newValue!;
                  });
                },
                hint: Text(
                  "    Metodo de Pago",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Helvetica',
                  ),
                ),
                items: mformaPagoList.map((String metodo) {
                  return DropdownMenuItem<String>(
                    value: metodo,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        top: MediaQuery.of(context).size.width * 0.0,
                        right: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.width * 0.00,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(metodo),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contenImagen() {
    return Container(
      child: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tomarFoto(() {
                  setState(() {
                    _resetSelected();
                  });
                }),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                seleccionarFoto(selectedImage, () {
                  setState(() {
                    _resetTakePhoto();
                  });
                }),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          Center(
            child: Text(
              "Selecciona una imagen",
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tomarFoto(Function()? callback) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Color.fromARGB(66, 1, 29, 69),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                if (image != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Transform.scale(
                          scale:
                              2.0, // Factor de escala para agrandar la imagen
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          _requestCameraPermission();
                        },
                      ),
                    ],
                  )
                else
                  Icon(Icons.camera_alt, color: Colors.white),
              ],
            ),
            onPressed: () {
              _requestCameraPermission();
            },
          ),
        ],
      ),
    );
  }

  Widget seleccionarFoto(File? selectedImage, VoidCallback setStateCallback) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Color.fromARGB(66, 1, 29, 69),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                if (selectedImage != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Transform.scale(
                          scale: 1.5,
                          child: Image.file(
                            selectedImage,
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 1,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          _requestGalleryPermission();
                        },
                      ),
                    ],
                  )
                else
                  Icon(Icons.photo_library, color: Colors.white),
              ],
            ),
            onPressed: () {
              _requestGalleryPermission();
            },
          ),
        ],
      ),
    );
  }

  Widget dialogboton() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF011D45),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
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
                backgroundColor: Color.fromARGB(255, 0, 12, 52),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(27.0), // Bordes redondeados
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.33,
                      width: MediaQuery.of(context).size.width * 1.4,
                      child: Column(
                        children: [
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
                              '¿Deseas enviar los datos de tus pagos?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
                                setState(() {
                                  isLoading = true;
                                });
                                await enviarImagenPagos();
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  : Text(
                                      "GUARDAR",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Helvetica',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                      ),
                                    ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white,
                                ),
                              ),
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
                              child: Text(
                                "CANCELAR",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Helvetica',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ); //accesosModal();
            },
          );
        },
        child: Text(
          "GUARDAR",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
