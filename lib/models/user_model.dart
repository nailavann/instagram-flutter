import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final List followers;
  final List following;
  UserModel({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.followers,
    required this.following,
  });

  factory UserModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['email'] ?? '',
      uid: snapshot['uid'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      username: snapshot['username'] ?? '',
      followers: List.from(snapshot['followers']),
      following: List.from(snapshot['following']),
    );
  }
}
