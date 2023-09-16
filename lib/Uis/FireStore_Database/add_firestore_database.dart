import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_projects/Uis/utils.dart';
import 'package:second_projects/Widget/rounded_button.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({super.key});

  @override
  State<AddFireStoreDataScreen> createState() => _AddPostState();
}

class _AddPostState extends State<AddFireStoreDataScreen> {
  late TextEditingController fireStoreController;
  final firestore = FirebaseFirestore.instance.collection("Student");

  bool loading = false;

  @override
  void initState() {
    super.initState();
    fireStoreController = TextEditingController();
  }

  @override
  void dispose() {
    fireStoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add FireStore Data"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: fireStoreController,
                decoration: const InputDecoration(
                    hintText: "What is in your mind",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  loading: loading,
                  title: "Add",
                  onTap: () {
                    setState(() {
                      loading = true;
                    });

                    /// * Hm ny apny child ko aur apna bnya howa child ka ka bhi child ma ak
                    /// * id key bnye ha any hm jo (millisecondsSinceEpoch) ma time dy raha ha
                    /// * wo same ha because ka hmy same ids chaya aur agr same ids ho gy to hm easily
                    /// * pna data ko (Update) aur (Delete) kr skty ha .
                    var timeNotesIDS =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    firestore.doc(timeNotesIDS).set({
                      "title": fireStoreController.text.toString(),
                      "id": timeNotesIDS,
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      fireStoreController.clear();
                      Utils().toast("Add FireStore Data");
                    }).onError((error, stackTrace) {
                      Utils().toast(error.toString());
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
