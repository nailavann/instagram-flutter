import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/photo_detail_screen.dart';
import 'package:instagram_flutter/utils/color.dart';

class SavesScreen extends StatefulWidget {
  final String uid;
  const SavesScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<SavesScreen> createState() => _SavesScreenState();
}

class _SavesScreenState extends State<SavesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Kaydedilenler"),
          backgroundColor: scaffoldBackground),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('saves', arrayContains: widget.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data.docs[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return PhotoDetailScreen(post: post);
                        },
                      ));
                    },
                    child: Image.network(post['postUrl']));
              },
            );
          }
          return Center(
              child: Container(
            child: Text("sa"),
          ));
        },
      ),
    );
  }
}
