import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/services/firestore.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late TextEditingController _descriptionController;
  Uint8List? _addedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  postUpload(UserModel user) async {
    if (_addedImage != null && _descriptionController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      String res = await FirestoreServices().uploadPost(
          _descriptionController.text,
          _addedImage!,
          user.uid,
          user.username,
          user.photoUrl);

      if (res == 'success') {
        showSnackBar("Fotoğraf yüklendi!", context);
        _descriptionController.clear();
        _addedImage = null;
      } else {}
    } else {
      showSnackBar("Gerekli yerleri doldurunuz", context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 30),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoUrl),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Açıklama giriniz..."),
                    maxLines: 6,
                  ),
                ),
              ),
              _addedImage == null
                  ? Container()
                  : Expanded(
                      child: Image(image: MemoryImage(_addedImage!)),
                    )
            ],
          ),
          //image button
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      var img = await pickImage(ImageSource.gallery);
                      setState(() {
                        _addedImage = img;
                      });
                    },
                    icon: const Icon(Icons.photo)),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () async {
                      var img = await pickImage(ImageSource.camera);
                      setState(() {
                        _addedImage = img;
                      });
                    },
                    icon: const Icon(Icons.camera_alt))
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          //share button
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    postUpload(user);
                  },
                  child: _isLoading == false
                      ? const Text("Paylaş")
                      : const Center(child: CircularProgressIndicator())))
        ],
      ),
    );
  }
}
