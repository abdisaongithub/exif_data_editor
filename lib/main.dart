import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  String _response = '(please, wait)';
  late FlutterExif exif;
  late Uint8List imageToRead;

  @override
  void initState() {
    super.initState();
  }

  void readFile() async {
    if (exif == null) {
      setFile();
    }
    exif = FlutterExif.fromBytes(imageToRead);
    // final result = await exif.getAttribute(TAG_USER_COMMENT);
    final latlon = await exif.getLatLong();
    // print(result);
    if (kDebugMode) {
      print(latlon);
    }

    setState(() {
      _response = latlon!.first.toString();
    });
  }

  void setFile() async {
    final pickerImage = await _picker.pickImage(source: ImageSource.gallery);
    Uint8List bytes = await pickerImage!.readAsBytes();
    exif = FlutterExif.fromBytes(bytes);
    await exif.setLatLong(20.0, 10.0);
    // await exif.setAttribute(TAG_USER_COMMENT, 'my json structure');
    await exif.saveAttributes();
    imageToRead = (await exif.imageData)!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                'User comment :\n$_response\n',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  readFile();
                },
                child: const Text("read user comment"),
              ),
              TextButton(
                onPressed: () {
                  setFile();
                },
                child: const Text("write"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
