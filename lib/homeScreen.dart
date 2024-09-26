import 'dart:io';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'serverConnection.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  bool _loading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _previousDocumentsIds = [];
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String key = args?['key'] ?? '';
    String name = args?['name'] ?? '';
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
      body: Container(
        width: double.infinity,
        color: Colors.red,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Text(
                    'Hi, $name 👋',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  top: screenHeight * 0.03,
                  right: screenWidth * 0.05),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/register',
                                arguments: {'key': key});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset('assets/images/ic_register.png'),
                          ),
                        ),
                        Center(
                          child: Container(
                            child: Text(
                              'Register User',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.015,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/livestream');
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: screenWidth * 0.05),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset('assets/images/ic_camera.png'),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(left: screenWidth * 0.05),
                            child: Text(
                              'Livestream',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.015,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/boundary');
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: screenWidth * 0.05),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset('assets/images/ic_boundary.png'),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(left: screenWidth * 0.05),
                            child: Text(
                              'Set Boundary',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.015,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/controls',
                                arguments: {'key': key});
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: screenWidth * 0.05),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset('assets/images/ic_controls.png'),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(left: screenWidth * 0.05),
                            child: Text(
                              'Controls',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.015,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.01),
              height: screenHeight * 0.6,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.white]),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                      border: Border.all(width: 2, color: Colors.white30),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.005),
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.red),
                          child: Center(
                            child: Text(
                              'Alerts',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                top: screenHeight * 0.01,
                                left: screenWidth * 0.01,
                                right: screenWidth * 0.01),
                            color: Colors.white54,
                            child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('taskCollection')
                                  .doc(key)
                                  .collection('alerts')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      userSnapshot) {
                                if (userSnapshot.hasError) {
                                  return Text('Error: ${userSnapshot.error}');
                                }

                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                final List<
                                        QueryDocumentSnapshot<
                                            Map<String, dynamic>>> documents =
                                    userSnapshot.data!.docs;
                                List<String> currentDocumentsIds =
                                    documents.map((doc) => doc.id).toList();

                                // Check for new documents
                                bool newDocumentDetected = false;
                                for (String id in currentDocumentsIds) {
                                  if (!_previousDocumentsIds.contains(id)) {
                                    newDocumentDetected = true;
                                    break;
                                  }
                                }

                                if (newDocumentDetected) {
                                  _audioPlayer
                                      .play(AssetSource('audio/alert.mp3'));
                                  _previousDocumentsIds = currentDocumentsIds;
                                }

                                return ListView.builder(
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    final userData = documents[index].data();
                                    Color cardColor;
                                    Color textColor;

                                    if (userData['detection'] == 'intrusion') {
                                      cardColor = Colors.red;
                                      textColor = Colors.white;
                                    } else {
                                      cardColor = Colors.white;
                                      textColor = Colors.black;
                                    }

                                    // Parse the timestamp
                                    DateTime dateTime =
                                        DateTime.parse(userData['timestamp']);
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd – kk:mm')
                                            .format(dateTime);
                                    String detection = userData['detection'];
                                    String imageUrl = userData['image_url'];

                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.001),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.redAccent,
                                              Colors.blueAccent
                                            ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            width: 2, color: Colors.white30),
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/alertdetails',
                                              arguments: {
                                                'time': formattedDate,
                                                'detection': detection,
                                                'imageUrl': imageUrl
                                              });
                                        },
                                        title: Text(detection,
                                            style: TextStyle(color: textColor)),
                                        subtitle: Text(
                                            'Appeared at: $formattedDate',
                                            style: TextStyle(color: textColor)),
                                        leading: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(imageUrl),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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
