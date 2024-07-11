import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUserMessage: true, // Indica si el mensaje es del usuario actual
    );
    setState(() {
      _messages.insert(0, message);
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
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat de Flutter"),
        backgroundColor: Color.fromRGBO(3, 16, 145, 1),
      ),
      body: Column(
        children: <Widget>[
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
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, this.isUserMessage = false});

  @override
  Widget build(BuildContext context) {
    // Definir la alineación del mensaje en función de si es del usuario actual o no
    final alignment = isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

    // Definir el color de fondo del contenedor del mensaje
    final bgColor = isUserMessage ? Colors.blue : Colors.grey;

    // Definir el color del texto del mensaje
    final textColor = isUserMessage ? Colors.white : Colors.black;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: CircleAvatar(
              child: Text("Usuario"),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: bgColor,
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
