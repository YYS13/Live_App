import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live/screens/home.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.getState);
  Function(
    Stream state,
  ) getState; //將登入狀態傳給root用的function
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<DropdownMenuItem> major = [
    DropdownMenuItem(
      child: Text("資工系"),
      value: "資工系",
    ),
    DropdownMenuItem(
      child: Text("電機系"),
      value: "電機系",
    ),
    DropdownMenuItem(
      child: Text("航太系"),
      value: "航太系",
    ),
    DropdownMenuItem(
      child: Text("機電系"),
      value: "機電系",
    ),
    DropdownMenuItem(
      child: Text("工工系"),
      value: "工工系",
    ),
    DropdownMenuItem(
      child: Text("環工系"),
      value: "環工系",
    ),
    DropdownMenuItem(
      child: Text("化工系"),
      value: "化工系",
    ),
    DropdownMenuItem(
      child: Text("材料系"),
      value: "材料系",
    ),
    DropdownMenuItem(
      child: Text("財金系"),
      value: "財金系",
    ),
    DropdownMenuItem(
      child: Text("國貿系"),
      value: "國貿系",
    ),
    DropdownMenuItem(
      child: Text("會計系"),
      value: "會計系",
    ),
    DropdownMenuItem(
      child: Text("行銷系"),
      value: "行銷系",
    ),
    DropdownMenuItem(
      child: Text("統計系"),
      value: "統計系",
    ),
    DropdownMenuItem(
      child: Text("水利系"),
      value: "水利系",
    ),
    DropdownMenuItem(
      child: Text("土木系"),
      value: "土木系",
    ),
  ];

  var state;
  final _controller = new TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String registerEmail;
  String registerPassword;
  String uid;
  var userStudentId; //學號
  String userName = ""; //姓名
  String userPassword = ""; //密碼
  String registerTranscationPassword; //交易密碼
  String LineId; //Line ID (聯絡用)
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
  trySubmit() {
    final isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus(); //送出表單後關閉鍵盤

    if (isValid) {
      formKey.currentState.save();
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                child: Image.asset(
                  'assets/school_icon.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                    key: formKey, //做validate的
                    child: IsLogin
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                key: ValueKey("email"),
                                validator: (value) {
                                  if (value.isEmpty || !value.contains("@")) {
                                    return "請輸入有效信箱";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration:
                                    InputDecoration(labelText: "帳號(信箱)"),
                                onSaved: (value) {
                                  userEmail = value;
                                  print(value);
                                },
                              ),
                              TextFormField(
                                key: ValueKey("password"),
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
                              if (IsLoading) CircularProgressIndicator(),
                              if (!IsLoading)
                                ElevatedButton(
                                  onPressed: () async {
                                    var valid = trySubmit();
                                    setState(() {
                                      IsLoading = !IsLoading;
                                    });
                                    if (valid) {
                                      state = await Provider.of<User>(context,
                                              listen: false)
                                          .storedLoginData(
                                              userEmail, userPassword, context);
                                      print(state);
                                      widget.getState(state); //將登入狀態傳給root用
                                    }
                                    setState(() {
                                      IsLoading = !IsLoading;
                                    });
                                    _controller.clear();
                                  },
                                  child: Text(
                                    "登入",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.all(10),
                                      shape:
                                          Theme.of(context).buttonTheme.shape),
                                ),
                              SizedBox(height: 10),
                              if (!IsLoading)
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
                                      shape:
                                          Theme.of(context).buttonTheme.shape),
                                ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "請輸入學號";
                                  } else if (value.length != 8) {
                                    return "學號應為8個字符";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(labelText: "學號"),
                                onSaved: (value) {
                                  userStudentId = value;
                                },
                              ),
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
                              DropdownButtonFormField(
                                isExpanded: true,
                                items: major,
                                decoration: InputDecoration(labelText: "系所"),
                                validator: (value) {
                                  if (value == null) {
                                    return "請選擇系所";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    userMajor = value;
                                  });
                                },
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
                                decoration:
                                    InputDecoration(labelText: "帳號(信箱)"),
                                onSaved: (value) {
                                  registerEmail = value;
                                },
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty || value.length < 7) {
                                    return "密碼長度至少需7個字元或數字";
                                  }
                                },
                                decoration: InputDecoration(labelText: "密碼"),
                                obscureText: true,
                                onSaved: (value) {
                                  registerPassword = value;
                                },
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty || value.length < 5) {
                                    return "密碼長度至少需5個字元或數字";
                                  }
                                },
                                decoration: InputDecoration(labelText: "交易密碼"),
                                obscureText: true,
                                onSaved: (value) {
                                  registerTranscationPassword = value;
                                },
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "必須輸入聯絡資訊";
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: "聯絡資訊", hintText: "Line ID"),
                                onSaved: (value) {
                                  LineId = value;
                                },
                              ),
                              DropdownButtonFormField(
                                items: [
                                  DropdownMenuItem(
                                      child: Text("男"), value: "男"),
                                  DropdownMenuItem(child: Text("女"), value: "女")
                                ],
                                decoration: InputDecoration(labelText: "性別"),
                                validator: (value) {
                                  if (value == null) {
                                    return "請輸入性別";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    userSex = value;
                                  });
                                },
                                onSaved: (value) {
                                  userSex = value;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              if (IsLoading) CircularProgressIndicator(),
                              if (!IsLoading)
                                ElevatedButton(
                                  onPressed: () async {
                                    var valid = trySubmit();
                                    setState(() {
                                      IsLoading = !IsLoading;
                                    });
                                    if (valid) {
                                      await Provider.of<User>(
                                              scaffoldKey.currentContext,
                                              listen: false)
                                          .storedRigisterData(
                                              registerEmail,
                                              registerPassword,
                                              userStudentId,
                                              userName,
                                              userMajor,
                                              userSex,
                                              scaffoldKey.currentContext,
                                              registerTranscationPassword,
                                              LineId);
                                    }
                                    setState(() {
                                      IsLoading = !IsLoading;
                                    });
                                    _controller.clear();
                                  },
                                  child: Text(
                                    "確認",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.all(10),
                                      shape:
                                          Theme.of(context).buttonTheme.shape),
                                ),
                              SizedBox(height: 10),
                              if (!IsLoading)
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
                                      shape:
                                          Theme.of(context).buttonTheme.shape),
                                ),
                            ],
                          )),
              )),
            ],
          ),
        ),
      )),
    );
  }
}
