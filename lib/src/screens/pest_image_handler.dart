import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class PlantPests extends StatefulWidget {
  const PlantPests({super.key});

  @override
  State<PlantPests> createState() => _PlantPestsState();
}

class _PlantPestsState extends State<PlantPests> {
  bool isImageSelected = false;
  bool isModelRunning = false;
  File? imageFile;

  List _results = [];

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant_pests.tflite',
      labels: 'assets/labels_pests.txt',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 72, 95, 67),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(88, 22, 185, 7),
        title: const Text('Plant Pests'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            isImageSelected
                ? Container(
                    height: 300, // specify the height of the container
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        image: FileImage(imageFile!),
                      ),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.all(20),
              child: _results.isEmpty
                  ? Text('No results yet')
                  : Text(
                      'Label: ${_results[0]["label"]}\nConfidence: ${(_results[0]["confidence"] * 100).toStringAsFixed(2)}',
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 37, 146, 82)),
                    ),
                    onPressed: isModelRunning
                        ? null
                        : () async {
                            // Disable the button if the model is running
                            await _pickImagefromGallery();
                          },
                    label: const Text('Select from Gallery'),
                    icon: const Icon(Icons.folder_copy_outlined)),
                ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 37, 146, 82)),
                    ),
                    onPressed: isModelRunning
                        ? null
                        : () async {
                            // Disable the button if the model is running
                            await _pickImagefromCamera();
                          },
                    label: const Text('Take Picture'),
                    icon: const Icon(Icons.camera_enhance_outlined))
              ],
            )
          ],
        ),
      ),
    );
  }

  _pickImagefromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
          isImageSelected = true;
          runModelOnImage();
        });
      } else {
        print('User didnt pick any image.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _pickImagefromCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
          isImageSelected = true;
          runModelOnImage();
        });
      } else {
        print('User didnt pick any image.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  runModelOnImage() async {
    setState(() {
      isModelRunning =
          true; // Set isModelRunning to true before running the model
    });

    var res = await Tflite.runModelOnImage(
        path: imageFile!.path,
        numResults: 18,
        threshold: 0.5,
        imageMean: 0.0,
        imageStd: 255.0,
        asynch: true);

    print('Model Output: $res');

    setState(() {
      _results = res!;
      isModelRunning =
          false; // Set isModelRunning to false after running the model
    });
  }
}
