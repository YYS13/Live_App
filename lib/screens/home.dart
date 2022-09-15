import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatelessWidget {
  final routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("首頁"),
    );
  }
}
