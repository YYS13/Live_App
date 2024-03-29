import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

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
  List<File> _images = []; //照片集
  List _imagePath = [];
  final imagePicker = ImagePicker();
  //從相機獲取圖片
  Future getImageFromCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final imagePath = File(image.path);
      setState(() {
        _images.add(imagePath);
      });
    }
    print(_images);
  }

  //從相簿獲取照片
  Future getImageFromGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imagePath = File(image.path);
      setState(() {
        _images.add(imagePath);
      });
    }
    print(_images);
  }

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
    //設定carousell圖片內容樣式
    final List<Widget> imageSliders = _images
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.file(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            // padding: EdgeInsets.symmetric(
                            //     vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Container(
            width: double.infinity,
            height: 200,
            color: Colors.black,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _images.isEmpty
                    ? Image.network(
                        "https://static.vecteezy.com/system/resources/previews/004/141/669/original/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg",
                        fit: BoxFit.cover,
                      )
                    : CarouselSlider(
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                        ),
                        items: imageSliders,
                      ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        getImageFromCamera();
                      },
                      child: Icon(Icons.add_a_photo),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(10),
                          shape: CircleBorder()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getImageFromGallery();
                      },
                      child: Icon(Icons.add_photo_alternate_rounded),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(10),
                          shape: CircleBorder()),
                    ),
                  ],
                )
              ],
            )),
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
                            final refDoc = await FirebaseFirestore.instance
                                .collection("dormitory")
                                .doc();
                            final refDocId = refDoc.id;
                            //存圖片
                            for (int i = 0; i < _images.length; i++) {
                              await FirebaseStorage.instance
                                  .ref("${refDocId}/$i")
                                  .putFile(_images[i]);
                              await FirebaseStorage.instance
                                  .ref("${refDocId}/$i")
                                  .getDownloadURL()
                                  .then((value) => _imagePath.add(value));
                            }
                            try {
                              //存資料
                              refDoc.set({
                                "PosterId": _uid,
                                "Poster": _user.get("username"),
                                "PosterSex": _user.get("Sex"),
                                "PostType": _postType,
                                "PostTitle": _postTitle,
                                "PostContent": _postContent,
                                "PosterMajor": _user.get("major"),
                                "Like": 0,
                                "disLike": 0,
                                "userDisLikedPost": [],
                                "userLikedPost": [], //有誰按讚
                                "authorization": [_uid],
                                "imagePath": _imagePath,
                                "date": DateFormat("yyyy/MM/dd")
                                    .format(DateTime.now()),
                              });
                              setState(() {
                                _isLoading = !_isLoading;
                                _images = [];
                                _imagePath = [];
                              });
                              if (_user.get("postCount") < 5) {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(_uid)
                                    .update({"coin": FieldValue.increment(50)});
                              }
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(_uid)
                                  .update(
                                      {"postCount": FieldValue.increment(1)});
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
                            if (_user.get("postCount") < 5) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("上傳成功,獲得50逢甲幣",
                                          textAlign: TextAlign.center),
                                      backgroundColor: Colors.green[400]));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("上傳成功(已達每月貼文獎勵次數(5次))",
                                          textAlign: TextAlign.center),
                                      backgroundColor: Colors.green[400]));
                            }
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
