import 'package:flutter/material.dart';
import 'package:plants_demo/src/screens/more_info_screen.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class PlantPests extends StatefulWidget {
  const PlantPests({super.key});

  @override
  State<PlantPests> createState() => _PlantPestsState();
}

class _PlantPestsState extends State<PlantPests> {
  bool isImageSelected = false;
  bool isModelRunning = false;
  File? imageFile;
  Uint8List? defaultImageData;

  List _results = [];

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant_pests.tflite',
      labels: 'assets/labels_pests.txt',
    );
  }

  Future<void> _loadDefaultImage() async {
    final byteData = await rootBundle.load('assets/upload1.jpg');
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
      backgroundColor: const Color.fromARGB(134, 72, 95, 67),
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
              margin: const EdgeInsets.all(20),
              child: _results.isEmpty
                  ? const Text('No results yet')
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
      // body: Stack(
      //   children: [
      //     Positioned(
      //       top: MediaQuery.of(context).size.height * 0.25, 
      //       child: isImageSelected
      //           ? Container(
      //               height: 300,
      //               child: Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Image(
      //                   image: FileImage(imageFile!),
      //                 ),
      //               ),
      //             )
      //           : Container(
      //               height: 300,
      //               child: Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Image.memory(defaultImageData!),
      //               ),
      //             ),
      //     ),
      //     Container(
      //         margin: const EdgeInsets.all(20),
      //         child: _results.isEmpty
      //             ? const Text('No results yet')
      //             : Text(
      //                 'Name: ${_results[0]["label"]}\nConfidence: ${(_results[0]["confidence"] * 100).toStringAsFixed(2)}',
      //               ),
      //       ),

      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           ElevatedButton.icon(
      //               style: ButtonStyle(
      //                 backgroundColor: MaterialStateProperty.all<Color>(
      //                     const Color.fromARGB(255, 37, 146, 82)),
      //               ),
      //               onPressed: isModelRunning
      //                   ? null
      //                   : () async {
      //                       // Disable the button if the model is running
      //                       await _pickImagefromGallery();
      //                     },
      //               label: const Text('Select from Gallery'),
      //               icon: const Icon(Icons.folder_copy_outlined)),
      //           ElevatedButton.icon(
      //               style: ButtonStyle(
      //                 backgroundColor: MaterialStateProperty.all<Color>(
      //                     const Color.fromARGB(255, 37, 146, 82)),
      //               ),
      //               onPressed: isModelRunning
      //                   ? null
      //                   : () async {
      //                       // Disable the button if the model is running
      //                       await _pickImagefromCamera();
      //                     },
      //               label: const Text('Take Picture'),
      //               icon: const Icon(Icons.camera_enhance_outlined))
      //         ],
      //       )
      //   ],
      // ),
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

      // Show a dialog with a "Learn More" link
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 15.0,
          icon: const Icon(
            Icons.error_outline_outlined,
            color: Colors.red,),
          backgroundColor: Color.fromARGB(223, 106, 230, 158),
          title: const Text('Pest Identified'),
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


// runModelOnImage() async {
//   setState(() {
//     isModelRunning = true;
//   });
//   var res = await Tflite.runModelOnImage(
//     path: imageFile!.path,
//     numResults: 18,
//     threshold: 0.5,
//     imageMean: 0.0,
//     imageStd: 255.0,
//     asynch: true,
//   );
//   print('Model Output: $res');
//   setState(() {
//     _results = res!;
//     isModelRunning = false;
//   });

//   // Show a dialog with a "Learn More" link
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Pest Identified'),
//         content: Text(
//             'Label: ${_results[0]["label"]}\nConfidence: ${(_results[0]["confidence"] * 100).toStringAsFixed(2)}'),
//         actions: [
//           TextButton(
//             child: Text('Learn More'),
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       PestInfoPage(pestName: _results[0]["label"]),
//                 ),
//               );
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
