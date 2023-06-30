import 'package:flutter/material.dart';
import 'screens/home_page.dart';


class Home extends StatelessWidget {
  const Home({super.key});
  static const String id = 'home_Screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Chat',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.orangeAccent ,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
      ),
      home: HomePage(),

    );
  }
}



