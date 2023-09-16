import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:second_projects/Uis/auths/login_screen.dart';
import 'package:second_projects/Uis/post/add_post.dart';
import 'package:second_projects/Uis/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference database = FirebaseDatabase.instance.ref("Post");
  TextEditingController updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 151, 255, 205),
      appBar: AppBar(
        title: const Text("Post Screen"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                }).onError((error, stackTrace) {
                  Utils().toast(error.toString());
                });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: database,
              padding: const EdgeInsets.all(4.0),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Card(
                  color: Colors.cyan,
                  elevation: 8,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: ListTile(
                    title: Text(snapshot.child("title").value.toString()),
                    subtitle: Text(snapshot.child("id").value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            onTap: () {
                              alertDialog(
                                  snapshot.child("title").value.toString(),
                                  snapshot.child("id").value.toString());
                              Navigator.pop(context);
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text("Edit"),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            onTap: () {
                              database
                                  .child(snapshot.child("id").value.toString())
                                  .remove();
                              Navigator.pop(context);
                            },
                            leading: const Icon(Icons.delete),
                            title: const Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Text("NEXT"),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPost(),
                ));
          }),
    );
  }

//  Press this More Icon button And Show this Alert Dialog .
  Future<void> alertDialog(String title, String id) {
    updateController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
              controller: updateController,
              decoration: const InputDecoration(hintText: "UPDATE")),
          actions: [
            TextButton(
                // Alert Dialog (Ok) Button .
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            // Alert Dialog (Cancel) Button .
            TextButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                  database
                      .child(id)
                      .update({"title": updateController.text.toString()}).then(
                          (value) {
                    Utils().toast("Post Update");
                  }).onError((error, stackTrace) {
                    Utils().toast(error.toString());
                  });
                },
                child: const Text("Ok")),
          ],
        );
      },
    );
  }
}
