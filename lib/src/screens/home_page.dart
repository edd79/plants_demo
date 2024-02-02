import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plants_demo/src/screens/disease_image_handler.dart';

class HomePage extends StatelessWidget {
  //const HomePage({super.key});
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Home'),
    //     centerTitle: true,
    //   ),
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       Image(
    //         image: const AssetImage('assets/project_pics/control1.jpeg'),
    //         height: height * 0.6,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           // ElevatedButton(
    //           //     onPressed: () {
    //           //       Navigator.push(
    //           //           context,
    //           //           MaterialPageRoute(
    //           //             builder: (context) => PlantPests(),
    //           //           ));
    //           //     },
    //           //     child: const Icon(Icons.bug_report_outlined)),
    //           ElevatedButton.icon(
    //               onPressed: () {
    //                 Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => const PlantDiseases(),
    //                     ));
    //               },
    //               label: const Text("Plant Diseases"),
    //               icon: const Icon(Icons.energy_savings_leaf))
    //         ],
    //       )
    //     ],
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(88, 22, 185, 7),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/project_pics/forest_ferns.jpg'),
              fit: BoxFit.cover,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: height * 0.45,
              child: const Slideshow(),
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: 125.0,
            child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlantDiseases(),
                      ));
                },
                //add_a_photo
                //add_photo_alternate
                backgroundColor: const Color.fromARGB(255, 37, 146, 82),
                label: const Text("Scan Leaf"),
                icon: const Icon(Icons.energy_savings_leaf_outlined)),
          )
        ],
      ),
    );
  }
}

class Slideshow extends StatefulWidget {
  const Slideshow({super.key});

  @override
  State<Slideshow> createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  final List<String> slides = [
    'assets/project_pics/home.jpg',
    'assets/project_pics/leaf2.jpeg',
    'assets/project_pics/control5.jpeg',
    'assets/project_pics/control4.jpeg',
    'assets/project_pics/control2.jpeg',
    'assets/project_pics/control1.jpeg',
    'assets/project_pics/leaf5.jpeg'
  ];

  late PageController _pageController;
  //late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startSlideshow();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startSlideshow() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.page == slides.length - 1) {
        _pageController.jumpToPage(0);
      } else {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 500), 
            curve: Curves.slowMiddle
            );
      }
      _startSlideshow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: slides.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(slides[index]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
