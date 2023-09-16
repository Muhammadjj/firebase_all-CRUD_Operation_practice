// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_projects/Uis/post/post_screen.dart';
import 'package:second_projects/Uis/auths/login_with_phone_number.dart';
import 'package:second_projects/Uis/utils.dart';
import 'package:second_projects/Widget/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<LoginScreen> {
  // ** Firebase Auth in Flutter .
  FirebaseAuth auth = FirebaseAuth.instance;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordConroller;
  bool loading = false;

  // ** Google Auth In Flutter Help With Firebase
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    debugPrint("Google User : $googleUser");
    debugPrint("Google User Email : ${googleUser!.email.toString()}");
    debugPrint("Google User DisPlayName : ${googleUser.displayName}");
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PostScreen(),
          ));
      return FirebaseAuth.instance.signInWithCredential(credential);
    });
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordConroller = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordConroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          automaticallyImplyLeading: false,
          title: const Text("Login Page"),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        debugPrint("object : $value");
                        return 'Enter email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.alternate_email))),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    controller: passwordConroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_open))),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                    title: "Login",
                    loading: loading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });

                        /// check this email and password authentication
                        auth
                            .signInWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordConroller.text.toString())
                            .then((UserCredential value) {
                          Utils().toast(
                              "${value.user!.email}\n${value.user!.uid}");
                          setState(() {
                            loading = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PostScreen(),
                              ));
                          emailController.clear();
                          passwordConroller.clear();
                        }).onError((error, stackTrace) {
                          setState(() {
                            loading = false;
                          });
                          Utils().toast("Show Error  ${error.toString()}");
                        });
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text('Sign up')),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginWithPhoneNumber(),
                        ));
                  },
                  color: Colors.tealAccent,
                  child: const Text(
                    "Login With Phone",
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // ** Using this Button Google Auth Dialog in Automatically signUp
                // ** User My APP
                CupertinoButton(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  color: Colors.red,
                  child: const Text(
                    "Login With Google",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
