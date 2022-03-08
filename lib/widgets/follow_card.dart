import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';

class FollowCard extends StatelessWidget {
  final user;
  const FollowCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ProfileScreen(uid: user['uid']);
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4, top: 8, bottom: 8),
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
