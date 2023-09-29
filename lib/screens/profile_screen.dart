import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  var uid = FirebaseAuth.instance.currentUser.uid.toString();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser.uid.toString())
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black)),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_box,
                                size: 30,
                              ),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          userSnapshot.data["StudentId"],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black)),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                size: 30,
                              ),
                              Expanded(
                                  child: Center(
                                      child: Text(userSnapshot.data["username"],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black)),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.school_sharp,
                                size: 30,
                              ),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                userSnapshot.data["major"],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black)),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.attach_money_outlined,
                                size: 30,
                              ),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                userSnapshot.data["coin"].toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              content: Text("您確定要登出嗎?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    FirebaseAuth.instance.signOut();
                                  },
                                  child: Text("確定"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        padding: EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                    },
                                    child: Text("取消")),
                              ],
                            );
                          });
                    },
                    child: Text(
                      "登出",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(15),
                        shape: Theme.of(context).buttonTheme.shape),
                  )
                ],
              ),
            ),
          );
        });
  }
}
