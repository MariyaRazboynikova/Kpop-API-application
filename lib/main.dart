import 'package:flutter/material.dart';
import 'package:kpop_application/presentaion/pages/intro_pages.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IntroPage(),
      ),
    );
  }
}
