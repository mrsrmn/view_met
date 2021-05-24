import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'View MET',
      theme: ThemeData(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
