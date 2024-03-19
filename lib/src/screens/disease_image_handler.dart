import 'package:flutter/material.dart';
import 'package:plants_demo/src/screens/more_info_screen.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';


class PlantDiseases extends StatefulWidget {
  const PlantDiseases({super.key});

  @override
  State<PlantDiseases> createState() => _PlantDiseasesState();
}

class _PlantDiseasesState extends State<PlantDiseases> {
  bool isImageSelected = false;
  bool isModelRunning = false;
  File? imageFile;
  Uint8List? defaultImageData;

  List _results = [];

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant_diseases.tflite',
      labels: 'assets/labels_diseases.txt',
    );
  }

  Future<void> _loadDefaultImage() async {
    final byteData = await rootBundle.load('assets/project_pics/upload1.jpg');
    setState(() {
      defaultImageData = byteData.buffer.asUint8List();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadModel();
    _loadDefaultImage();
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
        title: const Text('Plant Diseases'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            isImageSelected
                ? Center(
                    child: Container(
                      height: 300, // specify the height of the container
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: imageFile != null
                            ? Image.file(imageFile!)
                            : Container(child: Text('No image')),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: defaultImageData != null
                            ? Image.memory(defaultImageData!)
                            : Container(child: Text('No image')),
                      ),
                    ),
                  ),
            Container(
              margin: EdgeInsets.all(20),
              child: _results.isEmpty
                  ? Text('No results yet')
                  : Text(
                      'Name: ${_results[0]["label"]}\nConfidence: ${(_results[0]["confidence"] * 100).toStringAsFixed(2)}',
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
      isModelRunning = true; // Set isModelRunning to true before running the model
    });

    var res = await Tflite.runModelOnImage(
        path: imageFile!.path,
        numResults: 38,
        threshold: 0.5,
        imageMean: 0.0,
        imageStd: 255.0,
        asynch: true);

    print('Model Output: $res');

    setState(() {
      _results = res!;
      isModelRunning = false; // Set isModelRunning to false after running the model
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 15.0,
          icon: const Icon(Icons.error_outline_outlined,
          color: Colors.red,),
          backgroundColor: Color.fromARGB(184, 106, 230, 157),
          title: const Text('Leaf Identified'),
          content: Text(
              'Name: ${_results[0]["label"]}\nConfidence: ${(_results[0]["confidence"] * 100).toStringAsFixed(2)}\n\nTap the link below for information on control and prevention measures\n\nTap anywhere else to close this dialog'),
          actions: [
            TextButton(
              child: const Text('Learn More'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MoreInfoPage(pdName: _results[0]["label"]),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
