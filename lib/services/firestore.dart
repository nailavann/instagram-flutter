import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/user_model.dart';

import 'package:instagram_flutter/services/storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "error";
    try {
      String photoUrl =
          await StorageServices().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      await _firebaseFirestore.collection('posts').doc(postId).set({
        'description': description,
        'postUrl': photoUrl,
        'username': username,
        'uid': uid,
        'postId': postId,
        'date': DateTime.now(),
        'profImage': profImage,
        'likes': [],
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likesPost(String postId, String username, List likes) async {
    try {
      if (likes.contains(username)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([username])
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([username])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postComment(String text, String postId, String username,
      String uid, String profImage) async {
    try {
      String commentId = const Uuid().v1();
      _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'profImage': profImage,
        'text': text,
        'username': username,
        'commentId': commentId,
        'uid': uid,
        'date': DateTime.now()
      });
    } catch (err) {
      print(err.toString());
    }
  }
}
