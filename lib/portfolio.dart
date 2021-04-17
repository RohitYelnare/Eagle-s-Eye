import 'package:financigram/cryptodata.dart';
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
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'dart:async';
import 'dart:math' as math;

dynamic portfolioquote;
List<stockData> portfoliolist = [];
stockData tmpstock;
String portfolioquery = "";
double totalfinal = 0, totalinitial = 0, totaldiff = 0;

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
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {});
    });
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
        // drawer: Theme(
        //     data: Theme.of(context).copyWith(
        //       canvasColor: Color.fromRGBO(54, 54, 64, 1.0),
        //     ),
        //     child: CallDrawer()),
        appBar: AppBar(
          title: Text("My Portfolio",
              style: GoogleFonts.lato(
                  color: Color.fromRGBO(54, 54, 64, 1.0),
                  fontWeight: FontWeight.w600)),
          iconTheme: IconThemeData(color: Color.fromRGBO(54, 54, 64, 1.0)),
          backgroundColor: Colors.white,
        ),
        body: (portfolioquery == "")
            ? Center(
                child: Container(
                child: Column(children: [
                  Text('\n\n'),
                  Container(
                      child: Icon(
                    Icons.block,
                    color: Colors.white,
                  )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(60, 10.0, 60, 10.0),
                      child: Text(
                        'No stocks/crytocurrencies added to your portfolio',
                        style: GoogleFonts.lato(
                            color: Colors.white, fontSize: 18.0),
                      ))
                ]),
              ))
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
                          gradient: (totaldiff > 0)
                              ? LinearGradient(
                                  colors: [Colors.green, Colors.limeAccent])
                              : LinearGradient(
                                  colors: [Colors.red, Colors.red[200]])),
                      padding: EdgeInsets.all(5.0),
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
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                    child: Text(
                      'You invested: ' +
                          r'$' +
                          commaadder(totalinitial.toStringAsFixed(0)),
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                          color: Colors.white),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: portfoliolist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 7.0),
                            child: ExpansionTileCard(
                              paddingCurve: Curves.easeIn,
                              baseColor: Color.fromRGBO(54, 54, 64, 1.0),
                              expandedColor: Color.fromRGBO(54, 54, 64, 1.0),
                              leading: (portfoliolist[index].price >=
                                      portfoliolist[index].stockCost)
                                  ? Image.asset("assets/green_up.png",
                                      height:
                                          MediaQuery.of(context).size.height /
                                              23)
                                  : Image.asset("assets/red_down.png",
                                      height:
                                          MediaQuery.of(context).size.height /
                                              23),
                              title: Text(
                                portfoliolist[index].fullname,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              subtitle: Text(
                                (portfoliolist[index].price >=
                                        portfoliolist[index].stockCost)
                                    ? r"$+" +
                                        ((portfoliolist[index].price -
                                                    portfoliolist[index]
                                                        .stockCost) *
                                                portfoliolist[index].stockCount)
                                            .toStringAsFixed(1)
                                    : r"$" +
                                        ((portfoliolist[index].price -
                                                    portfoliolist[index]
                                                        .stockCost) *
                                                portfoliolist[index].stockCount)
                                            .toStringAsFixed(1),
                                style: TextStyle(
                                    color: (portfoliolist[index].price >=
                                            portfoliolist[index].stockCost)
                                        ? Colors.limeAccent[400]
                                        : Colors.red,
                                    fontSize: 17),
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                              children: <Widget>[
                                Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Center(
                                        child: Text(
                                      r"Capital: $ " +
                                          (portfoliolist[index].price *
                                                  portfoliolist[index]
                                                      .stockCount)
                                              .toStringAsFixed(1) +
                                          "\n\n" +
                                          r"Investment: $ " +
                                          (portfoliolist[index].stockCost *
                                                  portfoliolist[index]
                                                      .stockCount)
                                              .toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceAround,
                                  buttonHeight: 52.0,
                                  buttonMinWidth: 90.0,
                                  children: <Widget>[
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      onPressed: () async {
                                        if (portfoliolist[index].exchange !=
                                            'CRYPTO') {
                                          stockquote = null;
                                          stockinfo = null;
                                          stocknews = null;
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return SpinKitWave(
                                                  color: Colors.white,
                                                  size: 25.0);
                                            },
                                          );
                                          await _loadquote(
                                              portfoliolist[index].stockName);
                                          await _loadnews(
                                              portfoliolist[index].stockName);
                                          await _loadinfo(
                                              portfoliolist[index].stockName);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Stockdata()));
                                        } else {
                                          stockquote = null;
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return SpinKitWave(
                                                  color: Colors.white,
                                                  size: 25.0);
                                            },
                                          );
                                          await _loadquote(
                                              portfoliolist[index].stockName);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Cryptodata()));
                                        }
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.info,
                                            color: Colors.blue,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Text(
                                            'Info',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      onPressed: () async {
                                        await dbHelper.deleteStockSym(
                                            portfoliolist[index].stockName);
                                        await portfolioquerymaker();
                                        // Future.delayed(
                                        //     const Duration(milliseconds: 2000), () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        PortfolioScreen()));
                                        // });
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Icon(Icons.remove_circle,
                                              color: Colors.red),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Text(
                                            'Remove',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ));
                      }),
                )
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

  String commaadder(String input) {
    String str = rev(input);
    String tempString = "", separator = ",";
    for (int i = 0; i < str.length; i++) {
      if (i % 3 == 0 && i > 0) {
        tempString = tempString + separator;
      }
      tempString = tempString + str[i];
    }
    return rev(tempString);
  }

  String rev(str) {
    return str.split('').reversed.join('');
  }
}

