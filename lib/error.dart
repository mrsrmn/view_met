import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:view_met/splash.dart';

import 'dart:ui';


class ErrorPage extends StatefulWidget {
  @override
  _ErrorPageState createState() => _ErrorPageState();
}


class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.dangerous, size: 50, color: Colors.red),
            Text("No Internet Connection!", style: GoogleFonts.merriweatherSans(fontSize: 23, color: Colors.black)),
            Text("To use View MET, you need an internet connection.", style: GoogleFonts.merriweatherSans(fontSize: 15, color: Colors.black), textAlign: TextAlign.center),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => SplashPage())
                );
              },
              child: Text("RETRY", style: GoogleFonts.merriweatherSans(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}