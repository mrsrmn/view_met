import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Text("h")
        ],
      ),
    );
  }
}
