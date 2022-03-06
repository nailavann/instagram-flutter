import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

  Future<void> editProfile(
      dynamic userData, String bioText, String usernameText) async {
    try {
      await _firebaseFirestore.collection('user').doc(userData['uid']).update(
        {
          'bio': bioText.isEmpty ? userData['bio'] : bioText,
          'username': usernameText.isEmpty ? userData['username'] : usernameText
        },
      );
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> likesPost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
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

  Future<void> followUsers(String userDataId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      List following = snapshot.data()!['following'];

      if (following.contains(userDataId)) {
        await _firebaseFirestore.collection('user').doc(userDataId).update({
          'followers':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });

        await _firebaseFirestore.collection('user').doc(userDataId).update({
          'following':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await _firebaseFirestore.collection('user').doc(userDataId).update({
          'followers':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
        await _firebaseFirestore.collection('user').doc(userDataId).update({
          'following':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
