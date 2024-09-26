import 'package:camify/alertDetails.dart';
import 'package:camify/authScreen.dart';
import 'package:camify/boundaryScreen.dart';
import 'package:camify/controlsScreen.dart';
import 'package:camify/homeScreen.dart';
import 'package:camify/livestreamScreen.dart';
import 'package:camify/registerScreen.dart';
import 'package:camify/welcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(camify());
}

class camify extends StatelessWidget {
  const camify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Camify',
      initialRoute: '/',
      routes: {
        '/': (context) => welcomeScreen(),
        '/auth': (context) => authScreen(),
        '/home': (context) => homeScreen(),
        '/register': (context) => registerScreen(),
        '/livestream': (context) => livestreamScreen(),
        '/boundary': (context) => BoundaryScreen(),
        '/controls': (context) => controlsScreen(),
        '/alertdetails': (context) => alertDetails(),
      },
    );
  }
}