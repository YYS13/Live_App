import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

class LoginForm extends StatelessWidget {
  final Function ChangeToRegisterFrom;
  final Function trySubmit;
  var userEmail; //信箱
  var userPassword; //密碼

  LoginForm({
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
            if (value.isEmpty || !value.contains("@")) {
              return "請輸入有效信箱";
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: "帳號(信箱)"),
          onSaved: (value) {
            userEmail = value;
            print(value);
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
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            trySubmit();
            Provider.of<User>(context, listen: false)
                .storedLoginData(userEmail, userPassword, context);
          },
          child: Text(
            "登入",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(10),
              shape: Theme.of(context).buttonTheme.shape),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            ChangeToRegisterFrom();
          },
          child: Text(
            "註冊",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(10),
              shape: Theme.of(context).buttonTheme.shape),
        ),
      ],
    );
  }
}
