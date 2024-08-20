import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacesclub/components/buttons/UserButton.dart';
import 'package:spacesclub/pages/codigoqr/crearcodigo_widget.dart';


class mensajeModal extends StatefulWidget {
  final responseJson;
  final idUsuario;
  final idPropiedad;
  const mensajeModal({
    Key? key,
    required this.responseJson,
    required this.idUsuario,
    required this.idPropiedad,
  });
  @override
  _mensajeModalState createState() => _mensajeModalState();
}

class _mensajeModalState extends State<mensajeModal> {
  final String apiSaveComments =
      "https://appaltea.azurewebsites.net/api/Mobile/SaveReplayCommmentboxUser/";
  List<dynamic> usuarios = [];
  late Map<String, dynamic> association;
  late String selectedUserId= "";
  late String selectedUserName = "";
  late String selectedUserPropertyName= "";
  late String commenBuzon;


  Future<bool> _PartnerModal() async {
    final result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Color.fromARGB(255, 243, 243, 243),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27.0),
              ),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState){
                  return Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    children: [
                      // El contenido de tu Dialog aquí
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 159, 159, 159),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(27),
                            topRight: Radius.circular(27),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    size: 20,
                                    color: Color.fromARGB(255, 160, 58, 251),
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 68, 68, 68),
                                      ),
                                    ],
                                  ),
                                  iconSize: 30,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "MENSAJE A SOCIO",
                                style: TextStyle(
                                  color: Color(0xFF011D45),
                                  fontSize: 12,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 70,
                            ),
                            Text(
                              selectedUserName.isEmpty
                                  ? "Nombre del usuario"
                                  : selectedUserName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF011D45),
                              ),
                            ),
                            Text(
                              selectedUserPropertyName.isEmpty
                                  ? "Propiedad"
                                  : selectedUserPropertyName,
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF011D45),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.008,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        commenBuzon = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color.fromARGB(68, 0, 12, 52),
                                      hintText: 'Escribe una respuesta',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.006,
                            ),
                            Text(
                              "Tu respuesta solo sera visible para el socio seleccionado",
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Helvetica',
                                color: Color(0xFF4D4D4D),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                selectedUserName.isEmpty
                                  ?_openUserSelectionDialog():enviarComment();
                                },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 160, 58, 251),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34),
                                  ),
                                ),
                              ),
                              child: Text(selectedUserName.isEmpty
                                  ? "Seleccionar Socio"
                                  : "Enviar",),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.001,
                            ),
                            selectedUserName.isEmpty
                                  ?SizedBox(
                              height: MediaQuery.of(context).size.height * 0.001,
                            ):ElevatedButton(
                              onPressed: () {
                                _fetchUsuarios();
                                _openUserSelectionDialog();
                                },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 160, 58, 251),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34),
                                  ),
                                ),
                              ),
                              child: const Text("Seleccionar otro socio"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
          }),
            );
          },
        );
        return result;
  }


  void _openUserSelectionDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(118, 65, 85, 240),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27.0),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              children: [
                Expanded(
                  child: usuarios.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: usuarios.length,
                          itemBuilder: (context, index) {
                            final usuario = usuarios[index];
                            final userNeighbor = usuario['UserNeighbor'];
                            final property = usuario['Property'];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: UserButton(
                                nombre: userNeighbor['Name'],
                                cargo: property['RolesUser']
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                                direccion: property['Street'] +
                                    ' ' +
                                    property['NumExt'].toString(),
                                onTap: () { 
                                  Navigator.pop(context, { 
                                    'id': userNeighbor['Id'].toString(),
                                    'name': userNeighbor['Name'].toString(),
                                    'property': (property['Street'] + ' ' + property['NumExt'].toString()).toString(),
                                  });
                                  Navigator.of(context).pop(true);
                                  _PartnerModal();
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedUserId = result['id']!;
        selectedUserName = result['name']!;
        selectedUserPropertyName = result['property']!;
      });
    }
  }

  void setUser(String idUser, String nameUser, String nameProperty)async {
    setState(() {
      selectedUserId = idUser;
      selectedUserName = nameUser;
      selectedUserPropertyName = nameProperty;
      print("el boooo");
      print(selectedUserPropertyName);
      Navigator.of(context).pop(true); // Cerrar el diálogo secundario y devolver true

    });
  }

  void enviarDatosModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          bool isFinished = false;
          return Dialog(
            alignment: Alignment.center,
            backgroundColor: Color.fromARGB(255, 197, 197, 197),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.0), // Bordes redondeados
            ),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.33,
                width: MediaQuery.of(context).size.width * 1.4,
                child: Column(children: [
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
                          color: Color.fromARGB(255, 2, 38, 106)),
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
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);

                      },
                      child: Text("Ok",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontFamily: 'Helvetica',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          )),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color.fromARGB(255, 113, 2, 144))),
                    ),
                  ),
                ]),
              );
            }),
          ); //accesosModal();
        });
  }
  

  Future<String> enviarComment() async {
    

    Map<String, String> data = {
      'idUser': widget.idUsuario,
      'PropertyId': widget.idPropiedad,
      'CommentboxId': selectedUserId.toString(),
      'Comment': commenBuzon,
    };

    final response = await http.post(Uri.parse(apiSaveComments),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data);

    if (response.statusCode == 200) {
      var codeApiResponse = jsonDecode(response.body);
      print(codeApiResponse);
      enviarDatosModal();
      return codeApiResponse;
    } else {
      throw Exception('Error al realizar la petición POST');
    }
  }

  @override
  void initState() {
    super.initState();
    // Parse the responseJson to access the Association property
    var lastPropertyJson = widget.responseJson['Data'].firstWhere((element) => element['Name'] == 'LastProperty')['Value'];
    Map<String, dynamic> lastPropertyMap = jsonDecode(lastPropertyJson);
    association = lastPropertyMap['Assocation'];

    _fetchUsuarios(); 
    
  }

  Future<void> _fetchUsuarios() async {
    List<dynamic> data;
    print("obteniendo usuarios");
    final url = Uri.parse('https://appaltea.azurewebsites.net/api/Mobile/GetUsersVigilant');
    final headers = {"Content-Type": "application/x-www-form-urlencoded"};
    final body = {
      "idUser": widget.idPropiedad.toString(),
      "AssociationId": association['Id'].toString(),
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          data = jsonResponse['Data'] ?? [];
          final data2 = data[0]['Value'];
          usuarios = jsonDecode(data2);
          
          
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Container(
    child: ElevatedButton(
      onPressed: () async {
        bool? userSelected = _PartnerModal() as bool?;
      },
      child: Text(
        "Mensaje a socio",
        style: TextStyle(
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(150, 30)),
        backgroundColor: MaterialStateProperty.all<Color>(
          Color.fromARGB(255, 160, 58, 251),
        ),
      ),
    ),
  );
}
}
