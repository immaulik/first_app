import 'package:firebase_auth/firebase_auth.dart';

AppModel app = AppModel();

class AppModel {
  static final AppModel _appModel = AppModel.internal();

  factory AppModel() => _appModel;

  AppModel.internal();

  User? user;

  bool get hashUser => user != null;

  String get userId => user!.uid;
  
}
