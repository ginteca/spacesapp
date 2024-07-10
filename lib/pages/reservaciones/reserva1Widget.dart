import 'dart:convert';
import 'package:spacesclub/pages/reservaciones/reservaWidget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FacilitySelectionScreen extends StatefulWidget {
  final List<Facility> facilities;

  FacilitySelectionScreen({Key? key, required this.facilities})
      : super(key: key);

  @override
  _FacilitySelectionScreenState createState() =>
      _FacilitySelectionScreenState();
}

class _FacilitySelectionScreenState extends State<FacilitySelectionScreen> {
  String selectedFacilityType = '';
  int _selectedFacilityId = 0;
  DateTime? _selectedDate;
  List<Map<String, dynamic>>? _availability;
  int? _startHourIndex;
  int? _endHourIndex;
  TextEditingController _descriptionController = TextEditingController();
  final CarouselController _controller = CarouselController();
  bool _isLoading = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (widget.facilities.isNotEmpty) {
      _selectedFacilityId = widget.facilities.first.id;
      selectedFacilityType = widget.facilities.first.type;
      _selectedDate = DateTime.now();
      showAvailability(context, _selectedFacilityId, _selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Crear Reservación'),
        centerTitle: true,
        backgroundColor: Color(0xFF011D45),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/FONDO_GENERAL.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                widget.facilities.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(135.0),
                        child: Text(
                          'Actualmente tu asociación no cuenta con instalaciones para reservar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Helvetica',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : buildCarouselSlider(),
                buildDateSelectionButton(),
                buildDescriptionField(),
                if (_selectedFacilityId != 29 && _selectedFacilityId != 30)
                  availabilityWidgets(),
                createReservationButton(),
              ],
            ),
          ),
          if (_isProcessing)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Stack buildCarouselSlider() {
    var screenSize = MediaQuery.of(context).size;
    double carouselHeight;
    if (screenSize.width < 600) {
      carouselHeight = screenSize.height * 0.35;
    } else if (screenSize.width < 900) {
      carouselHeight = screenSize.height * 0.45;
    } else {
      carouselHeight = screenSize.height * 0.5;
    }

    return Stack(
      children: <Widget>[
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.facilities.length,
          itemBuilder: (context, index, realIndex) {
            return buildFacilityWidget(widget.facilities[index]);
          },
          options: CarouselOptions(
            height: carouselHeight,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _selectedFacilityId = widget.facilities[index].id;
                showAvailability(context, _selectedFacilityId,
                    _selectedDate ?? DateTime.now());
              });
            },
          ),
        ),
        Positioned(
          left: 15,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon:
                Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: () => _controller.previousPage(
                duration: Duration(milliseconds: 300), curve: Curves.linear),
          ),
        ),
        Positioned(
          right: 15,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: () => _controller.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.linear),
          ),
        ),
      ],
    );
  }

  Widget buildFacilityWidget(Facility facility) {
    var screenSize = MediaQuery.of(context).size;
    double avatarRadius;
    double fontSize;
    double spacing;
    if (screenSize.width < 600) {
      avatarRadius = 80;
      fontSize = 15;
      spacing = 8;
    } else if (screenSize.width < 900) {
      avatarRadius = 40;
      fontSize = 16;
      spacing = 10;
    } else {
      avatarRadius = 50;
      fontSize = 18;
      spacing = 10;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFacilityId = facility.id;
          showAvailability(context, _selectedFacilityId, DateTime.now());
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: NetworkImage(facility.image),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(height: spacing),
          Text(
            facility.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: Color(0xFF011D45)),
          ),
          Text(
            facility.description,
            style:
                TextStyle(fontSize: fontSize * 0.9, color: Color(0xFF011D45)),
          ),
          Text(
            "Tipo: ${facility.type}",
            style:
                TextStyle(fontSize: fontSize * 0.9, color: Color(0xFF011D45)),
          ),
        ],
      ),
    );
  }

  ElevatedButton buildDateSelectionButton() {
    var screenSize = MediaQuery.of(context).size;
    double fontSize;
    EdgeInsetsGeometry padding;
    if (screenSize.width < 600) {
      fontSize = 14;
      padding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    } else if (screenSize.width < 900) {
      fontSize = 16;
      padding = EdgeInsets.symmetric(horizontal: 30, vertical: 15);
    } else {
      fontSize = 18;
      padding = EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    }

    return ElevatedButton(
      onPressed: () async {
        var pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2025),
          builder: (BuildContext context, Widget? child) =>
              Theme(data: ThemeData.light(), child: child!),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            showAvailability(context, _selectedFacilityId, pickedDate);
          });
        }
      },
      child: Text(
        _selectedDate == null
            ? 'Seleccionar Fecha'
            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
        style: TextStyle(fontSize: fontSize),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF011D45),
        onPrimary: Colors.white,
        padding: padding,
      ),
    );
  }

  Widget buildDescriptionField() {
    var screenSize = MediaQuery.of(context).size;
    double fontSize;
    EdgeInsetsGeometry padding;
    EdgeInsetsGeometry margin;
    if (screenSize.width < 600) {
      fontSize = 14;
      padding = EdgeInsets.symmetric(horizontal: 10, vertical: 10);
      margin = EdgeInsets.all(8);
    } else if (screenSize.width < 900) {
      fontSize = 16;
      padding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
      margin = EdgeInsets.all(10);
    } else {
      fontSize = 18;
      padding = EdgeInsets.symmetric(horizontal: 15, vertical: 15);
      margin = EdgeInsets.all(12);
    }

    return Padding(
      padding: margin,
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(color: Colors.black), // Color de las letras negras
        decoration: InputDecoration(
          labelText: 'Descripción',
          labelStyle: TextStyle(fontSize: fontSize, color: Color(0xFF011D45)),
          border: OutlineInputBorder(),
          contentPadding: padding,
        ),
      ),
    );
  }

  Widget availabilityWidgets() {
    if (_availability == null) return SizedBox();

    var screenSize = MediaQuery.of(context).size;
    int crossAxisCount;
    double childAspectRatio;
    EdgeInsets padding;
    double fontSize;
    if (screenSize.width < 600) {
      crossAxisCount = 4;
      childAspectRatio = 2;
      padding = EdgeInsets.symmetric(vertical: 8, horizontal: 12);
      fontSize = 12;
    } else if (screenSize.width < 900) {
      crossAxisCount = 4;
      childAspectRatio = 3;
      padding = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
      fontSize = 14;
    } else {
      crossAxisCount = 4;
      childAspectRatio = 4;
      padding = EdgeInsets.symmetric(vertical: 12, horizontal: 24);
      fontSize = 16;
    }

    double gridHeight = screenSize.height * 0.2;

    return Container(
      height: gridHeight,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _availability!.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> hour = _availability![index];
          bool isBusy = hour['Oclock']['Status'] == 'Busy' ||
              hour['Half']['Status'] == 'Busy';
          bool isSelected = _startHourIndex != null &&
              _endHourIndex != null &&
              index >= _startHourIndex! &&
              index <= _endHourIndex!;
          return ElevatedButton(
            onPressed:
                _isProcessing ? null : () => selectTimeSlot(index, isBusy),
            child: Text(
              hour['HourLabel'],
              style: TextStyle(fontSize: fontSize),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isBusy
                  ? Colors.red
                  : (isSelected ? Colors.blue[900] : Colors.green),
              foregroundColor: Colors.white,
              padding: padding,
            ),
          );
        },
        physics: BouncingScrollPhysics(),
      ),
    );
  }

  void selectTimeSlot(int idx, bool isBusy) {
    if (isBusy) return;

    DateTime now = DateTime.now();
    DateTime selectedTime =
        parseDateTimeFromLabel(_availability![idx]['HourLabel']);

    if (selectedTime.isBefore(now)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No puedes seleccionar un horario que ya ha pasado.'),
        ),
      );
      return;
    }

    setState(() {
      if (_startHourIndex != null && _endHourIndex != null) {
        if (idx == _startHourIndex && idx == _endHourIndex) {
          _startHourIndex = null;
          _endHourIndex = null;
        } else if (idx >= _startHourIndex! && idx <= _endHourIndex!) {
          _startHourIndex = null;
          _endHourIndex = null;
        } else {
          adjustSelection(idx);
        }
      } else {
        _startHourIndex = idx;
        _endHourIndex = idx;
      }

      if (_startHourIndex != null && _endHourIndex != null) {
        print(
            "Hora de inicio: ${_availability![_startHourIndex!]['HourLabel']}, Hora final: ${_availability![_endHourIndex!]['HourLabel']}");
      } else {
        print("Selección desactivada.");
      }
    });
  }

  void adjustSelection(int idx) {
    if (idx < _startHourIndex!) {
      _startHourIndex = idx;
    } else if (idx > _endHourIndex!) {
      _endHourIndex = idx;
    }
  }

  Widget createReservationButton() {
    return ElevatedButton(
      onPressed: _isProcessing ||
              (_selectedFacilityId != 29 &&
                  _selectedFacilityId != 30 &&
                  (_startHourIndex == null || _endHourIndex == null))
          ? null
          : () => createReservation(),
      child: Text('Crear Reservación'),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF011D45),
        onPrimary: Colors.white,
      ),
    );
  }

  Future<void> createReservation() async {
    setState(() {
      _isProcessing = true;
    });

    final prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('idUsuario');
    int? associationId = prefs.getInt('IdAssociation');

    if (idUser == null || associationId == null) {
      setState(() {
        _isProcessing = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Usuario o asociación no disponibles.'),
        ),
      );
      return;
    }

    DateTime startDate;
    DateTime endDate;
    int amount;

    if (_selectedFacilityId == 29 || _selectedFacilityId == 30) {
      startDate = DateTime(
          _selectedDate!.year, _selectedDate!.month, _selectedDate!.day, 0, 0);
      endDate = DateTime(_selectedDate!.year, _selectedDate!.month,
          _selectedDate!.day, 23, 59);
      amount = _selectedFacilityId == 29 ? 3000 : 2200;
    } else {
      var startHourLabel = _availability![_startHourIndex!]['HourLabel'];
      var endHourLabel =
          _availability![_endHourIndex ?? _startHourIndex!]['HourLabel'];
      startDate = parseDateTimeFromLabel(startHourLabel);
      endDate = parseDateTimeFromLabel(endHourLabel).add(Duration(hours: 1));
      amount = 250;

      if (associationId == 60) {
        if (_selectedFacilityId == 29) {
          amount = 3000;
        } else if (_selectedFacilityId == 30) {
          amount = 2200;
        } else if (_selectedFacilityId == 47) {
          amount = 250;
        }
      }
    }

    DateTime now = DateTime.now();
    if ((associationId == 60 || associationId == 69) &&
        startDate.isBefore(now)) {
      setState(() {
        _isProcessing = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'No puedes hacer una reservación para una fecha y hora que ya pasaron.'),
        ),
      );
      return;
    }

    if (associationId == 69 &&
        startDate.isBefore(now.add(Duration(hours: 48)))) {
      setState(() {
        _isProcessing = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'No puedes hacer una reservación con menos de 48 horas de anticipación.'),
        ),
      );
      return;
    }

    print("Debug: Starting reservation process");
    DateTime startTime = DateTime.now();

    if (associationId == 60 &&
        widget.facilities
                .firstWhere((facility) => facility.id == _selectedFacilityId)
                .type ==
            'Privada') {
      var pruebaUrl =
          Uri.parse('https://netpayhab.azurewebsites.net/prueba.php');
      DateTime apiStartTime = DateTime.now();
      var pruebaResponse = await http.post(pruebaUrl, body: {
        'idUser': idUser,
        'FacilityId': _selectedFacilityId.toString(),
        'DateStart': DateFormat('dd/MM/yyyy HH:mm:ss').format(startDate),
        'DateFinish': DateFormat('dd/MM/yyyy HH:mm:ss').format(endDate),
        'Description': _descriptionController.text,
        'amount': amount.toString(),
        'quantity': '1', // Cantidad para todo el día
        'firstName': 'Jon',
        'lastName': 'Doe',
      });

      DateTime apiEndTime = DateTime.now();
      print(
          "Debug: API call completed in ${apiEndTime.difference(apiStartTime).inMilliseconds} ms");

      if (pruebaResponse.statusCode == 200) {
        String checkoutUrl = pruebaResponse.body.trim();
        print('Debug: Trying to launch URL: $checkoutUrl');
        try {
          await launchUrl(
            Uri.parse(checkoutUrl),
            mode: LaunchMode.externalApplication,
          );

          // Mostrar modal después del proceso de pago
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Proceso finalizado'),
              content: Text('Proceso Terminado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el modal
                    Navigator.of(context)
                        .pop('updated'); // Regresa a la pantalla anterior
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } catch (e) {
          print('Debug: Could not launch URL: $checkoutUrl');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(
                  'No se pudo iniciar el proceso de pago. URL no válida: $checkoutUrl'),
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo iniciar el proceso de pago.'),
          ),
        );
      }
    } else {
      var url = Uri.parse(
          'https://appaltea.azurewebsites.net/api/Mobile/SaveReservation');
      var response = await http.post(url, body: {
        'idUser': idUser,
        'FacilityId': _selectedFacilityId.toString(),
        'DateStart': DateFormat('dd/MM/yyyy HH:mm:ss').format(startDate),
        'DateFinish': DateFormat('dd/MM/yyyy HH:mm:ss').format(endDate),
        'Description': _descriptionController.text,
      });

      DateTime apiEndTime = DateTime.now();
      print(
          "Debug: API call completed in ${apiEndTime.difference(startTime).inMilliseconds} ms");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['Type'] == 'Success') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Reservación Creada'),
              content: Text('Tu reservación ha sido creada exitosamente.'),
            ),
          ).then((_) => Navigator.of(context).pop('updated'));
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(responseData['Message']),
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error de Red'),
            content: Text(
                'No fue posible realizar la reservación. Intente de nuevo.'),
          ),
        );
      }
    }

    setState(() {
      _isProcessing = false;
    });
  }

  DateTime parseDateTimeFromLabel(String timeLabel) {
    int hour = int.parse(timeLabel.split(':')[0]);
    int minute = timeLabel.contains('30') ? 30 : 0;

    if (timeLabel.contains('PM') && hour != 12) {
      hour = (hour % 12) + 12;
    }

    DateTime dateTime = DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, hour, minute);

    return dateTime;
  }

  void showAvailability(
      BuildContext context, int facilityId, DateTime selectedDate) async {
    print("showAvailability called");
    try {
      final prefs = await SharedPreferences.getInstance();

      String? idUser = prefs.getString('idUsuario');

      if (idUser == null) {
        throw Exception('No se pudo cargar el idUser de SharedPreferences');
      }

      var formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      print('Fecha formateada: $formattedDate');

      var url = Uri.parse(
          'https://appaltea.azurewebsites.net/api/Mobile/GetDisponibility');
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var body =
          'idUser=$idUser&FacilityId=$facilityId&DateTimeReservation=$formattedDate';

      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print(facilityId);
        var jsonData = json.decode(response.body);
        var disponibilityData = jsonData['Data']?.firstWhere(
          (element) => element['Name'] == 'Disponibility',
          orElse: () => null,
        );

        if (disponibilityData != null) {
          var availabilityStr = disponibilityData['Value'];
          var availabilityList = json.decode(availabilityStr) as List<dynamic>;

          if (availabilityList.isNotEmpty) {
            setState(() {
              _availability = availabilityList
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList();

              if (facilityId == 29 || facilityId == 30) {
                bool isFullDayAvailable = _availability!.every((hour) =>
                    hour['Oclock']['Status'] == 'Enabled' &&
                    hour['Half']['Status'] == 'Enabled');

                if (isFullDayAvailable) {
                  _startHourIndex = 0;
                  _endHourIndex = _availability!.length - 1;
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Día No Disponible'),
                            content: Text(
                                'El día seleccionado no está disponible para reserva completa.'),
                          ));
                }
              }
            });
          } else {
            if (facilityId == 29 || facilityId == 30) {
              _startHourIndex = 0;
              _endHourIndex = 23; // Representa todo el día disponible
              setState(() {
                _availability = List.generate(
                    24,
                    (index) => {
                          'HourLabel':
                              '${index % 12 == 0 ? 12 : index % 12}:00 ${index < 12 ? 'AM' : 'PM'}',
                          'Oclock': {'Status': 'Enabled'},
                          'Half': {'Status': 'Enabled'}
                        });
              });
            } else {
              setState(() => _availability = []);
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Horarios No Disponibles'),
                        content: Text(
                            'No hay horarios disponibles para la fecha seleccionada.'),
                      ));
            }
          }
        } else {
          setState(() => _availability = []);
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text(
                        'No se encontraron datos de disponibilidad para la fecha seleccionada.'),
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text(
                      'Error al obtener disponibilidad: ${response.reasonPhrase}'),
                ));
      }
    } catch (e) {
      print("Exception caught: $e");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('Error en la solicitud HTTP: $e'),
              ));
    }
  }
}
