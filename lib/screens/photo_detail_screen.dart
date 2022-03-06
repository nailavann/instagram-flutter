import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/color.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

class PhotoDetailScreen extends StatefulWidget {
  final post;
  const PhotoDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackground,
        title: Column(
          children: [
            Text(
              widget.post['username'],
              style: const TextStyle(color: Colors.grey, fontSize: 17),
            ),
            const Text("Gönderiler")
          ],
        ),
      ),
      body: PostCard(post: widget.post),
    );
  }
}
