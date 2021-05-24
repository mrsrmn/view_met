import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailsPage extends StatefulWidget {
  DetailsPage({required this.id});

  final String id;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  fetchData(String id) async {
    var request = await http.get(Uri.parse("https://collectionapi.metmuseum.org/public/collection/v1/objects/$id"));

    return request.body;
  }

  _writeData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("favorites");

    if (list!.contains(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("This item is already in your favorites!"),
          )
      );
    }
    else {
      list.add(id);

      prefs.setStringList("favorites", list);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added to your favorites list"),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                _deleteData(id);
              },
            ),
          )
      );
    }
  }

  _deleteData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("favorites");

    list!.remove(id);

    prefs.setStringList("favorites", list);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Removed from your favorites list"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              _writeData(id);
            },
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    builder(String id) {
      return FutureBuilder(
        future: fetchData(id),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: CircularProgressIndicator(),
            );
          }
          var data = jsonDecode(snapshot.data.toString());

          var leading;
          var artist;
          var culture;

          try {
            if (data["primaryImageSmall"] == "") {
              leading = Icon(Icons.dangerous, size: 50,);
            }
            else {
              leading = Image.network(data["primaryImageSmall"]);
            }

            if (data["artistDisplayName"]== "") {
              artist = "Unknown";
            }
            else {
              artist = data["artistDisplayName"];
            }

            if (data["culture"]== "") {
              culture = "Unknown";
            }
            else {
              culture = data["culture"];
            }
          }
          on TypeError {
            return SizedBox.shrink();
          }

          return Column(
              children: <Widget>[
                leading,
                Divider(color: Colors.black),
                Text(
                  "Title: ${data["title"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Artist: $artist",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Object ID: ${data["objectID"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Is Highlighted: ${data["isHighlight"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Accession Number: ${data["accessionNumber"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Accession Year: ${data["accessionYear"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Department: ${data["department"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Object Name: ${data["objectName"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Culture: $culture",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Dimensions: ${data["dimensions"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Credit Line: ${data["creditLine"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Date: ${data["objectDate"]}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(color: Colors.black),
                Text(
                  "Object URL: ",
                  style: TextStyle(fontSize: 20),
                ),
                RichText(
                  text: TextSpan(
                    text: "Link",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await launch(data["objectURL"], forceSafariVC: false);
                      },
                    style: TextStyle(
                        fontSize: 20, color: Colors.blue
                    ),
                  ),
                ),
                Divider(color: Colors.black),
                TextButton(
                  onPressed: () {
                    _writeData(data["objectID"].toString());
                  },
                  child: Text("Add to Favorites", style: TextStyle(color: Color(0xFF6200EE))),
                ),
              ],
            );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Details"),
      ),
      body: ListView(
        children: <Widget>[
          builder(widget.id),
        ],
      ),
    );
  }
}
