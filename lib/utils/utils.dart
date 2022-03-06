import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  try {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? file = await _imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      debugPrint("no image selected");
    }
  } catch (err) {
    print(err.toString());
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
