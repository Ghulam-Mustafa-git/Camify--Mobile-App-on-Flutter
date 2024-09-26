import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'serverConnection.dart';


class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  bool _loading = false;
  final TextEditingController name = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _selectedImagePath; // Store the selected image path
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String key = args?['key'] ?? '';
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print('key = $key');
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
          title: const Text(
            'Camify',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: screenWidth,
          color: Colors.white10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: screenWidth * .07, top: screenHeight * 0.07),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: 'Please enter ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Name',
                        style: TextStyle(color: Color(0xFFFF3131)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                height: screenHeight * 0.045,
                margin: EdgeInsets.only(
                    left: screenWidth * .06,right: screenWidth * .06, top: screenHeight * 0.01),
                child: TextField(
                  focusNode: _focusNode,
                  controller: name,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                    contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.04, right: screenWidth * 0.04),
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
                margin: EdgeInsets.only(
                    left: screenWidth * .07, top: screenHeight * 0.03),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: 'Please select ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Video',
                        style: TextStyle(color: Color(0xFFFF3131)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth, // Width of the parent container
                height: screenHeight * 0.4, // Height of the parent container
                margin: EdgeInsets.only(left: screenWidth * 0.06, right: screenWidth * 0.06, top: screenHeight * 0.01),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: () async{await _pickVideoFromGallery();}, // Call the function to open gallery
                  child: _selectedImagePath != null
                      ? Icon(
                    Icons.video_collection,
                    size: screenWidth * 0.1,
                    color: Colors.white,
                  )
                      : Image.asset(
                    'assets/images/plus.png', // Default image
                    width: 100, // Set width of the image
                    height: 100, // Set height of the image
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight*0.04,left: screenWidth*0.06,right: screenWidth*0.06),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {

                    // Check if an image is picked
                    if (_selectedImagePath != null) {
                      try {
                        // Send the picked image to the server
                        await sendImagesToServer(name.text,key,File(_selectedImagePath!), context);
                      } catch (error) {
                        // Handle errors, e.g., show a message using a SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to upload image: $error'),
                          ),
                        );
                      }
                    } else {
                      // Show a message if no image is picked
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No image selected.'),
                        ),
                      );
                    }
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
                      'Add User',
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
        ));
  }
  // Function to handle image selection from gallery
  Future<void> _pickVideoFromGallery() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);

    // Check if image is picked
    if (pickedFile != null) {
      setState(() {
        // Store the picked image path
        _selectedImagePath = pickedFile.path;
      });
    }
  }


}
