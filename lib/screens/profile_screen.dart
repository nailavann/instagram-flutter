import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/edit_profile_screen.dart';
import 'package:instagram_flutter/screens/photo_detail_screen.dart';
import 'package:instagram_flutter/screens/user_follower_screen.dart';
import 'package:instagram_flutter/screens/user_following_screen.dart';
import 'package:instagram_flutter/services/firestore.dart';
import 'package:instagram_flutter/utils/color.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;

      //current user post length !!!
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLength = postSnap.docs.length;

      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return userData.isEmpty
        ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(userData['username']),
              centerTitle: false,
              backgroundColor: scaffoldBackground,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    dataColumn(postLength, 'Gönderi'),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return UserFollowersScreen(
                                                  user: userData);
                                            },
                                          ));
                                        },
                                        child:
                                            dataColumn(followers, 'Takipçi')),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return UserFollowingScreen(
                                                  user: userData);
                                            },
                                          ));
                                        },
                                        child: dataColumn(following, 'Takip'))
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        userData['uid']
                                    ? FollowButton(
                                        func: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return EditProfileScreen(
                                                userData: userData,
                                              );
                                            },
                                          ));
                                        },
                                        text: "Profili Düzenle",
                                        color: const Color.fromARGB(
                                            255, 32, 32, 32))
                                    : isFollowing
                                        ? FollowButton(
                                            func: () async {
                                              await FirestoreServices()
                                                  .followUsers(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                            text: "Takiptesin",
                                            color: const Color.fromARGB(
                                                255, 32, 32, 32))
                                        : FollowButton(
                                            func: () async {
                                              await FirestoreServices()
                                                  .followUsers(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                              setState(() {});
                                              isFollowing = true;
                                              followers++;
                                            },
                                            text: "Takip et",
                                            color: Colors.blue)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        userData['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(userData['bio'] ?? ""),
                      const Divider(
                        color: Colors.grey,
                      ),
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .where('uid', isEqualTo: widget.uid)
                              .get(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    var post = snapshot.data.docs[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return PhotoDetailScreen(
                                                post: post);
                                          },
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.network(
                                          post['postUrl'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  });
                            }
                            return Container();
                          })
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

Column dataColumn(int num, String label) {
  return Column(
    children: [
      Text(num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text(
        label,
        style: const TextStyle(fontSize: 15, color: Colors.grey),
      )
    ],
  );
}
