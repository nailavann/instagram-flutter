import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/login/login_screen.dart';
import 'package:instagram_flutter/services/auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text("Çıkış Yap"),
        onPressed: () async {
          await AuthServices().logOut();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ));
        },
      )),
    );
  }
}
