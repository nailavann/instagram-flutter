import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/post_screen.dart';
import 'package:instagram_flutter/screens/search_screen.dart';
import 'package:instagram_flutter/utils/color.dart';

import 'add_post_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    setState(() {
      pageController.jumpToPage(page);
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: onPageChanged,
            controller: pageController,
            children: [
              const PostScreen(),
              const SearchScreen(),
              const AddPostScreen(),
              ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
            ]),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: scaffoldBackground,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? Colors.white : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? Colors.white : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? Colors.white : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 3 ? Colors.white : Colors.grey,
            ),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
