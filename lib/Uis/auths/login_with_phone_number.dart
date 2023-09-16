import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_projects/Uis/auths/verify_code.dart';
import 'package:second_projects/Uis/utils.dart';
import 'package:second_projects/Widget/rounded_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  TextEditingController phoneNumber = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    phoneNumber = TextEditingController();
  }

  @override
  void dispose() {
    // Todo: implement dispose
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LoginWithPhoneNumber"),
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
          RoundButton(
            title: "LoginWithPhoneNumber",
            loading: loading,
            onTap: () {
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumber.text.toString(),
                verificationCompleted:
                    (PhoneAuthCredential phoneAuthCredential) {},
                verificationFailed: (FirebaseAuthException error) {},
                codeSent: (String verificationId, int? forceResendingToken) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VerifyCode(verificationId: verificationId)));
                },
                codeAutoRetrievalTimeout: (verificationId) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toast(verificationId.toString());
                },
              );
            },
          )
        ],
      ),
    );
  }
}
