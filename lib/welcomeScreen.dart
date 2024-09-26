import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class welcomeScreen extends StatefulWidget {
  static const String route = './authScreen';
  const welcomeScreen({super.key});

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/auth_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: screenHeight * 0.13,
                  left: screenWidth * 0.3,
                  right: screenWidth * 0.3),
              width: screenWidth * 0.5,
              child: Image.asset("assets/images/logo.png"),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.03,
                  top: screenHeight * 0.55),
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
                      text: 'Empower Security: ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'Guardian Eyes at Watch.',
                      style: TextStyle(color: Color(0xFFFF3131)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight*0.01),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF3131), // Your specified color #FF3131
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the value as needed
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight*0.01,bottom: screenHeight*0.01,left: screenWidth*0.1,right: screenWidth*0.1),
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
