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
double totalfinal, totalinitial, totaldiff;
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
    _loadquote(portfolioquery);
  }
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
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text("Financigram",
              style: GoogleFonts.lato(
                  color: Color.fromRGBO(54, 54, 64, 1.0),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600)),
          iconTheme: IconThemeData(color: Color.fromRGBO(54, 54, 64, 1.0)),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Card(
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
                gradient:
                    LinearGradient(colors: [Colors.green, Colors.limeAccent]),
              ),
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //         colors: [Colors.black, Colors.limeAccent[00]])),
              padding: EdgeInsets.all(5.0),
              // color: Color(0xFF015FFF),
              child: Column(
                children: <Widget>[
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     IconButton(
                  //       icon: Icon(
                  //         Icons.arrow_back,
                  //         color: Colors.white,
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //     Text("Savings",
                  //         style:
                  //             TextStyle(color: Colors.white, fontSize: 20.0)),
                  //     IconButton(
                  //       icon: Icon(
                  //         Icons.arrow_forward,
                  //         color: Colors.white,
                  //       ),
                  //       onPressed: () {},
                  //     )
                  //   ],
                  // ),
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
                                    color: Colors.grey[700],
                                    fontSize: 20.0)),
                            TextSpan(
                                text: r"$ " + totalfinal.toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                    fontSize: 36.0)),
                            // TextSpan(text: ' world!'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        // (portfolioquery.length != 0)
                        // ?

                        // : "no stocks added",
                      ),
                    ),
                  ),
                  SizedBox(height: 35.0),
                ],
              )),
        )));
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
  if (portfolioquery != null) {
    http
        .get(
            "https://fmpcloud.io/api/v3/quote/" + portfolioquery + '?' + apikey)
        .then((result) {
      stockquote = json.decode(result.body);
    });
    print(stockquote[0]);
  }
  // print("portfolioquery");
  // print(portfolioquery);
  // print(portfoliolist[0].stockCost);
  totalcalc();
}

void totalcalc() {
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
}
