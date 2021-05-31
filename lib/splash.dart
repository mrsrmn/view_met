import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'error.dart';
import 'home.dart';

import 'dart:async';
import 'dart:ui';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}


class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("favorites");

    if (list == null) {
      prefs.setStringList("favorites", []);
    }

    var result = await Connectivity().checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => HomePage())
        );
        break;
      case ConnectivityResult.mobile:
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => HomePage())
        );
        break;
      case ConnectivityResult.none:
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => ErrorPage())
        );
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Loading View MET", style: GoogleFonts.merriweather(fontSize: 18, color: Colors.black)),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}