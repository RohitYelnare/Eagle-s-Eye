import 'package:flutter/material.dart';
import 'watch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'portfolio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
              "Financigram",
              style: GoogleFonts.lato(
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0),
            ),
            decoration: BoxDecoration(
              color: Colors.limeAccent[700],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            ),
            title: Text(
              "Watch Screen",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
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
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SpinKitWave(color: Colors.limeAccent[700], size: 25.0);
                },
              );
              new Future.delayed(new Duration(seconds: 6), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PortfolioScreen()));
              });
            },
          ),
        ],
      ),
    );
  }
}