Future<void> _loadportfolioquote(stockname) async {
  if (portfolioquery != null) {
    await http
        .get(
            "https://fmpcloud.io/api/v3/quote/" + portfolioquery + '?' + apikey)
        .then((result) {
      portfolioquote = json.decode(result.body);
    });
  }
  await totalcalc();
}

Future<void> totalcalc() async {
  totalfinal = 0;
  totalinitial = 0;
  portfoliolist.forEach((portfoliodata) {
    for (var i = 0; i < portfolioquote.length; i++) {
      if (portfolioquote[i]['symbol'] == portfoliodata.stockName) {
        portfoliodata.price = portfolioquote[i]['price'];
        portfoliodata.fullname = portfolioquote[i]['name'];
        portfoliodata.exchange = portfolioquote[i]['exchange'];
        totalfinal += (portfolioquote[i]['price'] * portfoliodata.stockCount);
        totalinitial += (portfoliodata.stockCost * portfoliodata.stockCount);
      }
    }
  });
  totaldiff = totalfinal - totalinitial;
  global.arrow =
      (totaldiff >= 0.0) ? "assets/green_up.png" : "assets/red_down.png";
  await dbHelper.queryAllRows();
}

Future<void> portfolioquerymaker() async {
  portfoliolist.clear();
  portfolioquery = "";
  final allRows = await dbHelper.queryAllRowsStock();
  if (allRows.length != 0) {
    allRows.forEach((row) {
      // print(row);
      tmpstock = stockData.storeAll(
          row['_id'], row['name'], row['count'], row['cost']);
      portfoliolist.add(tmpstock);
      portfolioquery += (row['name'] + ",");
    });
    portfolioquery = portfolioquery.substring(0, portfolioquery.length - 1);
    await _loadportfolioquote(portfolioquery);
  }
}

Future<void> deletestockbysym(String name) async {
  await dbHelper.deleteStockSym(name);
}

Future<int> _loadquote(stockname) async {
  await http
      .get("https://fmpcloud.io/api/v3/quote/" + stockname + '?' + apikey)
      .then((result) {
    stockquote = json.decode(result.body);
  });
  return 1;
}

Future<int> _loadnews(stockname) async {
  await http
      .get("https://fmpcloud.io/api/v3/stock_news?tickers=" +
          stockname +
          "&limit=5&" +
          apikey)
      .then((result) {
    stocknews = json.decode(result.body);
  });
  return 1;
}

Future<int> _loadinfo(stockname) async {
  await http
      .get("https://fmpcloud.io/api/v3/profile/" + stockname + "?" + apikey)
      .then((result) {
    stockinfo = json.decode(result.body);
  });
  return 1;
}
