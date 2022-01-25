import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/Controller/firebase_authentication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(FirebaseAuthentication());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meet Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Authenticate(),
    );
  }
}

class Authenticate extends StatelessWidget {
  Authenticate({Key? key}) : super(key: key);

  final authController = Get.find<FirebaseAuthentication>();

  @override
  Widget build(BuildContext context) {
    authController.getCurrentUser();
    return Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
