import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class User with ChangeNotifier {
  var userId;
  var userData;
  String _userEmail;
  String _userPassword;
  var _userStudentId;
  String _userName;
  String _userMajor;
  String _userSex;
  final _auth = FirebaseAuth.instance;

  Future storedLoginData(
      String userEmail, String userPassword, BuildContext ctx) async {
    _userEmail = userEmail;
    _userPassword = userPassword;
    var authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(
          email: _userEmail, password: _userPassword);
      userId = authResult.user.uid; //assign id 給global id 變數
      return FirebaseAuth.instance.authStateChanges();
    } on FirebaseAuthException catch (err) {
      print(err);
      var message = err.message;
      print(message);
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      ));
    }
    notifyListeners();
  } //按下登入按鈕執行

  void storedRigisterData(
    String userEmail,
    String userPassword,
    userStudentId,
    String userName,
    String userMajor,
    String userSex,
    BuildContext ctx,
  ) async {
    _userStudentId = userStudentId;
    _userEmail = userEmail;
    _userPassword = userPassword;
    _userName = userName;
    _userMajor = userMajor;
    _userSex = userSex;
    print(userEmail);
    print(userPassword);
    var authResult;
    try {
      authResult = await _auth.createUserWithEmailAndPassword(
          email: _userEmail, password: _userPassword); //註冊帳戶
      print(authResult);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(authResult.user.uid)
          .set({
        "StudentId": _userStudentId,
        "username": _userName,
        "major": _userMajor,
        "Sex": _userSex,
        "Coins": 100,
      }); //存帳號密碼以外的資料
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text("註冊成功", textAlign: TextAlign.center),
        backgroundColor: Colors.green[400],
      ));
    } on FirebaseAuthException catch (err) {
      var message = err.message;
      switch (message) {
        case "The email address is already in use by another account.":
          message = "此信箱已被使用";
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      ));
    }
    notifyListeners();
  } //按下註冊鍵執行
}
