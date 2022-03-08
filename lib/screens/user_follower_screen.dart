import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/color.dart';

import '../widgets/follow_card.dart';

class UserFollowersScreen extends StatelessWidget {
  final user;
  const UserFollowersScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackground,
        title: Column(
          children: [
            Text(
              user['username'],
              style: const TextStyle(color: Colors.grey),
            ),
            const Text('Takipçi')
          ],
        ),
      ),
      body: (user['followers'] as List).isEmpty
          ? const Center(
              child: Text("Takipçi yok..."),
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .where('uid', whereIn: user['followers'])
                  .get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var user = snapshot.data!.docs[index];
                      return FollowCard(user: user);
                    },
                  );
                }
                return Container();
              },
            ),
    );
  }
}
