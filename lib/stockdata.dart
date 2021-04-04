import 'package:flutter/material.dart';
import 'main.dart';
import 'global.dart' as global;
import 'package:url_launcher/url_launcher.dart';
import 'news.dart';
import 'watch.dart';
import 'quote.dart';
import 'add.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'database_helper.dart';
import 'portfolio.dart';

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

class Stockdata extends StatefulWidget {
  @override
  _StockdataState createState() => _StockdataState();
}

class _StockdataState extends State<Stockdata> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey[700],
          drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors
                  .grey[800], //This will change the drawer background to blue.
              //other styles
            ),
            child: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      "Investigeek",
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
                      Icons.star_border_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Rate",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                    onTap: () {
                      LaunchReview.launch(
                          androidAppId: "com.rohityelnare.investigeek");
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Share",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                    onTap: () {
                      Share.share(
                          'Know latest quotes and news of stocks listed on NYSE & NASDAQ!\nhttps://play.google.com/store/apps/details?id=com.rohityelnare.investigeek');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.link,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Visit My Website",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                    onTap: () {
                      launchURL("http://rohit.yelnare.com/");
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.code_sharp,
                      color: Colors.white,
                    ),
                    title: Text(
                      "View Source Code",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                    onTap: () {
                      launchURL("https://github.com/RohitYelnare/Investigeek");
                    },
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
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.grey[700],
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.limeAccent[400]),
                                  ),
                                  Text(
                                    "\t\t\t\t\tLoading",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.limeAccent[400]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      new Future.delayed(new Duration(seconds: 4), () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    WatchScreen()));
                      });
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
                          return Dialog(
                            backgroundColor: Colors.grey[700],
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.limeAccent[400]),
                                  ),
                                  Text(
                                    "\t\t\t\t\tLoading",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.limeAccent[400]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      new Future.delayed(new Duration(seconds: 4), () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PortfolioScreen()));
                      });
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Made by Rohit Yelnare",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: Text(
              "Investigeek",
              style: GoogleFonts.lato(
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.grey[800]),
            bottom: TabBar(
              indicatorColor: Colors.grey[800],
              labelColor: Colors.grey[800],
              tabs: [
                Tab(
                    text: 'Stats',
                    icon: Icon(
                      Icons.bar_chart,
                      color: Colors.grey[800],
                    )),
                Tab(
                    text: 'News',
                    icon: Icon(
                      Icons.article,
                      color: Colors.grey[800],
                    )),
                Tab(
                    text: 'Add',
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: Colors.grey[800],
                    )),
              ],
            ),
            backgroundColor: Colors.limeAccent[700],
          ),
          body: TabBarView(
            children: [
              QuoteScreen(),
              NewsScreen(),
              AddScreen(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (stockquote != null) {
        if (stockquote[0]['change'] >= 0.0) {
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
