import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_1/camera/camera_plugin.dart';

class HomeScreen extends StatelessWidget {
  final CameraDescription camera;

  const HomeScreen({Key key, this.camera}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(children: [
          TakePictureScreen(camera: camera,),
          Container(color: Colors.grey,),
          Container(color: Colors.blueAccent,),
          Container(color: Colors.green,),
        ]),
        bottomNavigationBar: _getBottomBar(),
      ),
    );
  }


  Widget _getBottomBar(){
    return Container(
      color: Colors.black,
      height: 50,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: [
              Tab(
                text: "camera",
              ),
              Tab(
                text: "ocr",
              ),
              Tab(
                text: "scanner",
              ),
              Tab(text: "id viewer")
            ],
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.blue, width: 4.0),
              insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 45.0),
            ),
          )
        ],
      ),
    );
  }
}
