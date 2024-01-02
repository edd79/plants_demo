import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:plants_demo/src/screens/camera_handler.dart';
import 'package:plants_demo/src/screens/disease_image_handler.dart';
import 'package:plants_demo/src/screens/pest_image_handler.dart';

class HomePage extends StatelessWidget {
  //const HomePage({super.key});
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: const AssetImage('assets/project_pics/control1.jpeg'),
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
                          builder: (context) => PlantPests(),
                        ));
                  },
                  child: const Icon(Icons.bug_report_outlined)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDiseases(),
                        ));
                  },
                  child: const Icon(Icons.energy_savings_leaf))
            ],
          )
        ],
      ),
    );
  }
}
