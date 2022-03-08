import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';

class LikesCard extends StatelessWidget {
  final user;
  const LikesCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4, top: 8, bottom: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ProfileScreen(uid: user['uid']);
            },
          ));
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 27,
            backgroundImage: NetworkImage(user['photoUrl']),
          ),
          title: Text(user['username']),
        ),
      ),
    );
  }
}
