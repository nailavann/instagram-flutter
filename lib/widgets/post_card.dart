import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/comments_screen.dart';
import 'package:instagram_flutter/services/firestore.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final post;
  const PostCard({Key? key, this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool likeAnimating = false;
  int commentsLength = 0;

  @override
  void initState() {
    super.initState();
    getCommentLength();
  }

  getCommentLength() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post['postId'])
        .collection('comments')
        .get();

    commentsLength = snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //HEADER
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.post['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.post['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: ['Sil', 'Şikayet Et']
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(e),
                                          ))
                                      .toList(),
                                ),
                              ));
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          //IMAGE
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreServices().likesPost(
                  widget.post['postId'], user!.username, widget.post['likes']);
              setState(() {
                likeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    widget.post['postUrl'],
                    height: MediaQuery.of(context).size.height * 0.37,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: likeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                      isAnimating: likeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        setState(() {
                          likeAnimating = false;
                        });
                      }),
                )
              ],
            ),
          ),
          //ICONBUTTONS
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.post['likes'].contains(user?.username),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreServices().likesPost(widget.post['postId'],
                        user!.username, widget.post['likes']);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.post['likes'].contains(user?.username)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send))
            ],
          ),
          //DESCRIPTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView.builder(
                              itemCount: widget.post['likes'].length,
                              itemBuilder: (context, index) {
                                if (widget.post['likes'][index] != null) {
                                  return Text(widget.post['likes'][index]);
                                }
                                return Container();
                              },
                            ),
                          );
                        });
                  },
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        widget.post['likes'].length.toString() + " beğeni",
                        style: const TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: widget.post['username']),
                      TextSpan(text: ' ' + widget.post['description']),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommentsScreen(post: widget.post);
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      commentsLength.toString() + " yorumun tümünü gör",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    DateFormat('d/MM/y').format(widget.post['date'].toDate()),
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
