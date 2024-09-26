import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert'; // Import dart:convert to use jsonDecode

const String serverUrl = 'http://192.168.135.226:6000';
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Upload data to Firestore
Future<void> uploadDataToFirestore(String name,String url,key) async {
  try {
    await firestore.collection('taskCollection').doc(key).collection('users').doc(name).set({
      'name': name,
      'imageUrl':url
    });
    print('Data uploaded to Firestore');
  } catch (e) {
    print('Error uploading data to Firestore: $e');
  }
}

Future<void> sendAuthKey(String authKey, BuildContext context) async {
  final response = await http.post(
    Uri.parse('$serverUrl/authenticate'),
    body: jsonEncode({'key': authKey}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    print('Server Response: ${response.body}');

    // Parse the JSON response
    final responseData = jsonDecode(response.body);
    // Check if the response contains user data
    if (responseData.containsKey('userData')) {
      final userData = responseData['userData'];
      // Extract user data fields
      final String name = userData['name'];
      final String email = userData['email'];
      final String address = userData['homeaddress'];
      final String phone = userData['phone'];

      Navigator.pushNamed(context, '/home', arguments: {
        'name': name,
        'email': email,
        'address': address,
        'phone': phone,
        'key': authKey
      });
    } else {
      print('Failed to extract user data from server response');
    }
  } else {
    print('Failed to send auth key: ${response.statusCode}');
  }
}

Future<void> sendImagesToServer(String name, String key, File image, BuildContext context) async {
  print('$name $key');
  // Server configuration
  const String Url = '$serverUrl/register_user'; // Replace with your server's URL
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
    builder: (context) {
      return Center(child: CircularProgressIndicator());
    },
  );
  try {
    var request = http.MultipartRequest('POST', Uri.parse(Url));

    // Add the image file
    var multipartFile = await http.MultipartFile.fromPath('video', image.path);
    request.files.add(multipartFile);

    // Add the key to the request body
    request.fields['cnic'] = '$name';

    // Send the request
    var response = await request.send();
    final responseString = await response.stream.bytesToString();
    // Check the response status code
    if (response.statusCode == 200) {
      print('Image uploaded successfully: ${image.path}');
      var decodedResponse = json.decode(responseString);
      String? firstFrameUrl = decodedResponse['first_frame_url'];
      print(firstFrameUrl);
      uploadDataToFirestore(name, firstFrameUrl!, key);
    } else if (response.statusCode == 700) {
      print('Invalid key');
    } else if (response.statusCode == 500) {
      print('Error saving embeddings');
    } else if (response.statusCode == 600) {
      print('Error during feature extraction');
    } else {
      print('Failed to upload image: ${image.path}');
    }
  } catch (error) {
    print('Error uploading images: $error');
  }finally {
    Navigator.pop(context); // Close the CircularProgressIndicator
  }
}
