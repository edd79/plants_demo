import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:plants_demo/src/screens/camera_handler.dart';
import 'package:plants_demo/src/screens/home_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 176, 179, 174),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage('assets/project_pics/control6.jpeg'),
                height: height * 0.6,
              ),
              Column(
                children: [
                  Text(
                    'PEST AND DISEASE IDENTIFICATION',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text('One stop for all your vermin and parasite needs',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomePage(),
                          ));
                    },
                    child: Text('Get Started'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
