import 'package:flutter/material.dart';
import 'main.dart';
import 'global.dart' as global;
import 'package:url_launcher/url_launcher.dart';
import 'drawer.dart';
import 'crypto.dart';
import 'add.dart';
import 'package:google_fonts/google_fonts.dart';

var months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "June",
  "July",
  "Aug",
  "Sept",
  "Oct",
  "Nov",
  "Dec"
];
double icondiff;
bool icondisplay = true;
bool loadImage = false;

class Cryptodata extends StatefulWidget {
  @override
  _CryptodataState createState() => _CryptodataState();
}

class _CryptodataState extends State<Cryptodata> {
  String temp1 = "", temp2 = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(54, 54, 64, 1.0),
          drawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color.fromRGBO(54, 54, 64,
                    1.0), //This will change the drawer background to blue.
                //other styles
              ),
              child: CallDrawer()),
          appBar: AppBar(
            title: Text(
              "Financigram",
              style: GoogleFonts.lato(
                  color: Color.fromRGBO(54, 54, 64, 1.0),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Color.fromRGBO(54, 54, 64, 1.0)),
            bottom: TabBar(
              // indicatorColor: Color.fromRGBO(54, 54, 64, 1.0),
              labelColor: Colors.white,
              unselectedLabelColor: Color.fromRGBO(54, 54, 64, 1.0),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Color.fromRGBO(54, 54, 64, 1.0)),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Stats"),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [CryptoScreen()],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    showchkbox = true;
    super.initState();
    findConfig();
    Future.delayed(const Duration(milliseconds: 2000), () {
      showchkbox = false;
      setState(() {
        showchkbox = false;
        // Here you can write your code for open new view
      });
    });
    setState(() {
      if (cryptoquote != null) {
        if (cryptoquote[0]['change'] >= 0.0) {
          global.arrow = "assets/green_up.png";
        } else {
          global.arrow = "assets/red_down.png";
        }
      }
    });
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
