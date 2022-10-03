import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:live/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final routeName = "/home";
  var _user;
  var _uid = FirebaseAuth.instance.currentUser.uid;

  void fetchData() async {
    //抓用戶資料
    _user =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    print(_user);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("dormitory").snapshots(),
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final postDoc = postSnapshot.data.docs;
          return ListView.builder(
            itemCount: postDoc.length,
            itemBuilder: ((context, index) {
              return PostCard(
                posterMajor: postDoc[index]["PosterMajor"],
                posterSex: postDoc[index]["PosterSex"],
                PostTitle: postDoc[index]["PostTitle"],
                PostContent: postDoc[index]["PostContent"],
                PostType: postDoc[index]["PostType"],
              );
            }),
          );
        });
  }
}
