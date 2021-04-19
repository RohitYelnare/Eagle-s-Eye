import 'package:financigram/screens/toppage.dart';
import 'package:flutter/material.dart';
import '../screens/watch.dart';
import '../main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/portfolio.dart';
import '../helper/add.dart';
import '../database_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

bool loadwatchlist = false;

class CallDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Eagle's\nEye",
              style: GoogleFonts.lato(
                  color: Color.fromRGBO(54, 54, 64, 1.0),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight)),
          ),
          ListTile(
            leading: Icon(
              Icons.local_fire_department,
              color: Colors.orange[600],
            ),
            title: Text(
              "Top Active",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
            onTap: () async {
              topquote = null;
              topoption = "Actives";
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SpinKitWave(color: Colors.white, size: 25.0);
                },
              );
              await loadtopactive("actives");
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TopScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.north_east,
              color: Colors.limeAccent[400],
            ),
            title: Text(
              "Top Gainers",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
            onTap: () async {
              topquote = null;
              topoption = "Gainers";
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SpinKitWave(color: Colors.white, size: 25.0);
                },
              );
              await loadtopactive("gainers");
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TopScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.south_east,
              color: Colors.red[400],
            ),
            title: Text(
              "Top Losers",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
            onTap: () async {
              topquote = null;
              topoption = "Losers";
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SpinKitWave(color: Colors.white, size: 25.0);
                },
              );
              await loadtopactive("losers");
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TopScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.remove_red_eye,
              color: Colors.blue[300],
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
              color: Colors.limeAccent[400],
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
