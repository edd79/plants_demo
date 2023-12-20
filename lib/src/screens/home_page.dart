import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:plants_demo/src/screens/camera_handler.dart';

class HomePage extends StatelessWidget {
  //const HomePage({super.key});
  const HomePage({Key? key, required this.firstCamera}) : super(key: key);
  final CameraDescription firstCamera;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage('assets/project_pics/control1.jpeg'),
            height: height * 0.6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TakePictureScreen(camera: firstCamera),
                        ));
                  },
                  child: Icon(Icons.bug_report_outlined)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TakePictureScreen(camera: firstCamera),
                        ));
                  },
                  child: Icon(Icons.energy_savings_leaf))
            ],
          )
        ],
      ),
    );
  }
}
