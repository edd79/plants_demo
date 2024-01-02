import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:plants_demo/src/screens/imagepicker.dart';

import 'src/screens/welcome_screen.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: WelcomeScreen(),
    ),
  );
}

