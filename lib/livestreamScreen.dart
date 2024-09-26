import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'serverConnection.dart' as sc;

class livestreamScreen extends StatefulWidget {
  @override
  _LivestreamAState createState() => _LivestreamAState();
}

class _LivestreamAState extends State<livestreamScreen> {
  String url = sc.serverUrl;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text(
          'Camify',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: screenHeight*0.1,bottom: screenHeight*0.1),
            child: RichText(
              text: TextSpan(
                style:GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  color: Colors.white,
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
                children: [
                  TextSpan(
                    text: 'Livestream from ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'SERVER',
                    style: TextStyle(color: Color(0xFFFF3131)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Mjpeg(
              stream: '$url/video_feed',
              isLive: true,  // Indicate that this is a live stream
            ),
          ),
        ],
      ),
    );
  }
}