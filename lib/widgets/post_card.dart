import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  var posterId;
  var posterSex;
  var posterMajor;
  var PostType;
  var PostTitle;
  var PostContent;
  var postDocId;
  var userLikedPost;
  var uid;
  var likeNumber;
  var disLikeNumber;
  var userDisLikedPost;
  var authorization;
  var date;
  List imagePath;
  PostCard(
      {this.posterId,
      this.posterSex,
      this.posterMajor,
      this.PostContent,
      this.PostTitle,
      this.PostType,
      this.postDocId,
      this.userLikedPost,
      this.uid,
      this.likeNumber,
      this.disLikeNumber,
      this.userDisLikedPost,
      this.authorization,
      this.imagePath,
      this.date});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _IsLike;
  bool _disLike;
  @override
  void initState() {
    setState(() {
      _IsLike = widget.userLikedPost.contains(widget.uid);
      _disLike = widget.userDisLikedPost.contains(widget.uid);
    });
    print(_IsLike);
    print(widget.userLikedPost);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "post-detail", arguments: {
          "posterId": widget.posterId,
          "content": widget.PostContent,
          "title": widget.PostTitle,
          "type": widget.PostType,
          "postId": widget.postDocId,
          "major": widget.posterMajor,
          "sex": widget.posterSex,
          "uid": widget.uid,
          "authorization": widget.authorization,
          "imagePath": widget.imagePath,
          "date": widget.date,
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Column(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              if (_disLike) return;
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
                        IconButton(
                            onPressed: () {
                              if (_IsLike) return;
                              setState(() {
                                _disLike = !_disLike;
                              });
                              if (_disLike) {
                                FirebaseFirestore.instance
                                    .collection("dormitory")
                                    .doc(widget.postDocId)
                                    .update({
                                  "disLike": FieldValue.increment(1),
                                  "userDisLikedPost":
                                      FieldValue.arrayUnion([widget.uid])
                                });
                              }
                              if (_disLike == false) {
                                FirebaseFirestore.instance
                                    .collection("dormitory")
                                    .doc(widget.postDocId)
                                    .update({
                                  "disLike": FieldValue.increment(-1),
                                  "userDisLikedPost":
                                      FieldValue.arrayRemove([widget.uid])
                                });
                              }
                            },
                            icon: Icon(Icons.thumb_down),
                            color: _disLike ? Colors.blue[500] : Colors.grey),
                        Text(widget.disLikeNumber.toString()),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
