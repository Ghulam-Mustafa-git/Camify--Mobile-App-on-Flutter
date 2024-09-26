import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'serverConnection.dart';

class authScreen extends StatefulWidget {
  const authScreen({super.key});

  @override
  State<authScreen> createState() => _authScreenState();
}

class _authScreenState extends State<authScreen> {
  bool _loading = false;
  final TextEditingController authKey = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return _loading
        ? Center(
      child: CircularProgressIndicator(),
    ): Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: screenHeight*0.03,right: screenWidth*0.8),
            width: screenWidth*0.1,
            height: screenHeight*0.1,
            child: InkWell(
              onTap: () {Navigator.pop(context);},
              child: Ink.image(
                  image: AssetImage(
                    'assets/images/ic_arrow_back.png',
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.04,
                left: screenWidth * 0.3,
                right: screenWidth * 0.3),
            width: screenWidth * 0.5,
            child: Image.asset("assets/images/logo_black.png"),
          ),
          Container(
            margin: EdgeInsets.only(
                left: screenWidth * 0.03,
                right: screenWidth * 0.03,
                top: screenHeight * 0.07),
            child: RichText(
              text: TextSpan(
                style:GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text: 'Please fill in your ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Authentication Key',
                    style: TextStyle(color: Color(0xFFFF3131)),
                  ),
                ],
              ),
            ),
          ),
          Container(
              width: screenWidth*1,
              height: screenHeight*0.045,
              margin: EdgeInsets.only(left: screenWidth*0.16,right: screenWidth*0.16,top: screenHeight*0.01),
              child: TextField(
                focusNode: _focusNode,
                controller: authKey,
                decoration: InputDecoration(
                  hintText: 'Authentication Key',
                  hintStyle: TextStyle(fontSize: screenWidth*0.035),
                  contentPadding:  EdgeInsets.only(left:screenWidth*0.04,right:screenWidth*0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF3131)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white38,
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: screenHeight*0.04),
            child: ElevatedButton(
              onPressed: () {
                //Navigator.pushNamed(context, '/home');
                sendAuthKey(authKey.text.trim(),context);
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
                  'Authenticate',
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
    );
  }
}
