import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/screens/home_screen.dart';
import 'package:instagram_flutter/services/auth.dart';

import '../../widgets/text_field_input.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void userLogin() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthServices()
        .loginUser(_emailController.text, _passwordController.text, context);

    if (res == "success") {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const HomeScreen();
        },
      ));
    }

    setState(() {
      _isLoading = false;
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
              SvgPicture.asset(
                "assets/img/Instagram_logo.svg",
                height: 64,
                color: Colors.white,
              ),
              const SizedBox(
                height: 50,
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
                  onPressed: userLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 32,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text("Log in"),
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
                            return const SignUpScreen();
                          },
                        ));
                      },
                      child: const Text(
                        "Sign up.",
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
