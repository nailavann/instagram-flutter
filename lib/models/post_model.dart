import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String date;
  final String postUrl;
  final String profImage;
  final List likes;
  final List saves;
  PostModel(
      {required this.description,
      required this.uid,
      required this.username,
      required this.postId,
      required this.date,
      required this.postUrl,
      required this.profImage,
      required this.likes,
      required this.saves});

  factory PostModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      description: snapshot['description'] ?? '',
      uid: snapshot['uid'] ?? '',
      username: snapshot['username'] ?? '',
      postId: snapshot['postId'] ?? '',
      date: (snapshot['date']),
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: List.from(snapshot['likes']),
      saves: List.from(snapshot['saves']),
    );
  }
}
