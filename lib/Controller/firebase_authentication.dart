import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Models/app_model.dart';
import 'package:first_app/loginpage.dart';
import 'package:first_app/mainpage.dart';
import 'package:get/get.dart';

class FirebaseAuthentication extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<User?> getCurrentUser() {
    StreamSubscription<User?> streamSubscription;
    streamSubscription = _auth.authStateChanges().listen((event) {
      if (event != null) {
        app.user = event;
        Get.offAll(() => MainPage());
      } else {
        app.user = null;
        Get.offAll(() => LoginPage());
      }
    });
    return streamSubscription;
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signOut() async{
    try{
       await FirebaseAuth.instance.signOut();
    }
    on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  
}
