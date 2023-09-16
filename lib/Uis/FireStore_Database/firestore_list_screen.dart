import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:second_projects/Uis/FireStore_Database/add_firestore_database.dart';
import 'package:second_projects/Uis/auths/login_screen.dart';
import 'package:second_projects/Uis/utils.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> firestore =
      FirebaseFirestore.instance.collection("Student").snapshots();
  CollectionReference reference =
      FirebaseFirestore.instance.collection("Student");
  TextEditingController updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 151, 255, 205),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("FireStore Screen"),
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
          StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Center(child: Text("Data Not Found"));
              } else if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 12,
                        shadowColor: Colors.amber,
                        child: ListTile(
                          title: Text(
                              snapshot.data!.docs[index]["title"].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index].id.toString()),
                          trailing: PopupMenuButton(
                            elevation: 12,
                            color: const Color.fromARGB(255, 255, 160, 191),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  padding: EdgeInsets.all(0.0),
                                  child: ListTile(
                                    onTap: () {
                                      alertDialog(
                                          snapshot.data!.docs[index]["title"]
                                              .toString(),
                                          snapshot.data!.docs[index].id
                                              .toString());
                                    },
                                    title: const Text("Update"),
                                    leading: const Icon(
                                        Icons.system_update_alt_outlined),
                                  )),
                              PopupMenuItem(
                                  padding: const EdgeInsets.all(0.0),
                                  child: ListTile(
                                    onTap: () {
                                      reference
                                          .doc(snapshot.data!.docs[index].id
                                              .toString())
                                          .delete();
                                    },
                                    title: const Text("Delete"),
                                    leading: const Icon(
                                        Icons.delete_outline_outlined),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(child: Text("Not Not"));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Text("NEXT"),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddFireStoreDataScreen()));
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
                  reference.doc(id).update(
                      {"title": updateController.text.toString(), "id": id});
                },
                child: const Text("Ok")),
          ],
        );
      },
    );
  }
}
