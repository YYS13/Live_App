import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:live/provider/auth.dart';
import 'package:live/screens/home.dart';
import 'package:live/screens/post_detail_screen.dart';
import 'package:live/screens/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:live/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var LoginState;

  void getState(state) async {
    setState(() {
      LoginState = state;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => User(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Colors.red[900],
            buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.red[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
        home: StreamBuilder(
          stream: LoginState,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return TabScreen();
            } else {
              return LoginScreen(getState);
            }
          },
        ),
        routes: {
          "post-detail": ((context) => PostDetail()),
        },
      ),
    );
  }
}
