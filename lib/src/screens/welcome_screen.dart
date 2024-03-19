import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plants_demo/src/screens/home_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/project_pics/forest_ferns.jpg'),
                    fit: BoxFit.cover)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  //Colors.red[200], // Colors.orange[200]
                  "LeafLab Pro",
                  style: GoogleFonts.baskervville(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                  selectionColor: Colors.grey[200],
                ),
                const Divider(
                  height: 20.0,
                ),
                Text(
                  "One step closer to healthy harvests",
                  style: GoogleFonts.rokkitt(
                    textStyle: Theme.of(context).textTheme.displayMedium,
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          ),
          Positioned(
              bottom: 50.0,
              left: 125.0,
              child: FloatingActionButton.extended(
                //foregroundColor: Color.fromARGB(255, 55, 218, 123),
                backgroundColor: const Color.fromARGB(255, 37, 146, 82),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                label: Row(
                  children: const [
                    Text("Get Started"),
                    Icon(Icons.arrow_right_alt_outlined)
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
