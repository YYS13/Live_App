import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  DocumentSnapshot _user;
  var _uid = FirebaseAuth.instance.currentUser.uid;
  var _postType;
  var _postTitle;
  var _postContent;
  bool _isLoading = false;

  void getData() async {
    _user =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
  }

  trySubmit() {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();
    }
    return isValid;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.black,
          child: Image.network(
              "https://i.epochtimes.com/assets/uploads/2018/04/house-3084040_1280-600x400.jpg"),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: _isLoading
              ? CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      DropdownButtonFormField(
                          validator: ((value) {
                            if (value == null) {
                              return "請選擇類型";
                            }
                          }),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              child: Text("校外租屋"),
                              value: "校外租屋",
                            ),
                            DropdownMenuItem(
                              child: Text("學生宿舍"),
                              value: "學生宿舍",
                            )
                          ],
                          onChanged: (value) {
                            _postType = value;
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "請輸入標題";
                          } else if (value.length < 5) {
                            return "標題須超過5個字";
                          }
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "標題", border: OutlineInputBorder()),
                        onSaved: (value) {
                          _postTitle = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: ((value) {
                          if (value == null) {
                            return "請輸入內容";
                          } else if (value.length < 20) {
                            return "內容須至少輸入20個字";
                          }
                        }),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: "內容"),
                        maxLines: 15,
                        onSaved: (value) {
                          _postContent = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus(); //送出表單後關閉鍵盤
                          var isValid = trySubmit();
                          print(_user.get("username"));
                          if (isValid) {
                            setState(() {
                              _isLoading = !_isLoading;
                            });
                            try {
                              FirebaseFirestore.instance
                                  .collection("dormitory")
                                  .doc()
                                  .set({
                                "UserId": _uid,
                                "Poster": _user.get("username"),
                                "PosterSex": _user.get("Sex"),
                                "PostType": _postType,
                                "PostTitle": _postTitle,
                                "PostContent": _postContent,
                                "PosterMajor": _user.get("major"),
                              });
                              setState(() {
                                _isLoading = !_isLoading;
                              });
                            } on FirebaseAuthException catch (err) {
                              setState(() {
                                _isLoading = !_isLoading;
                              });
                              var message = err.message;
                              print(message);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text(message, textAlign: TextAlign.center),
                                backgroundColor: Colors.red,
                              ));
                            }
                            ;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("上傳成功", textAlign: TextAlign.center),
                                backgroundColor: Colors.green[400]));
                          }
                        },
                        child: Text("分享", style: TextStyle(fontSize: 15)),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(10),
                            shape: Theme.of(context).buttonTheme.shape),
                      )
                    ],
                  ),
                ),
        )
      ]),
    );
  }
}
