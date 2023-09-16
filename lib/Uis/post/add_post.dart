import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:second_projects/Uis/utils.dart';
import 'package:second_projects/Widget/rounded_button.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  late TextEditingController postController;
  DatabaseReference database = FirebaseDatabase.instance.ref("Post");
  bool loading = false;

  @override
  void initState() {
    super.initState();
    postController = TextEditingController();
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
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
                controller: postController,
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
                    database.child(timeNotesIDS).set({
                      "title": postController.text.toString(),
                      "id": timeNotesIDS
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toast("Add To Firebase Database");
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
