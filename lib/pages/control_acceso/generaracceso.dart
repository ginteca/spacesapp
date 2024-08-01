import 'package:flutter/material.dart';
import 'package:spacesclub/pages/control_acceso/contolpage.dart';



class GenerarAccesoPage extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;

  const GenerarAccesoPage({
    Key? key,
    required this.responseJson,
    required this.idPropiedad,
    required this.idUsuario,
  }) : super(key: key);
  @override
  State<GenerarAccesoPage> createState() => _GenerarAccesoPageState();
}

class _GenerarAccesoPageState extends State<GenerarAccesoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Acción de retroceso
          },
        ),
        title: Text('GENERAR ACCESO'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(3, 16, 145, 1),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/FONDO_GENERAL.jpg'), // Ruta de tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Spacer(flex: 1), // Espacio libre del 25%
              Expanded(
                flex: 3, // El formulario ocupará el 75%
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.0),
                          Text(
                            'Rellena el siguiente formulario para continuar:',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Apellido',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Marca de Vehículo',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Placas',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Selecciona el tipo de visita:',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 100,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Acción de invitación personal
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.mail, color: Colors.white),
                                        SizedBox(height: 8),
                                        Text(
                                          'Invitación Personal',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Acción de greenfee
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.golf_course,
                                            color: Colors.white),
                                        SizedBox(height: 8),
                                        Text(
                                          'Greenfee',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '4 accesos disponibles',
                                          style:
                                              TextStyle(color: Colors.purple),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.0),
                          Center(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Aquí puedes agregar la lógica para verificar el acceso a la URL
                                    bool hasAccess =
                                        false; // Suponiendo que no tiene acceso

                                    if (!hasAccess) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'No tienes acceso a www.habitan-t.com/API/MOBILE/ACCESOSPACES, ora'),
                                            actions: [
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      // Lógica en caso de tener acceso
                                    }
                                  },
                                  child: Text('GENERAR ACCESO'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.purple,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    textStyle: TextStyle(fontSize: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    // Aquí puedes agregar la lógica para verificar el acceso a la URL
                                    bool hasAccess =
                                        true; // Suponiendo que no tiene acceso

                                    if (!hasAccess) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'No tienes acceso a www.habitan-t.com/API/MOBILE/ACCESOSPACES ora jajaj'),
                                            actions: [
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      
                                       Navigator.push(context, MaterialPageRoute(
                                         builder: (context) => ControlAccesoPage(
                                           responseJson: widget.responseJson, idPropiedad: widget.idPropiedad, idUsuario: widget.idUsuario
                                           )
                                         ));
                                    }
                                  },
                                  child: Text('VER HISTORIAL DE CÓDIGOS'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[900],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    textStyle: TextStyle(fontSize: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
