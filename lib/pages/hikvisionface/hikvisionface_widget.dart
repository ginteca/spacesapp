import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final _picker = ImagePicker();
  String? _employeeNo;

  @override
  void initState() {
    super.initState();
    _loadEmployeeNo();
  }

  Future<void> _loadEmployeeNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _employeeNo = prefs.getString('idUsuario');
    });
  }

  Future<void> chooseImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      // Reduce the quality of the image
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      var result = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        '$path/${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: 10,
      );

      setState(() {
        _image = result != null ? File(result.path) : null;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || _employeeNo == null) {
      print('No image or employee number to upload.');
      _showDialog('Error', 'No image or employee number to upload.');
      return;
    }

    var uri = Uri.parse('https://habitan-t.com/test.php'); // Cambia a tu URL
    var request = http.MultipartRequest('POST', uri)
      ..fields['employeeNo'] = _employeeNo!
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      _showDialog('Upload successful', responseData);
    } else {
      var responseData = await response.stream.bytesToString();
      _showDialog('Upload failed', responseData);
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        backgroundColor: Color.fromRGBO(3, 16, 145, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: chooseImage,
              child: Text('Take Photo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
