import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';

import '../screens/post_screen.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';
import '../services/auth.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? file = await _imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  } else {
    debugPrint("no image selected");
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

List<Widget> homeScreenList = [
  const PostScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const ProfileScreen(),
  const SettingsScreen(),
];
