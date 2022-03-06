import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/home_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/services/firestore.dart';
import 'package:instagram_flutter/utils/color.dart';

class EditProfileScreen extends StatefulWidget {
  final userData;
  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _internetController;
  late final TextEditingController _bioController;
  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController();
    _usernameController = TextEditingController();
    _internetController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _internetController.dispose();
  }

  Future editProfil() async {
    if (_bioController.text.trim().isNotEmpty ||
        _usernameController.text.trim().isNotEmpty) {
      FirestoreServices()
          .editProfile(
              widget.userData, _bioController.text, _usernameController.text)
          .whenComplete(
              () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen();
                    },
                  ), (route) => false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.3,
            ),
            preferredSize: const Size.fromHeight(0.3)),
        backgroundColor: scaffoldBackground,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "İptal",
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: const Text(
          "Profili Düzenle",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: editProfil,
              child: const Text(
                "Bitti",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.userData['photoUrl'])),
            const SizedBox(
              height: 20,
            ),
            dataRow('Kullanıcı \nadı', widget.userData['username'],
                _usernameController),
            dataRow('İnternet Sitesi', 'İnternet Sitesi', _internetController),
            dataRow('Biyografi', widget.userData['bio'] ?? 'Biyografi',
                _bioController),
          ],
        ),
      ),
    );
  }
}

Row dataRow(String field, String text, TextEditingController controller) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            field,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration:
                  InputDecoration(hintText: text, border: InputBorder.none),
            ),
            const Divider(
              color: Colors.grey,
            ),
          ],
        ),
      )
    ],
  );
}
