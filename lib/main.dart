import 'package:firebase_core/firebase_core.dart';

import 'package:log_in/widgets/auth_page.dart';

import 'firebase_options.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogIn',
      theme: ThemeData().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4460EF),
              primary: const Color(0xFF4460EF),
              onPrimary: const Color(0xFF1E1E1E),
              onSurface: const Color.fromARGB(185, 224, 219, 219),
              onPrimaryContainer: const Color.fromARGB(211, 71, 69, 69))),
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
