import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  var posterSex;
  var posterMajor;
  var PostType;
  var PostTitle;
  var PostContent;
  var postDocId;
  var userLikedPost;
  var uid;
  var likeNumber;
  PostCard(
      {this.posterSex,
      this.posterMajor,
      this.PostContent,
      this.PostTitle,
      this.PostType,
      this.postDocId,
      this.userLikedPost,
      this.uid,
      this.likeNumber});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _IsLike;
  @override
  void initState() {
    setState(() {
      _IsLike = widget.userLikedPost.contains(widget.uid);
    });
    print(_IsLike);
    print(widget.userLikedPost);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: widget.posterSex == "男"
                          ? Colors.blue[800]
                          : Colors.pink,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.posterMajor),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: Text(
                  widget.PostTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _IsLike = !_IsLike;
                          });
                          if (_IsLike) {
                            print(widget.postDocId);
                            FirebaseFirestore.instance
                                .collection("dormitory")
                                .doc(widget.postDocId)
                                .update({
                              "Like": FieldValue.increment(1),
                              "userLikedPost":
                                  FieldValue.arrayUnion([widget.uid])
                            });
                          }
                          if (_IsLike == false) {
                            FirebaseFirestore.instance
                                .collection("dormitory")
                                .doc(widget.postDocId)
                                .update({
                              "Like": FieldValue.increment(-1),
                              "userLikedPost":
                                  FieldValue.arrayRemove([widget.uid])
                            });
                          }
                        },
                        icon: Icon(Icons.thumb_up),
                        color: _IsLike
                            ? Theme.of(context).primaryColor
                            : Colors.grey),
                    Text(widget.likeNumber.toString()),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: Text(
                          "#" + widget.PostType,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
