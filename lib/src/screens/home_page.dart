import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:plants_demo/src/screens/disease_image_handler.dart';
import 'package:plants_demo/src/screens/pest_image_handler.dart';
import 'package:plants_demo/src/screens/specialists_screen.dart';
class HomePage extends StatelessWidget {
  //const HomePage({super.key});
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(88, 22, 185, 7),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Specialists(),
                ),
              );
            },
            focusColor: Colors.white,
          ),
        ],
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
            left: 0,
            right: 0,
            bottom: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlantDiseases(),
                          ));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(57, 56, 245, 39)),
                    ),
                    label: const Text("Upload Leaf"),
                    icon: const Icon(Icons.energy_savings_leaf_outlined)),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlantPests(),
                          ));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(57, 56, 245, 39)),
                    ),
                    label: const Text("Upload Pest"),
                    icon: const Icon(Icons.bug_report_outlined)),
              ],
            ), 
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
    'assets/project_pics/welcomeimage.png',
    'assets/project_pics/mission.png',
    'assets/project_pics/tutorial.png',
    'assets/project_pics/specialist.png',
    'assets/project_pics/control17.jpg',
    'assets/project_pics/control11.jpg',
    'assets/project_pics/control12 - Copy.jpg',
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
