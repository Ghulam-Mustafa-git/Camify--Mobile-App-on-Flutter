import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class alertDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    String detection = args?['detection'] ?? '';
    String time = args?['time'] ?? '';
    String imageUrl = args?['imageUrl'] ?? '';
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text(
          'Alert Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.01,left: screenWidth*0.01,right: screenWidth*0.01),
              height: screenHeight * 0.5,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.redAccent, Colors.blueAccent]),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                      border: Border.all(width: 2, color: Colors.white30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: RichText(
                            text: TextSpan(
                              style:GoogleFonts.lato(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                color: Colors.white,
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.w700,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Detection: ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: '$detection',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),),
                        SizedBox(height: 10),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05),
                            child: Text('Timestamp: $time',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white))),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Text('Screenshot:',
                              style:
                              TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                        SizedBox(height: 10),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05),
                            child: Image.network(imageUrl)),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
