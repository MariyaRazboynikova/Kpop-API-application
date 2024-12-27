import 'package:flutter/material.dart';
import 'package:kpop_application/core/themes/themes_provider.dart';
import 'package:kpop_application/features/presentaion/pages/groups_page.dart';
import 'package:kpop_application/features/presentaion/pages/idols_page.dart';
import 'package:kpop_application/features/presentaion/pages/intro_page.dart';
import 'package:kpop_application/features/presentaion/pages/members_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemesProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemesProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: IntroPage()),
      routes: {
        '/intro_page': (context) => const IntroPage(),
        '/groups_page': (context) => const GroupsPage(),
        '/members_pages.dart': (context) => MembersPage(group: null),
        '/idols_page': (context) => IdolsPage(),
      },
    );
  }
}
