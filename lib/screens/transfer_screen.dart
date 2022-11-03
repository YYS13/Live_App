import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart' as u;

class TransferScreen extends StatefulWidget {
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser.uid;
  bool _isLoading = false;
  var _transferOut;
  var _transferIn;
  var _transferAmount;
  var _transferPassword;
  var _transferCommand;
  trySubmit() {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();
    }
    return isValid;
  }

  getCurrentUser(uid) async {
    return await FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  //交易
  void transfer(id, transferOut, transferIn, transferAmount, transferPassword,
      transferCommand) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"coin": FieldValue.increment(0 - int.parse(transferAmount))});
    var inId;
    await FirebaseFirestore.instance
        .collection("users")
        .where("StudentId", isEqualTo: transferIn)
        .get()
        .then((value) {
      inId = value.docs.first.id;
    });
    print(inId);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(inId)
        .update({"coin": FieldValue.increment(int.parse(transferAmount))});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrentUser(uid),
        builder: (context, userData) {
          if (userData.hasData) {
            return Center(
              child: SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            validator: ((value) {
                              if (value == "") {
                                return "轉出帳戶不得為空";
                              } else if (value.length != 8) {
                                return "學號應為8個字符";
                              }
                            }),
                            initialValue:
                                "${userData.data.get("StudentId").toString()}",
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "轉出帳號(學號)",
                                labelText: "轉出帳戶",
                                labelStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            onSaved: (value) {
                              _transferOut = value;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: ((value) {
                              if (value == "") {
                                return "轉入帳戶不得為空";
                              } else if (value.length != 8) {
                                return "學號應為8個字符";
                              }
                            }),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "轉入帳號(學號)",
                                labelText: "轉入帳戶",
                                labelStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            onSaved: (value) {
                              _transferIn = value;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: ((value) {
                              if (value == "") {
                                return "請輸入轉帳金額";
                              } else if (int.parse(value) >
                                  userData.data.get("coin")) {
                                return "餘額不足";
                              }
                            }),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "金額",
                                hintText: "轉帳金額(逢甲幣)",
                                labelStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            onSaved: (value) {
                              _transferAmount = value;
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "可用餘額:${userData.data.get("coin").toString()}逢甲幣",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: ((value) {
                              if (value == "") {
                                return "請輸入交易密碼";
                              }
                            }),
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "交易密碼",
                                labelStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            onSaved: (value) {
                              _transferPassword = value;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "備註",
                                labelStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            onSaved: (value) {
                              _transferCommand = value;
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .unfocus(); //送出表單後關閉鍵盤
                                    var isValid = trySubmit();
                                    if (isValid) {
                                      setState(() {
                                        _isLoading = !_isLoading;
                                      });
                                      if (_transferPassword !=
                                          userData.data
                                              .get("transcationPassword")) {
                                        setState(() {
                                          _isLoading = !_isLoading;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("交易密碼錯誤",
                                              textAlign: TextAlign.center),
                                          backgroundColor: Colors.red,
                                        ));
                                        return;
                                      }
                                      if (_transferOut ==
                                          userData.data.get("StudentId")) {
                                        try {
                                          transfer(
                                              uid,
                                              _transferOut,
                                              _transferIn,
                                              _transferAmount,
                                              _transferPassword,
                                              _transferCommand);
                                          setState(() {
                                            _isLoading = !_isLoading;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text("交易完成",
                                                      textAlign:
                                                          TextAlign.center),
                                                  backgroundColor:
                                                      Colors.green[400]));
                                        } catch (err) {
                                          setState(() {
                                            _isLoading = !_isLoading;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("交易失敗，請稍後再試",
                                                textAlign: TextAlign.center),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      } else {
                                        setState(() {
                                          _isLoading = !_isLoading;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("轉出帳戶錯誤",
                                              textAlign: TextAlign.center),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "確認交易",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SingleChildScrollView();
          }
        });
  }
}
