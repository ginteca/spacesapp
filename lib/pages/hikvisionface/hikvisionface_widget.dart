import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

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
  final _employeeNoController = TextEditingController();

  Future chooseImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImage() async {
    var uri = Uri.parse('https://habitan-t.com/test.php'); // Cambia a tu URL
    var request = http.MultipartRequest('POST', uri)
      ..fields['employeeNo'] = _employeeNoController.text
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Upload successful');
    } else {
      print('Upload failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null ? Text('No image selected.') : Image.file(_image!),
          TextField(
            controller: _employeeNoController,
            decoration: InputDecoration(
              labelText: 'Employee No',
            ),
          ),
          ElevatedButton(
            onPressed: chooseImage,
            child: Text('Choose Image'),
          ),
          ElevatedButton(
            onPressed: uploadImage,
            child: Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
