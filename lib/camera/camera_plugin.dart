import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  Size size;
  bool isWindowShown = false;
  bool isFlashOn = false;
  double s = 1.3;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,

    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Transform.scale(
                  scale: s,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CameraPreview(_controller),),
                  ),
                );

              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

          /* camera overlay */
          Align(
            alignment: FractionalOffset.topRight,
            child: Container(
              height: 50,
              width: 50,
              child: IconButton(icon: IconButton(icon:Icon(Icons.settings), color: Colors.grey, onPressed: (){
                setState(() {
                  isWindowShown =  isWindowShown ? false: true;
                });
              }), onPressed: null),
            ),
          ),
          isWindowShown ? Container(
            margin: EdgeInsets.fromLTRB(10.0, 60.0, 10.0, 0.0),
            height: 40,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(icon: Icon(Icons.flash_on, color: isFlashOn ? Colors.blue:Colors.grey), onPressed: (){setState(() {
                  isFlashOn = true;
                  _controller.enableFlash(true);
                });},),
                IconButton(icon: Icon(Icons.flash_off, color: isFlashOn ? Colors.grey:Colors.blue), onPressed: (){
                  setState(() {
                    isFlashOn = false;
                    _controller.enableFlash(false);
                  });
                },),
                IconButton(icon: Icon(Icons.zoom_in, color: Colors.grey,), onPressed: (){
                  setState(() {
                    s = 2.0;
                  });
                },),
                IconButton(icon: Icon(Icons.zoom_out, color: Colors.grey), onPressed: (){
                  setState(() {
                    s = 1.3;
                  });
                },)
              ],
            ),
          ): Container(),
          Column(mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Container()),
              // capture progress

            ],
          )
        ],
      ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            await _controller.takePicture(path);
            print(path);
            Fluttertoast.showToast(
                msg: "saved to " + path,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
            );

            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path, s: s,),
              ),
            );*/
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }

}

// A Widget that displays the picture taken by the user
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final double s;
  const DisplayPictureScreen({Key key, this.imagePath, this.s}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: s > 1.5? _getTransformedPreview(context): _getUntransformedPreview(context));
  }

  Widget _getUntransformedPreview(BuildContext context){
    return  Center(
      child: Image.file(File(imagePath), height: MediaQuery
          .of(context)
          .size
          .height,
        width: MediaQuery
            .of(context)
            .size
            .height, fit: BoxFit.cover,),
    );
  }


  Widget _getTransformedPreview(BuildContext context){
    return Transform.scale(scale: s - 0.4,
      child: Center(
        child: Image.file(File(imagePath), height: MediaQuery
            .of(context)
            .size
            .height,
          width: MediaQuery
              .of(context)
              .size
              .height, fit: BoxFit.cover,),
      ),
    );
  }
}