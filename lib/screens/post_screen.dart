import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/services/auth.dart';
import 'package:instagram_flutter/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();

    currentUserInfo();
  }

  currentUserInfo() async {
    await AuthServices().getUserDetails().then((value) {
      if (mounted) {
        setState(() {
          userModel = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(userModel?.username);
    return Scaffold(
      body: userModel == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userModel!.email),
                    Text(userModel!.username)
                  ]),
            ),
    );
  }
}
