import 'package:flutter/material.dart';
import 'watch.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'portfolio.dart';
import 'add.dart';
import 'database_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

bool loadwatchlist = false;

class CallDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Eagle's Eye",
              style: GoogleFonts.lato(
                  color: Color.fromRGBO(54, 54, 64, 1.0),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            ),
            title: Text(
              "Watch List",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WatchScreenloading()));
              await watchquerymaker();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WatchScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bar_chart,
              color: Colors.white,
            ),
            title: Text(
              "Portfolio",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PortfolioScreenloading()));
              await portfolioquerymaker();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PortfolioScreen()));
            },
          ),
        ],
      ),
    );
  }
}

String temp = "";
int count;
num cost;
