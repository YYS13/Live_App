import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostDetail extends StatefulWidget {
  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  String _content;
  String _title;
  String _type;
  String _postId;
  String _major;
  String _sex;
  String _uid;
  String _LineId;
  var _authorization;
  List _imagesPath = [];

  @override
  Widget build(BuildContext context) {
    dynamic PostArgs = ModalRoute.of(context).settings.arguments;
    _content = PostArgs["content"];
    _title = PostArgs["title"];
    _type = PostArgs["type"];
    _postId = PostArgs["postId"];
    _major = PostArgs["major"];
    _sex = PostArgs["sex"];
    _uid = PostArgs["uid"];
    _authorization = PostArgs["authorization"];
    _imagesPath = PostArgs["imagePath"];

    getLineId() async {
      var i =
          await FirebaseFirestore.instance.collection("users").doc(_uid).get();
      _LineId = i.get("LineId");
    }

    setState(() {
      getLineId();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("適逢其所"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 9,
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor:
                                _sex == "男" ? Colors.blue[800] : Colors.pink,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            _major,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              //  color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 5,
                        child: ElevatedButton(
                          onPressed: () {
                            print(_authorization);
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    title: Text("注意"),
                                    content: Text("取得聯絡資訊需支付10逢甲幣，您確定要支付嗎?"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                        },
                                        child: Text("確定"),
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor,
                                            padding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                        },
                                        child: Text("取消"),
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor,
                                            padding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "取得聯絡資訊",
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ))
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  _title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(_content,
                        style: TextStyle(
                          fontSize: 20, //color: Colors.white
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _imagesPath.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Image.network(
                            _imagesPath[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }),
            )
            // CarouselSlider(
            //   options: CarouselOptions(
            //     enableInfiniteScroll: false,
            //     aspectRatio: 2.0,
            //     enlargeCenterPage: true,
            //   ),
            //   items: imageSliders,
            // ),
          ],
        ),
      ),
    );
  }
}
