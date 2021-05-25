import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0, 150, 0, 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'View MET',
                    style: GoogleFonts.playfairDisplaySc(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
            ),
            Text("Made with Flutter by MakufonSkifto", style: GoogleFonts.merriweather(fontSize: 18, color: Colors.black)),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("View MET has no connections with\n The Metropolitan Museum of Art itself whatsoever.", textAlign: TextAlign.center,style: GoogleFonts.merriweather(fontSize: 15, color: Colors.black)),
                )
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.merriweather(fontSize: 15, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Special thanks to ",
                        ),
                        TextSpan(
                          text: "metmuseum",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launch("https://metmuseum.github.io/", forceSafariVC: false);
                            },
                          style: TextStyle(
                              fontSize: 17, fontFamily: "Ubuntu", color: Colors.blue
                          ),
                        ),
                        TextSpan(
                          text: " for providing all the information used in View MET",
                        ),
                      ],
                    ),
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 70, 0, 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Version 1.0.0", textAlign: TextAlign.center,style: GoogleFonts.merriweather(fontSize: 15, color: Colors.black)),
                )
            ),
          ],
        ),
      ),
    );
  }
}