import 'package:flutter/material.dart';
import 'package:log_in/screens/login.dart';
import 'package:log_in/screens/signup_screen.dart';

class LoginAndRegister extends StatefulWidget {
  const LoginAndRegister({super.key});

  @override
  State<LoginAndRegister> createState() {
    return _LoginAndRegisterState();
  }
}

class _LoginAndRegisterState extends State<LoginAndRegister> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePages,
      );
    } else {
      return SignupScreen(
        onTap: togglePages,
      );
    }
  }
}
