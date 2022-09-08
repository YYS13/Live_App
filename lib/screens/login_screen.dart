import 'package:flutter/material.dart';
import 'package:live/widgets/register_form.dart';

import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String userName = ""; //姓名
  String userPassword = ""; //密碼
  String userEmail = ""; //信箱
  String userSex = ""; //性別
  String userMajor = ""; //系所
  var IsLogin = true;
  var IsLoading = false;

  void ChangeToRegisterFrom() {
    setState(() {
      IsLogin = !IsLogin;
    });
  }

  //針對輸入進行validate，沒問題則儲存輸入內容
  void trySubmit() {
    final isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus(); //送出表單後關閉鍵盤

    if (isValid) {
      formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("適逢其所"),
        centerTitle: true,
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 100,
                width: 200,
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJOKcvjavatFY3ejDYtad_4biWz6WWrHTGdA&usqp=CAU',
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                    key: formKey, //做validate的
                    child: IsLogin
                        ? LoginForm(
                            trySubmit: trySubmit,
                            ChangeToRegisterFrom: ChangeToRegisterFrom,
                          )
                        : RegisterForm(
                            trySubmit: trySubmit,
                            ChangeToRegisterFrom: ChangeToRegisterFrom,
                          )),
              )),
            ],
          ),
        ),
      )),
    );
  }
}
