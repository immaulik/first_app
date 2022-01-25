import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/Models/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditImageBox extends StatefulWidget {
  String cid;
  EditImageBox(this.cid, {Key? key}) : super(key: key);

  @override
  State<EditImageBox> createState() => _EditImageBoxState();
}

class _EditImageBoxState extends State<EditImageBox> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _helperController = Get.find<DatabaseHelper>();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> downloadUrls = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      setState(() {
        imageFileList.addAll(selectedImages);
      });
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Images'),
      content: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                selectImages();
              },
              child: const Text('Select Images'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    itemCount: imageFileList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(imageFileList[index].path),
                        fit: BoxFit.cover,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () async {
              showLoaderDialog(context);
              await Future.forEach(imageFileList, (element) async {
                XFile file = element as XFile;
                String name = file.name;
                try {
                  var storageReference =
                      FirebaseStorage.instance.ref().child('Images/$name');
                  var uploadTask =
                      await storageReference.putFile(File(file.path));
                  print('File Uploaded');
                  if (uploadTask != null) {
                    await storageReference
                        .getDownloadURL()
                        .then((value) => downloadUrls.add(value));
                    _helperController.addImages(widget.cid, downloadUrls);
                  }
                } catch (e) {
                  print("Error ayvi " + e.toString());
                  Navigator.pop(context);
                }
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Submit'))
      ],
    );
  }
}
