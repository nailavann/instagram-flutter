import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/utils/color.dart';
import 'package:instagram_flutter/widgets/post_card.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    addCurrentUserData();
  }

  addCurrentUserData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: user == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : user.following.isNotEmpty
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', whereIn: user.following)
                        .limit(user.following.length)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return PostCard(
                                    post: snapshot.data!.docs[index].data());
                              },
                            );
                    })
                : Container());
  }
}
