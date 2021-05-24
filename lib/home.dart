import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:view_met/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';
import 'all.dart';
import 'detailsArt.dart';
import 'favorites.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  checkEmpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("favorites");

    if (list == null) {
      prefs.setStringList("favorites", []);
    }
  }


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

    checkEmpty();

    welcomeText() {
      var now = DateTime.now();

      if (now.hour <= 11 && now.hour >= 5) {
        return Text("Good Morning", style: GoogleFonts.playfairDisplaySc(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold));
      }
      else if (now.hour <= 17 && now.hour >= 12) {
        return Text("Good Afternoon", style: GoogleFonts.playfairDisplaySc(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),);
      }
      else if (now.hour <= 21 && now.hour >= 18 && now.hour >= 19 && now.hour >= 5 || now.hour == 0) {
        return Text("Good Evening", style: GoogleFonts.playfairDisplaySc(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),);
      }
      else {
        return Text("Hello", style: GoogleFonts.playfairDisplaySc(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),);
      }
    }

    var randint1 = Random().nextInt(70000);
    var randint2 = Random().nextInt(70000);
    var randint3 = Random().nextInt(70000);
    var randint4 = Random().nextInt(70000);
    var randint5 = Random().nextInt(70000);
    var randint6 = Random().nextInt(70000);


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

          try {
            if (data["primaryImageSmall"] == "") {
              leading = Icon(Icons.dangerous, color: Colors.red);
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
                        _writeData(data["objectID"].toString());
                      },
                      child: Text("Add to Favorites", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    var _controller = TextEditingController();


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: Positioned.fill(
                    child: Image.asset(
                        "assets/MET.jpg",
                        fit: BoxFit.fill,
                        color: Color.fromRGBO(117, 117, 117, 0.5),
                        colorBlendMode: BlendMode.modulate
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.white,
                      icon: Icon(Icons.info),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
                      },
                    ),
                  )
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 40, 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FavoritesPage()),
                          );
                        },
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 50,80, 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: Icon(Icons.refresh_outlined),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => this.widget)
                          );
                        },
                      ),
                    )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 150, 0, 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'View MET',
                      style: GoogleFonts.playfairDisplaySc(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 200, 0, 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: welcomeText(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 280, 0, 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 300,
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (String value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SearchPage(text: _controller.text)
                              )
                          );
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(99),
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.black),
                            hintText: "Search View MET",
                            fillColor: Colors.white
                        ),
                      ),
                    )
                  ),
                ),
              ]
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                children: <Widget>[
                  Text("Random Items You Could Like", style: GoogleFonts.merriweather(fontSize: 18, color: Colors.black)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 443,
                    child: Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            builder(randint1.toString()),
                            builder(randint2.toString()),
                            builder(randint3.toString()),
                            builder(randint4.toString()),
                            builder(randint5.toString()),
                            builder(randint6.toString()),
                            TextButton(
                             onPressed: () {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (BuildContext context) => AllPage()
                                   )
                               );
                             },
                             child: Text("See more"),
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
