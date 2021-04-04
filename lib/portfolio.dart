import 'package:financigram/portfolioData.dart';
import 'package:flutter/material.dart';
import 'add.dart';
import 'main.dart';
import 'stockdata.dart';
import 'portfolioData.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_helper.dart';
import 'watch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

List<stockData> portfoliolist = [];
stockData tmpstock;
String portfolioquery = "";
void _portfolioquerymaker() async {
  portfoliolist.clear();
  portfolioquery = "";
  final allRows = await dbHelper.queryAllRows();
  allRows.forEach((row) {
    tmpstock = stockData(row['name'], row['count'], row['cost']);
    portfoliolist.add(tmpstock);
    portfolioquery = row['name'].toSet().toList().join(',');
  });
  _loadquote(portfolioquery);
}

class PortfolioScreen extends StatefulWidget {
  PortfolioScreen() : super();
  final String title = "PortfolioScreen Demo";
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final myController = TextEditingController();

  @override
  void initState() {
    _queryStock();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      new Future.delayed(new Duration(seconds: 6), () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    WatchScreen()));
                      });
                    }),
                ListTile(
                  title: Text(
                    "Made by Rohit Yelnare",
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text("Investigeek",
              style: GoogleFonts.lato(
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600)),
          iconTheme: IconThemeData(color: Colors.grey[800]),
          backgroundColor: Colors.limeAccent[700],
        ),
        body: SingleChildScrollView());
  }

  void _delete(String name) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(name);
    print('deleted $rowsDeleted row(s): row $name');
  }

  void _queryStock() async {
    final allRows = await dbHelper.queryAllRowsStock();
    print('query all rows stock:');
    allRows.forEach((row) => print(row['name']));
  }
}

void _loadquote(stockname) {
  http
      .get("https://fmpcloud.io/api/v3/quote/" + stockname + '?' + apikey)
      .then((result) {
    stockquote = json.decode(result.body);
  });
  print(stockquote);
}
