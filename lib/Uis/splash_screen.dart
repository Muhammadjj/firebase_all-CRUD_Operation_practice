import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_projects/Uis/post/post_screen.dart';
import 'package:second_projects/Uis/auths/login_screen.dart';
import 'package:second_projects/Uis/upload_images.dart';

import 'FireStore_Database/firestore_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  // ** Splash Screen some mint stay and open the next page.
  isLogin() {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ** Check this Current user Login and Not a Login .
    var currentUser = auth.currentUser;

    if (currentUser != null) {
      Timer.periodic(const Duration(seconds: 3), (timer) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const UploadImages()));
      });
    } else {
      Timer.periodic(const Duration(seconds: 3), (timer) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 110, 158),
      body: Center(
        child: Text(
          'Firebase Tutorials',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
