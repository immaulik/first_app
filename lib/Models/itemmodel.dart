import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String cId;
  String imageUrl;
  String itemId;

  ItemModel({this.cId = '', this.imageUrl = '', this.itemId = ''});

  factory ItemModel.fromJson(DocumentSnapshot doc) => ItemModel(
        cId: doc['cId'],
        imageUrl: doc['imageUrl'],
        itemId: doc.id.isEmpty ? "" : doc.id,
      );

  Map toJson() {
    Map<String, dynamic> map = {};
    map['cId'] = cId;
    map['imageUrl'] = imageUrl;
    map['itemId'] = itemId;
    return map;
  }
}
