import 'package:financigram/portfolioData.dart';
import 'package:flutter/material.dart';
import 'add.dart';
import 'main.dart';
import 'stockdata.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'portfolioData.dart';
import 'drawer.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_helper.dart';
import 'watch.dart';
import 'global.dart' as global;
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math' as math;

class PortfolioScreen extends StatefulWidget {
  PortfolioScreen() : super();
  final String title = "PortfolioScreen Demo";
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final myController = TextEditingController();
  List<stockData> portfoliolist = [];
  stockData tmpstock;
  bool loadportfolio = true;
  String portfolioquery = "";
  double totalfinal, totalinitial, totaldiff;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {});
    });
    _portfolioquerymaker();
    // _queryStock();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(54, 54, 64, 1.0),
        drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Color.fromRGBO(54, 54, 64,
                  1.0), //This will change the drawer background to blue.
              //other styles
            ),
            child: CallDrawer()),
        appBar: AppBar(
          title: Text("My Portfolio",
              style: GoogleFonts.lato(
                  color: Color.fromRGBO(54, 54, 64, 1.0),
                  fontWeight: FontWeight.w600)),
          iconTheme: IconThemeData(color: Color.fromRGBO(54, 54, 64, 1.0)),
          backgroundColor: Colors.white,
        ),
        body: loadportfolio
            ? Center(
                child: Container(
                padding: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
                child: SpinKitWave(color: Colors.white, size: 25.0),
              ))
            // : (portfolioquery == "")
            //     ? Center(
            //         child: Container(
            //         child: Column(children: [
            //           Text('\n\n'),
            //           Container(
            //               child: Icon(
            //             Icons.block,
            //             color: Colors.white,
            //           )),
            //           Padding(
            //               padding:
            //                   const EdgeInsets.fromLTRB(60, 10.0, 60, 10.0),
            //               child: Text(
            //                 'No stocks/crytocurrencies added to your portfolio',
            //                 style: GoogleFonts.lato(
            //                     color: Colors.white, fontSize: 18.0),
            //               ))
            //         ]),
            //       ))
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(15.0),
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          // color: Colors.grey[700],
                          // boxShadow: [
                          //   BoxShadow(color: Colors.green, spreadRadius: 0),
                          // ],
                          gradient: (totaldiff > 0)
                              ? LinearGradient(
                                  colors: [Colors.green, Colors.limeAccent])
                              : LinearGradient(
                                  colors: [Colors.red, Colors.red[200]])),
                      // decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //         colors: [Colors.black, Colors.limeAccent[00]])),
                      padding: EdgeInsets.all(5.0),
                      // color: Color(0xFF015FFF),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "\nTotal portfolio value:\n\n",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(54, 54, 64, 1.0),
                                            fontSize: 20.0)),
                                    TextSpan(
                                        text: (totalfinal > 0)
                                            ? r"$ " +
                                                commaadder(totalfinal
                                                    .toStringAsFixed(0))
                                            : r"$- " +
                                                commaadder(totalfinal
                                                    .toStringAsFixed(0)
                                                    .substring(1)),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(54, 54, 64, 1.0),
                                            fontSize: 36.0)),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 35.0),
                        ],
                      )),
                ),
                Container(
                  child: ListTile(
                    leading: Image.asset(
                      (totaldiff >= 0.0)
                          ? "assets/green_up.png"
                          : "assets/red_down.png",
                      fit: BoxFit.cover,
                      width: 25,
                      height: 25,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                    title: Text(
                      (totaldiff >= 0.0) ? "Total gains: " : "Total losses: ",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                          color: (totaldiff >= 0)
                              ? Colors.limeAccent[400]
                              : Colors.deepOrangeAccent[400]),
                    ),
                    trailing: Text(
                      (totaldiff > 0)
                          ? r"$ " + commaadder(totaldiff.toStringAsFixed(0))
                          : r"$-" +
                              commaadder(
                                  totaldiff.toStringAsFixed(0).substring(1)),
                      style: GoogleFonts.lato(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: (totaldiff >= 0.0)
                              ? Colors.limeAccent[400]
                              : Colors.deepOrangeAccent[400]),
                    ),
                  ),
                ),
                Container(
                    child: Text(
                  'Initial value: ' +
                      r'$' +
                      commaadder(totalinitial.toStringAsFixed(0)),
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      color: Colors.white),
                ))
              ])));
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

  String commaadder(String str) {
    String tempString = "", separator = ",";
    for (int i = 0; i < str.length; i++) {
      if (i % 3 == 0 && i > 0) {
        tempString = tempString + separator;
      }
      tempString = tempString + str[i];
    }
    return tempString;
  }

  Future<void> _loadquote(stockname) async {
    if (portfolioquery != null) {
      http
          .get("https://fmpcloud.io/api/v3/quote/" +
              portfolioquery +
              '?' +
              apikey)
          .then((result) {
        stockquote = json.decode(result.body);
      });
      // print(stockquote[0]);
    }
    print("portfoliolist");
    print(portfoliolist);
    // print(portfoliolist[0].stockCost);
    totalcalc();
  }

  Future<void> totalcalc() async {
    totalfinal = 0;
    totalinitial = 0;
    portfoliolist.forEach((portfoliodata) {
      for (var i = 0; i < stockquote.length; i++) {
        if (stockquote[i]['symbol'] == portfoliodata.stockName) {
          totalfinal += (stockquote[i]['price'] * portfoliodata.stockCount);
          totalinitial += (portfoliodata.stockCost * portfoliodata.stockCount);
        }
      }
    });
    totaldiff = totalfinal - totalinitial;
    global.arrow =
        (totaldiff >= 0.0) ? "assets/green_up.png" : "assets/red_down.png";
    setState(() {
      loadportfolio = false;
    });
    await dbHelper.queryAllRows();
  }

  void _portfolioquerymaker() async {
    portfoliolist.clear();
    portfolioquery = "";
    final allRows = await dbHelper.queryAllRowsStock();
    if (allRows.length != 0) {
      allRows.forEach((row) {
        print(row);
        tmpstock = stockData.storeAll(
            row['_id'], row['name'], row['count'], row['cost']);
        portfoliolist.add(tmpstock);
        portfolioquery += (row['name'] + ",");
      });
      portfolioquery = portfolioquery.substring(0, portfolioquery.length - 1);
      await _loadquote(portfolioquery);
    }
  }
}
