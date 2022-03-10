import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/edit_profile_screen.dart';
import 'package:instagram_flutter/screens/photo_detail_screen.dart';
import 'package:instagram_flutter/screens/saves_screen.dart';
import 'package:instagram_flutter/screens/user_follower_screen.dart';
import 'package:instagram_flutter/screens/user_following_screen.dart';
import 'package:instagram_flutter/services/auth.dart';
import 'package:instagram_flutter/services/firestore.dart';
import 'package:instagram_flutter/utils/color.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';

import 'login/login_screen.dart';

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

  showBottomBar() {
    showModalBottomSheet(
        backgroundColor: scaffoldBackground,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 32, 32, 32),
                borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(children: [
              listTile(const Icon(Icons.settings), "Ayarlar", null, context,
                  false, null),
              const Divider(),
              listTile(
                  const Icon(Icons.bookmark_border),
                  "Kaydedilenler",
                  SavesScreen(uid: FirebaseAuth.instance.currentUser!.uid),
                  context,
                  false,
                  null),
              const Divider(),
              listTile(const Icon(Icons.logout), "Çıkış Yap", null, context,
                  true, userData),
            ]),
          );
        });
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
              actions: [
                IconButton(
                    onPressed: showBottomBar,
                    icon: const Icon(
                      Icons.menu,
                    ))
              ],
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
                      isFollowing ||
                              FirebaseAuth.instance.currentUser!.uid ==
                                  userData['uid']
                          ? FutureBuilder(
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
                          : Container()
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

Padding listTile(Icon icon, String text, var nextPage, BuildContext context,
    bool isLogout, var userData) {
  return Padding(
    padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 5, top: 2),
    child: ListTile(
        leading: icon,
        title: Text(text),
        onTap: () {
          isLogout
              ? showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 15, right: 15, left: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                  userData['username'] + "'dan çıkış yap",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ),
                            const Divider(),
                            TextButton(
                              onPressed: () async {
                                await AuthServices().logOut();

                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return const LoginScreen();
                                  },
                                ), (route) => false);
                              },
                              child: const Text(
                                "Çıkış Yap",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            const Divider(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "İptal",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return nextPage;
                  },
                ));
        }),
  );
}
