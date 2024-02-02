import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PlantDiseases extends StatefulWidget {
  const PlantDiseases({super.key});

  @override
  State<PlantDiseases> createState() => _PlantDiseasesState();
}

class _PlantDiseasesState extends State<PlantDiseases> {
  bool isImageSelected = false;
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 72, 95, 67),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(88, 22, 185, 7),
        title: const Text('Plant Diseases'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          isImageSelected
              ? Expanded(
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
            child: Text('Results Here : Lorem Ipsum or something'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 37, 146, 82)),
                  ),
                  onPressed: () async {
                    await _pickImagefromGallery();
                  },
                  label: const Text('Select from Gallery'),
                  icon: const Icon(Icons.folder_copy_outlined)),
              ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 37, 146, 82)),
                  ),
                  onPressed: () async {
                    await _pickImagefromCamera();
                  },
                  label: const Text('Take Picture'),
                  icon: const Icon(Icons.camera_enhance_outlined))
            ],
          )
        ],
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
        });
      } else {
        print('User didnt pick any image.');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}