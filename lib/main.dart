import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:task_1/camera/camera_plugin.dart';
import 'package:task_1/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
  Future _getCameras() async{
    final cameras = await availableCameras();
    final cam = cameras.first;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(camera: cam,)),
    );
  }

}
