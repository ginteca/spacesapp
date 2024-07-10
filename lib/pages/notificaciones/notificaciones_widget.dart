import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Notificaciones extends StatefulWidget {
  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  List<String> notificaciones = [];

  @override
  void initState() {
    super.initState();
    cargarNotificaciones();
  }

  void cargarNotificaciones() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificaciones = prefs.getStringList('notificaciones') ?? [];
    });
  }

  void eliminarNotificacion(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notificaciones.removeAt(index);
    await prefs.setStringList('notificaciones', notificaciones);
    cargarNotificaciones();
  }

  void eliminarTodasLasNotificaciones() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notificaciones', []);
    cargarNotificaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 16, 145),
        title: Text("Notificaciones"),
      ),
      backgroundColor: Colors.white, // Fondo blanco para la pantalla
      body: ListView.builder(
        itemCount: notificaciones.length,
        itemBuilder: (context, index) {
          var notificacion = json.decode(notificaciones[index]);
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.bell), // O el ícono que prefieras
              title: Text('NUEVA NOTIFICACIÓN'), // Título estático
              subtitle: Text(notificacion['cuerpo']),
              trailing: Wrap(
                spacing: 12, // Espacio entre los botones
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => eliminarNotificacion(index),
                  ),
                  // Otros botones que desees añadir
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 3, 16, 145),
        onPressed: eliminarTodasLasNotificaciones,
        tooltip: 'Eliminar todas',
        child: Icon(
          Icons.delete_sweep,
          color: Colors.white,
        ),
      ),
    );
  }
}
