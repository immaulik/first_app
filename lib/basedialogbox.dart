import 'package:first_app/Models/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class BaseDialogBox extends StatelessWidget {
  TextEditingController categoryController = TextEditingController();
  final _helperController = Get.find<DatabaseHelper>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: TextField(
        controller: categoryController,
        decoration: const InputDecoration(hintText: 'Enter Category'),
      ),
      actions: [
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () {
            _helperController.addCategory(categoryController.text);
            Navigator.pop(context);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
