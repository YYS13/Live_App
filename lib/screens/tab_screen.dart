import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:live/screens/home.dart';
import 'package:live/screens/post_screen.dart';
import 'package:live/screens/profile_screen.dart';
import 'package:live/screens/school_screen.dart';
import 'package:live/screens/transfer_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Widget> pages = [
    HomeScreen(),
    TransferScreen(),
    PostScreen(),
    SchoolScreen(),
    ProfileScreen()
  ];

  int selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("適逢其所"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: pages[selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        selectedItemColor: Colors.red[900],
        unselectedItemColor: Colors.grey,
        currentIndex: selectedPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首頁"),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "轉帳"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "新增"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "學校資源"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "帳戶"),
        ],
      ),
    );
  }
}