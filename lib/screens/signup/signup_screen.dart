import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/screens/login/login_screen.dart';

import '../../services/auth.dart';
import '../../utils/utils.dart';
import '../../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? _profilImage;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _profilImage = image;
    });
  }

  void signUp() async {
    if (_profilImage != null &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      if (_passwordController.text.length >= 6) {
        setState(() {
          isLoading = true;
        });
        String res = await AuthServices().signUpUser(
            _emailController.text,
            _passwordController.text,
            _usernameController.text,
            _profilImage!,
            context);

        if (res == "success") {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ));
        }
      } else {
        showSnackBar("Parola 6 haneden az olamaz!", context);
      }
    } else {
      showSnackBar("Lütfen boş yerleri doldurunuz! ", context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(
                children: [
                  _profilImage != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_profilImage!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              AssetImage("assets/img/defaultavatar.png"),
                        ),
                  Positioned(
                      bottom: -5,
                      right: -10,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ))),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Enter your username",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  obscureText: true),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signUp,
                  child: isLoading
                      ? const SizedBox(
                          height: 32,
                          child: CircularProgressIndicator(color: Colors.white))
                      : const Text(
                          "Sign in",
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont' have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ));
                      },
                      child: const Text(
                        "Login.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ))
                ],
              )
            ]),
          ),
        ),
      ),
    ));
  }
}
