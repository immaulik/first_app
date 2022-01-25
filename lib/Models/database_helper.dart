import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/src/types/interface.dart';
import 'package:first_app/Models/app_model.dart';
import 'package:first_app/Models/categorymodel.dart';
import 'package:first_app/Models/itemmodel.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as image;

class DatabaseHelper extends GetxController {
  List<CategoryModel> categoryList = [];

  @override
  void onInit() {
    super.onInit();
    getCategory();
  }

  Future<void> getCategory() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .doc(app.userId)
          .collection("Categories")
          .get();
      print(snap.docs);
      List<CategoryModel> list =
          List.from(snap.docs.map((e) => CategoryModel.fromJson(e)));
      categoryList.addAll(list);
      update();
      getItem();
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<void> getItem() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(app.userId)
        .collection("items")
        .get();
    print(snap.docs);
    List<ItemModel> list =
        List.from(snap.docs.map((e) => ItemModel.fromJson(e)));

    list.forEach((item) {
      categoryList.forEach((category) {
        if (item.cId == category.cid) {
          category.itemList.add(item);
        }
      });
    });
    categoryList.forEach((element) {
      print(element.itemList);
    });
    update();
  }

  Future<void> addCategory(String text) async {
    try {
      DocumentReference documentReference = await FirebaseFirestore.instance
          .collection("Users")
          .doc(app.userId)
          .collection("Categories")
          .add({
        'cname': text,
      });
      categoryList.add(CategoryModel(cid: documentReference.id, cname: text));
      update();
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<void> deleteItem(ItemModel itemModel) async {
    CollectionReference item = FirebaseFirestore.instance
        .collection('Users')
        .doc(app.userId)
        .collection("items");
    try {
      item
          .doc(itemModel.itemId)
          .delete()
          .then((value) => print('Item Deleted'))
          .catchError((error) => print("Failed to delete user: $error"));
    } catch (e) {
      printError(info: e.toString());
    }
    categoryList
        .where((element) => element.cid == itemModel.cId)
        .first
        .itemList
        .removeWhere((element) => element.itemId == itemModel.itemId);
    update();
  }

  Future<void> addImages(String cid, List<String> downloadUrls) async {
    downloadUrls.forEach((element) {
      final CollectionReference ref =
          FirebaseFirestore.instance.collection('Users');

      DocumentReference documentReferencer =
          ref.doc(app.userId).collection('items').doc();

      Map<String, dynamic> data = <String, dynamic>{
        "cId": cid,
        "imageUrl": element,
      };

      documentReferencer
          .set(data)
          .whenComplete(() => print("Notes item added to the database"))
          .catchError((e) => print(e));
          categoryList.where((element) => element.cid==cid).first.itemList.add(ItemModel(cId: cid,imageUrl: element));
    });
    
    print("Image is uploaded");
    update();
  }
}
