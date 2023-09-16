import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_projects/Uis/utils.dart';
import '../Widget/rounded_button.dart';

class UploadImages extends StatefulWidget {
  const UploadImages({super.key});

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// ya Object ya instance hm ny ane images ko firebase ki database ma store krna ka laya
  /// bnya ha .
  final database = FirebaseDatabase.instance.ref("Student");

  /// ya wala method hm ny as laya bnya ha q ka hmy jo images chaya wo to hmy
  /// gallery ya Camera sa chaya to hm na as method ma source define kr dya ha
  /// ka Gallery sa ya Camera sa images pick krne ha .
  Future getImageGallery() async {
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('no image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () => getImageGallery(),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.file(
                            _image!.absolute,
                            fit: BoxFit.fill,
                          ))
                      : const Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            const SizedBox(height: 39),
            RoundButton(
                title: 'Upload',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                    firebase_storage.Reference ref = storage.ref(
                        "/folderName/ ${DateTime.now().microsecondsSinceEpoch}");
                    firebase_storage.Task uploadImage =
                        ref.putFile(_image!.absolute);
                    Future.value(uploadImage).then((value) async {
                      var newUpload = await ref.getDownloadURL();

                      database.child("1").set({
                        "title": "1224",
                        "id": newUpload.toString()
                      }).then((value) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toast("Uploaded Image For FireBase");
                      }).onError((error, stackTrace) {
                        Utils().toast(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    }).onError((error, stackTrace) {
                      Utils().toast(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
