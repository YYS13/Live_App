import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:live/provider/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:live/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        home: LoginScreen(),
      ),
    );
  }
}
