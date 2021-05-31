import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:view_met/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';
import 'all.dart';
import 'departments.dart';
import 'favorites.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  fetchData() async {
    var request = await http.get(Uri.parse("https://collectionapi.metmuseum.org/public/collection/v1/departments"));

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

  var _controller = TextEditingController();

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

  builder() {
    return FutureBuilder(
      future: fetchData(),
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

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: data["departments"].length,
          itemBuilder: (BuildContext context, int index) {
            var id = data["departments"][index]["departmentId"];
            var name = data["departments"][index]["displayName"];

            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Text(data["departments"][index]["displayName"]),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DepartmentsPage(id: id.toString(), name: name.toString())),
                          );
                        },
                        child: Text("See Department", style: TextStyle(color: Colors.red)),
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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.account_balance),
        tooltip: "All of the Items",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllPage()),
          );
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: Image.asset(
                      "assets/MET.jpg",
                      fit: BoxFit.fill,
                      color: Color.fromRGBO(117, 117, 117, 0.5),
                      colorBlendMode: BlendMode.modulate
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
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Column(
                children: <Widget>[
                  Text("Departments", style: GoogleFonts.merriweather(fontSize: 18, color: Colors.black)),
                  Scrollbar(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 438,
                      child: builder()
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
