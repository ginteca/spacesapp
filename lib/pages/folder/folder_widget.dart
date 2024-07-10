import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Documentos',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: DocumentPage(),
    );
  }
}

class DocumentPage extends StatefulWidget {
  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final String apiUrl =
      "https://appaltea.azurewebsites.net/api/Mobile/GetDocumentInFolder/";
  List<dynamic> folders = [];

  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  Future<void> getDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString('idUsuario') ??
        "default_user_id"; // Provide a default value or handle it appropriately
    String associationId = prefs.getInt('IdAssociation')?.toString() ??
        "default_association_id"; // Provide a default value or handle it appropriately

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "idUser": idUser,
          "AssociationId": associationId,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        print("Response Body: ${response.body}");
        var decodedResponse = json.decode(response.body);
        if (decodedResponse['Type'] == 'Success' &&
            decodedResponse['Data'] != null) {
          String documentsJsonString = decodedResponse['Data'][0]['Value'];
          List<dynamic> documentsData = json.decode(documentsJsonString);
          setState(() {
            folders = documentsData;
          });
        } else {
          print("API returned error: ${decodedResponse['Message']}");
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error parsing documents: $e');
    }
  }

  Future<void> downloadAndOpenDocument(String url, String fileName) async {
    print('Attempting to download document from: $url');
    Dio dio = Dio();
    try {
      var status = await Permission.storage.request();
      print('Storage Permission: ${status.isGranted}');

      if (!status.isGranted) {
        throw Exception('Permission to access storage was denied');
      }

      var dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/$fileName";

      await dio.download(url, filePath, onReceiveProgress: (received, total) {
        print("Download progress: ${received / total * 100}%");
      });

      print('File downloaded to: $filePath');
      var result = await OpenFile.open(filePath);
      print('Open file result: ${result.type}');
    } catch (e) {
      print('Error downloading or opening document: $e');
      rethrow; // Rethrow the error to be caught by the calling function if necessary.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos'),
        backgroundColor: Color.fromARGB(255, 14, 63, 87),
      ),
      body: folders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemCount: folders.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                var folder = folders[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FolderContentsPage(
                          documents: folder['Documents'] ?? [],
                          folderName: folder['Name'] ?? 'Unknown Folder',
                          onDocumentTap: downloadAndOpenDocument,
                        ),
                      ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder, size: 50.0),
                        SizedBox(height: 8.0),
                        Text(
                          folder['Name'] ?? 'Unknown Folder',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FolderContentsPage extends StatelessWidget {
  final List<dynamic> documents;
  final String folderName;
  final Function(String, String) onDocumentTap;

  const FolderContentsPage({
    Key? key,
    required this.documents,
    required this.folderName,
    required this.onDocumentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
        backgroundColor: Color.fromARGB(255, 14, 63, 87),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          var document = documents[index];
          return ListTile(
            title: Text(document['Name'] ?? 'Unknown Document'),
            subtitle: Text(document['Type'] ?? 'Unknown Type'),
            leading: Icon(Icons.insert_drive_file),
            onTap: () => onDocumentTap(document['Link'], document['Name']),
          );
        },
      ),
    );
  }
}
