import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_projects/Uis/auths/login_screen.dart';
import 'package:second_projects/Widget/rounded_button.dart';

import '../utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  late TextEditingController emailController;
  late TextEditingController passwordConroller;
  bool loading = false;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Sign Up Page"),
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
                      debugPrint("object :$value");
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
                  title: "Sign Up",
                  loading: loading,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        debugPrint("object");
                      });

                      /// check this email and password authentication
                      auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordConroller.text.toString())
                          .then((UserCredential value) {
                        setState(() {
                          loading = false;
                        });
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
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text('Login'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
