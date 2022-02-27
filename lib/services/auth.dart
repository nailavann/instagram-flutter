import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/services/storage.dart';
import 'package:instagram_flutter/utils/utils.dart';

import '../models/user_model.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future getUserDetails() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('user')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();

    if (snap.data() != null) {
      return UserModel.fromSnap(snap);
    }
  }

  Future<String> signUpUser(String email, String password, String username,
      Uint8List file, BuildContext context) async {
    String res = "error";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        var user = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageServices()
            .uploadImageToStorage('profilePics', file, false);

        await _firebaseFirestore.collection('user').doc(user.user!.uid).set({
          "uid": user.user!.uid,
          "email": email,
          "username": username,
          "followers": [],
          "following": [],
          'photoUrl': photoUrl
        });
        res = "success";
      } else {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showSnackBar("Invalid email", context);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar("Email already in use", context);
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      String email, String password, BuildContext context) async {
    String res = "error";
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showSnackBar("Invalid email", context);
      } else if (e.code == 'user-not-found') {
        showSnackBar("User not found", context);
      } else if (e.code == 'wrong-password') {
        showSnackBar("Wrong password", context);
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future logOut() async {
    await _firebaseAuth.signOut();
  }
}
