import 'package:flutter/material.dart';
import 'package:live/provider/auth.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  final Function trySubmit;
  final Function ChangeToRegisterFrom;
  var userName; //姓名
  var userPassword; //密碼
  var userEmail; //信箱
  var userSex; //性別
  var userMajor; //系所

  RegisterForm({
    this.trySubmit,
    this.ChangeToRegisterFrom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "請輸入姓名";
            } else if (value.length < 2) {
              return "姓名須超過2個字";
            }
            return null;
          },
          keyboardType: TextInputType.name,
          decoration: InputDecoration(labelText: "姓名"),
          onSaved: (value) {
            userName = value;
          },
        ),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "請輸入系所";
            }
            return null;
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "系所"),
          onSaved: (value) {
            userMajor = value;
          },
        ),
        TextFormField(
          validator: (value) {
            if (value.isEmpty || !value.contains("@")) {
              return "請輸入有效信箱";
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: "帳號(信箱)"),
          onSaved: (value) {
            userEmail = value;
          },
        ),
        TextFormField(
          validator: (value) {
            if (value.isEmpty || value.length < 7) {
              return "密碼長度至少需7個字元";
            }
          },
          decoration: InputDecoration(labelText: "密碼"),
          obscureText: true,
          onSaved: (value) {
            userPassword = value;
          },
        ),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "請輸入性別";
            }
            return null;
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "性別"),
          onSaved: (value) {
            userSex = value;
          },
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            trySubmit();
            Provider.of<User>(context, listen: false).storedRigisterData(
                userEmail, userPassword, userName, userMajor, userSex, context);
          },
          child: Text(
            "確認",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(10),
              shape: Theme.of(context).buttonTheme.shape),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {
            ChangeToRegisterFrom();
          },
          child: Text(
            "已有帳戶",
            style: TextStyle(fontSize: 15),
          ),
          style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(10),
              shape: Theme.of(context).buttonTheme.shape),
        ),
      ],
    );
  }
}
