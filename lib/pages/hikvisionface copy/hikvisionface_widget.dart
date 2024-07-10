import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:http_parser/http_parser.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> enviarImagen() async {
    final uri = Uri.parse(
        'http://4.151.55.143/ISAPI/Intelligent/FDLib/FaceDataRecord?format=json&devIndex=37623F1A-7D9D-6940-9D7D-DC6F69245789');
    final username = 'admin';
    final password = 'Airton2023';

    // Realiza una solicitud inicial para obtener el nonce
    final initialResponse = await http.post(uri, headers: {
      'Authorization':
          'Digest username="$username", realm="", nonce="", uri="${uri.path}", response=""'
    });

    if (initialResponse.statusCode == 401) {
      final wwwAuthenticate = initialResponse.headers['www-authenticate'];
      if (wwwAuthenticate != null) {
        final authDetails = parseDigestHeader(wwwAuthenticate);
        final cnonce = generateCnonce();
        final nc = '00000001'; // Debe incrementarse con cada solicitud
        final responseDigest = generateDigestResponse(
          username: username,
          password: password,
          method: 'POST',
          uri: uri.path,
          qop: authDetails['qop']!,
          nonce: authDetails['nonce']!,
          nc: nc,
          cnonce: cnonce,
          realm: authDetails['realm']!, // Pasar el valor del realm aquí
        );
        var boundary =
            '----FlutterBoundary${DateTime.now().millisecondsSinceEpoch}';
        final authorizationHeader = constructAuthorizationHeader(
          username: username,
          realm: authDetails['realm']!,
          nonce: authDetails['nonce']!,
          uri: uri.path,
          qop: authDetails['qop']!,
          nc: nc,
          cnonce: cnonce,
          responseDigest: responseDigest,
          opaque: authDetails['opaque'] ?? '',
        );

        var request = http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = authorizationHeader
          ..headers['Content-Type'] = 'multipart/form-data; boundary=$boundary'
          ..fields['data'] = '{"FaceInfo": {"employeeNo": "9"}}';

        if (_image != null) {
          try {
            request.files.add(http.MultipartFile(
              'image',
              _image!.readAsBytes().asStream(),
              await _image!.length(),
              filename: _image!.path.split("/").last,
              contentType: MediaType('image', 'jpeg'),
            ));
          } catch (e) {
            print('Error al agregar el archivo a la solicitud: $e');
          }
        }

        try {
          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          if (response.statusCode == 200) {
            print("Imagen enviada exitosamente");
          } else {
            print('Error al enviar la imagen: ${response.statusCode}');
            print('Razón: ${response.reasonPhrase}');
            print('Cuerpo de la respuesta: ${response.body}');
          }
        } catch (e) {
          print('Error al realizar la solicitud: $e');
        }
      } else {
        print('WWW-Authenticate header not found');
      }
    } else {
      print(
          'Initial request failed with status: ${initialResponse.statusCode}');
    }
  }
  // ...

// Función para generar un cnonce aleatorio para la autenticación digest
  String generateCnonce() {
    var rand = Random.secure();
    var values = List<int>.generate(16, (i) => rand.nextInt(256));
    return base64Url.encode(values);
  }

// Función para parsear el encabezado WWW-Authenticate y extraer los valores para digest authentication
  Map<String, String> parseDigestHeader(String headerValue) {
    final regExp = RegExp(r'(\w+)="(.*?)"');
    final matches = regExp.allMatches(headerValue);
    Map<String, String> values = {};
    for (final match in matches) {
      values[match.group(1)!] = match.group(2)!;
    }
    return values;
  }

// Función para generar el response digest para la autenticación digest
  String generateDigestResponse({
    required String username,
    required String password,
    required String method,
    required String uri,
    required String qop,
    required String nonce,
    required String nc,
    required String cnonce,
    required String realm, // Asegúrate de pasar este parámetro a la función
  }) {
    final ha1 =
        md5.convert(utf8.encode('$username:$realm:$password')).toString();
    final ha2 = md5.convert(utf8.encode('$method:$uri')).toString();
    final responseDigest = md5
        .convert(utf8.encode(
          '$ha1:$nonce:$nc:$cnonce:$qop:$ha2',
        ))
        .toString();
    return responseDigest;
  }

// Función para construir el encabezado de autorización para la autenticación digest
  String constructAuthorizationHeader({
    required String username,
    required String realm,
    required String nonce,
    required String uri,
    required String qop,
    required String nc,
    required String cnonce,
    required String responseDigest,
    required String opaque,
  }) {
    return 'Digest username="$username", '
        'realm="$realm", '
        'nonce="$nonce", '
        'uri="$uri", '
        'qop="$qop", '
        'nc="$nc", '
        'cnonce="$cnonce", '
        'response="$responseDigest", '
        'opaque="$opaque"';
  }

// Asegúrate de que todas las variables que pasas a estas funciones están definidas correctamente.

// ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Imagen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Image.file(_image!),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Seleccionar Imagen'),
            ),
            ElevatedButton(
              onPressed: enviarImagen,
              child: Text('Enviar Imagen'),
            ),
          ],
        ),
      ),
    );
  }
}
