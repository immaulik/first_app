import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/Controller/firebase_authentication.dart';
import 'package:first_app/Models/app_model.dart';
import 'package:first_app/Models/database_helper.dart';
import 'package:first_app/basedialogbox.dart';
import 'package:first_app/editimagebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _categoryController = TextEditingController();
  final authController = Get.find<FirebaseAuthentication>();
  final helperController = Get.put(DatabaseHelper());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DatabaseHelper>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('MainPage'),
            actions: [
              PopupMenuButton<int>(
                onSelected: (item) {
                  authController.signOut();
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(value: 0, child: Text('Logout')),
                ],
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(app.userId)
                .collection("items")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                return ListView.builder(
                    itemCount: helperController.categoryList.length,
                    itemBuilder: (context, index) {
                      // DocumentSnapshot doc = snapshot.data!.docs[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                  title: Text(helperController
                                      .categoryList[index].cname),
                                  trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (value) {
                                        if (value == 1) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return EditImageBox(
                                                  helperController
                                                      .categoryList[index].cid);
                                            },
                                          );
                                        }
                                        if (value == 2) {
                                          helperController.categoryList[index]
                                              .isEdit = true;
                                          helperController.update();
                                        }
                                      },
                                      itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              child: Text("Edit"),
                                              value: 1,
                                            ),
                                            const PopupMenuItem(
                                              child: Text("Delete"),
                                              value: 2,
                                            )
                                          ])),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: helperController
                                  .categoryList[index].itemList
                                  .map((e) {
                                return Stack(
                                  children: [
                                    Positioned(
                                      child: Container(
                                        height: 110,
                                        width: 110,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 3,
                                                color: Colors.blueAccent)),
                                        child: Image.network(
                                          e.imageUrl,
                                          // height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    if (helperController
                                        .categoryList[index].isEdit)
                                      Positioned(
                                          right: 00,
                                          width: 50,
                                          height: 50,
                                          child: IconButton(
                                            onPressed: () {
                                              helperController
                                                  .categoryList[index]
                                                  .isEdit = false;
                                              helperController
                                                  .deleteItem(e);
                                              helperController.update();
                                            },
                                            color: Colors.amber,
                                            icon: const Icon(Icons.close),
                                          )),
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      );
                    });
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return BaseDialogBox();
                },
              );
            },
            child: const Icon(
              Icons.add,
            ),
            elevation: 5,
            splashColor: Colors.grey,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
