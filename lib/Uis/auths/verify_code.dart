// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_projects/Uis/post/post_screen.dart';
import 'package:second_projects/Uis/utils.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key, this.verificationId});
  final String? verificationId;
  @override
  State<VerifyCode> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<VerifyCode> {
  TextEditingController phoneNumber = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    phoneNumber = TextEditingController();
  }

  @override
  void dispose() {
    // Todo :implement dispose
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VerifyCode"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: phoneNumber,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Your A Number ."),
          ),
          const SizedBox(
            height: 30,
          ),
          CupertinoButton(
              child: const Text("Verify Code "),
              onPressed: () async {
                final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId.toString(),
                    smsCode: phoneNumber.text.toString());

                try {
                  Utils().toast("${PhoneAuthProvider.PROVIDER_ID.length}");
                  await auth.signInWithCredential(credential);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostScreen(),
                      ));
                } catch (error) {
                  Utils().toast(error.toString());
                }
              })
        ],
      ),
    );
  }
}
