import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'detailsArt.dart';


class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  fetchData(String id) async {
    var request = await http.get(Uri.parse("https://collectionapi.metmuseum.org/public/collection/v1/objects/$id"));

    return request.body;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    _deleteAll() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var list = prefs.getStringList("favorites");

      if (list!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Your list is empty!"),
            )
        );
      }
      else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Are you sure?"),
              content: Text("This will delete everything forever in your favorites list!"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    prefs.setStringList("favorites", []);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => this.widget)
                    );
                  },
                ),
                TextButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }
    }

    favoritesList() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getStringList("favorites");
    }

    _deleteData(String id) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var list = prefs.getStringList("favorites");

      list!.remove(id);

      prefs.setStringList("favorites", list);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => this.widget)
      );
    }

    builder() {
      return FutureBuilder(
        future: favoritesList(),
        builder: (BuildContext context, snapshot) {

          List list = snapshot.data as List;

          int count = list.length;

          if (list.isEmpty) {
            return Align(
              alignment: Alignment.center,
              child: Text("You don't have any favorites saved!", style: TextStyle(fontSize: 15, color: Colors.black)),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              String id = list[index];

              return FutureBuilder(
                future: fetchData(id.toString()),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  var data = jsonDecode(snapshot.data.toString());

                  var leading;
                  var artist;

                  try {
                    try {
                      if (data["primaryImageSmall"] == "") {
                        leading = Icon(Icons.dangerous, color: Colors.red);
                      }
                      else {
                        leading = Image.network(data["primaryImageSmall"]);
                      }
                    }
                    on TypeError {
                      leading = Icon(Icons.dangerous, color: Colors.red);
                    }

                    if (data["artistDisplayName"]== "") {
                      artist = "Unknown";
                    }
                    else {
                      artist = data["artistDisplayName"];
                    }
                  }
                  on TypeError {
                    return SizedBox.shrink();
                  }


                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          leading: leading,
                          title: Text(data["title"]),
                          subtitle: Text(
                            "by $artist",
                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DetailsPage(id: data["objectID"].toString())),
                                );
                              },
                              child: Text("Details", style: TextStyle(color: Colors.red)),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteData(id);
                              },
                              child: Text("Remove from Favorites", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Favorites"),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        actions: [
          IconButton(
            onPressed: () {
              _deleteAll();
            },
            icon: Icon(Icons.delete_forever)
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: Expanded(
                  child: builder()
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}