import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../flutter_flow/flutter_flow_theme.dart';
import '../inicio/inicio_widget.dart';

class charlybot extends StatefulWidget {
  final idUser;
  final responseJson;

  const charlybot({Key? key, required this.idUser, required this.responseJson});

  @override
  _charlybot createState() => _charlybot();
}

final List<ChatMessage> _messages = <ChatMessage>[];

class _charlybot extends State<charlybot> {
  Future<String> obtenerRespuesta(String pregunta, String usuarioId) async {
    print('ejecuatndo ' + pregunta + usuarioId);
    final baseUrl =
        'https://habitantbot.azurewebsites.net'; // Reemplaza con la URL de tu servidor
    final uri = Uri.parse('$baseUrl/bot');
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'pregunta': pregunta,
      'usuario_id': usuarioId,
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('consumio bien la api');
        final jsonResponse = json.decode(response.body);
        print('hasta aqui llego pa');
        print('bot' + jsonResponse['respuesta']);
        ChatMessage messageBot = ChatMessage(
          text: jsonResponse['respuesta'],
          isUserMessage: false,
          image: "https://jaus.blob.core.windows.net/external/charlyLogo.png",
        );
        setState(() {
          _messages.insert(0, messageBot);
        });
        return jsonResponse['respuesta'] ?? 'No se encontró una respuesta.';
      } else {
        print('consumio bien la api');
        return 'Error en la solicitud: ${response.reasonPhrase}';
      }
    } catch (e) {
      print('error consumiendo');
      return 'Error: $e';
    }
  }

  late String _imagenProfile;

  @override
  void initState() {
    super.initState();
    _messages.clear();
    String dataUser = widget.responseJson['Data'][0]['Value'];
    Map<String, dynamic> data0 = jsonDecode(dataUser);
    _imagenProfile = data0['ImageProfile'];
  }

  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUserMessage: true,
      image: _imagenProfile,
    );
    setState(() {
      _messages.insert(0, message);
      obtenerRespuesta(text, "2");
    });
  }

  void _handleSubmittedBot(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUserMessage: false,
      image: _imagenProfile,
    );
    setState(() {
      _messages.insert(0, message);
      obtenerRespuesta(text, "2");
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: "Enviar un mensaje",
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _handleSubmitted(_textController.text);
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buttonsBackHome(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              charlyContent(),
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, int index) => _messages[index],
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _buildTextComposer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonsBackHome() {
    final responseJson = widget.responseJson;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
          child: IconButton(
              //rgba(44, 255, 226, 1)
              color: Color.fromRGBO(44, 255, 226, 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'AVISOS Y REPORTES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
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
        )
      ],
    );
  }

  Widget charlyContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.21,
              child: Image.asset('assets/images/charlyLogo.png'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Container(
                child: Text(
                  '¡Hola soy Charly!',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 47, 134, 255)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.0,
                bottom: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Container(
                child: Text(
                  '¿Tienes un problema?',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(
              child: Text(
                '¿COMO TE PUEDO AYUDAR?',
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 50, 120, 1)),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final String image;

  ChatMessage(
      {required this.text, this.isUserMessage = false, required this.image});

  @override
  Widget build(BuildContext context) {
    // Definir la alineación del mensaje en función de si es del usuario actual o no
    final alignment =
        isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

    // Definir el color de fondo del contenedor del mensaje
    final bgColor =
        isUserMessage ? Color.fromARGB(255, 9, 63, 107) : Colors.grey;

    // Definir el color del texto del mensaje
    final textColor = isUserMessage ? Colors.white : Colors.black;

    final imagen = image;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: CircleAvatar(
              foregroundImage: NetworkImage(imagen),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: bgColor, // Color de fondo del contenedor
                borderRadius: BorderRadius.circular(
                    10.0), // Radio de borde para hacerlo redondeado
              ),
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              padding: EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
