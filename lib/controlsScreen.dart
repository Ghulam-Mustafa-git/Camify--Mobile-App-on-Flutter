import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'serverConnection.dart' as sc;

class controlsScreen extends StatefulWidget {
  const controlsScreen({super.key});

  @override
  State<controlsScreen> createState() => _controlsScreenState();
}

class _controlsScreenState extends State<controlsScreen> {
  bool _toggleValue = false;
  bool _toggleValue1 = false;
  String url = sc.serverUrl;

  Future<void> _detectorStartFunction(bool _toggleValue,String key) async {
    try {
      final response = await http.post(
        Uri.parse('$url/user_detector'),
        body: jsonEncode({'key': key}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        _saveToggleValue(_toggleValue);
        print(
            'Success to start detector: ${response.statusCode} - ${response.reasonPhrase}');
      } else {
        print(
            'Failed to start detector: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error starting detector: $e');
    }
  }

  Future<void> _detectorStopFunction(bool _toggleValue) async {
    try {
      final response = await http.post(Uri.parse('$url/stop_user_detector'));
      if (response.statusCode == 200) {
        _saveToggleValue(_toggleValue);
        print(
            'Success to stop detector: ${response.statusCode} - ${response.reasonPhrase}');
      } else {
        print(
            'Failed to start detector: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error starting detector: $e');
    }
  }
  Future<void> _recognitionStartFunction(bool _toggleValue,String key) async {
    try {
      final response = await http.post(
        Uri.parse('$url/use_recognition'),
        body: jsonEncode({'key': key}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        _saveToggleValue1(_toggleValue);
        print(
            'Success to start recognition: ${response.statusCode} - ${response.reasonPhrase}');
      } else {
        print(
            'Failed to start recognition: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error starting recognition: $e');
    }
  }

  Future<void> _recognitionStopFunction(bool _toggleValue) async {
    try {
      final response = await http.post(Uri.parse('$url/stop_recognition'));
      if (response.statusCode == 200) {
        _saveToggleValue1(_toggleValue);
        print(
            'Success to stop recognition: ${response.statusCode} - ${response.reasonPhrase}');
      } else {
        print(
            'Failed to start recognition: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error starting recognition: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToggleValue(); // load the toggle value from shared preferences
    _loadToggleValue1();
  }

  _loadToggleValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _toggleValue = prefs.getBool('toggleValue') ?? false;
    });
  }
  _loadToggleValue1() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _toggleValue = prefs.getBool('toggleValue1') ?? false;
    });
  }

  _saveToggleValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('toggleValue', value);
  }
  _saveToggleValue1(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('toggleValue1', value);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String key = args?['key'] ?? '';
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.05, left: screenWidth * 0.2),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      color: Colors.white,
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: 'Control ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Panel',
                        style: TextStyle(color: Color(0xFFFF3131)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.02, right: screenWidth * 0.3),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: 'Intrusion ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Detection',
                        style: TextStyle(color: Color(0xFFFF3131)),
                      ),
                    ],
                  ),
                ),
              ),
              Switch(
                value: _toggleValue,
                onChanged: (value) {
                  setState(() {
                    _toggleValue = value;
                    if (_toggleValue) {
                      _detectorStartFunction(_toggleValue,key);
                    } else {
                      _detectorStopFunction(_toggleValue);
                    }
                  });
                },
                activeColor: Colors.red,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.02, right: screenWidth * 0.36),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: 'Face ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Recognition',
                        style: TextStyle(color: Color(0xFFFF3131)),
                      ),
                    ],
                  ),
                ),
              ),
              Switch(
                value: _toggleValue1,
                onChanged: (value) {
                  setState(() {
                    _toggleValue1 = value;
                    if (_toggleValue1) {
                      _recognitionStartFunction(_toggleValue1,key);
                    } else {
                      _recognitionStopFunction(_toggleValue1);
                    }
                  });
                },
                activeColor: Colors.red,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
