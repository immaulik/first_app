import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/Models/itemmodel.dart';

class CategoryModel {
  String cname;
  String cid;
  bool isEdit;
  List<ItemModel> itemList = [];
  CategoryModel({
    this.cname = '',
    this.cid = '',
    this.isEdit = false,
  });

  factory CategoryModel.fromJson(DocumentSnapshot doc) => CategoryModel(
        cid: doc.id.isEmpty ? "" : doc.id,
        cname: doc['cname'],
      );

  Map toJson() {
    Map<String, dynamic> map = {};
    map['cname'] = cname;
    map['cid'] = cid;
    map['isEdit'] = isEdit;
    return map;
  }
}
