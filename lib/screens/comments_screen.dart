import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/services/firestore.dart';
import 'package:instagram_flutter/utils/color.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final post;
  const CommentsScreen({Key? key, this.post}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late TextEditingController _commentController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackground,
        title: const Text("Yorumlar"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.post['postId'])
                  .collection('comments')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return CommentCard(
                            comment: snapshot.data!.docs[index].data());
                      });
                }
                return Container();
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user!.photoUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                        hintText: 'Yorum ekle', border: InputBorder.none),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (_commentController.text.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    await FirestoreServices()
                        .postComment(
                            _commentController.text,
                            widget.post['postId'],
                            user.username,
                            user.uid,
                            user.photoUrl)
                        .whenComplete(() => _commentController.clear());

                    isLoading = false;
                  } else {
                    showSnackBar("Yorum giriniz...", context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: const Text(
                    'Gönder',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
