import 'package:financigram/portfolio.dart';
import 'package:financigram/watch.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'option.dart';
import 'portfolio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'database_helper.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'stockdata.dart';
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoComplete extends StatefulWidget {
  AutoComplete() : super();

  final String title = "AutoComplete Demo";

  @override
  _AutoCompleteState createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  String _searchText = "";
  final myController = TextEditingController();
  // bool loadingInfo = true;
  // bool loadingQuote = true;
  // bool loadingNews = true;

  final dbHelper = DatabaseHelper.instance;
  String name = "";

  List<Option> _getSuggestions(String query) {
    List<Option> matches = [];
    if (query == "") {
      matches = [];
      return matches;
    }
    for (Option opt in options) {
      if (opt.name != null) matches.add(opt);
    }
    // matches.addAll(options);
    matches
        .retainWhere((s) => s.name.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  void initState() {
    super.initState();
    myController.addListener(() {
      setState(() {
        _searchText = myController.text;
      });
    });
    // print('loadingFinal from search page');
    // print(loadingFinal);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Widget row(Option option) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          option.name.substring(
              0, (option.name.length > 15) ? 15 : option.name.length),
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          option.symbol,
        ),
      ],
    );
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
                      new Future.delayed(new Duration(seconds: 4), () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    WatchScreen()));
                      });
                    }),
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
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            (false)
                ? Dialog(
                    backgroundColor: Colors.grey[600],
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
                                fontSize: 18, color: Colors.limeAccent[400]),
                          ),
                        ],
                      ),
                    ),
                  )
                : Form(
                    child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: <Widget>[
                        TypeAheadField(
                          noItemsFoundBuilder: (value) {
                            return Container(
                                decoration: new BoxDecoration(
                                  color: Colors.grey[800],
                                ),
                                child: ListTile(
                                  title: Text(
                                    'No Matches Found',
                                    style: GoogleFonts.lato(
                                        color: Colors.limeAccent[400],
                                        fontSize: 18.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    'Make sure you have entered a valid company name or check your connection and reload the app',
                                    style: GoogleFonts.lato(
                                        color: Colors.limeAccent[400],
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ));
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: myController,
                              autocorrect: true,
                              maxLines: 3,
                              minLines: 1,
                              autofocus: false,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.limeAccent[400],
                                      fontSize: 18.5,
                                      fontWeight: FontWeight.w200,
                                      decoration: TextDecoration.none,
                                      decorationStyle:
                                          TextDecorationStyle.dotted),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter company here',
                                suffixIcon: _searchText.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.limeAccent[400],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            myController.clear();
                                          });
                                        },
                                      )
                                    : null,
                                hintStyle: GoogleFonts.lato(
                                    fontSize: 18.5,
                                    color: Colors.limeAccent[400]),
                              )),
                          suggestionsCallback: (pattern) async {
                            return _getSuggestions(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return Container(
                                decoration: new BoxDecoration(
                                  color: Colors.grey[800],
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${suggestion.name}',
                                    style: GoogleFonts.lato(
                                        color: Colors.limeAccent[400],
                                        fontSize: 18.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    '${suggestion.exchangeShortName}: ${suggestion.symbol}',
                                    style: GoogleFonts.lato(
                                        color: Colors.limeAccent[400],
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ));
                          },
                          onSuggestionSelected: (suggestion) {
                            stockquote = null;
                            stockinfo = null;
                            stocknews = null;
                            myController.text = suggestion.name;
                            _loadquote(suggestion.symbol);
                            _loadnews(suggestion.symbol);
                            _loadinfo(suggestion.symbol);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
                            new Future.delayed(new Duration(seconds: 5), () {
                              myController.text = "";
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Stockdata()));
                            });
                          },
                        )
                      ],
                    ),
                  )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              child: Container(
                child: Text(
                  "Search for latest quotes and news of stocks listed on NYSE and NASDAQ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      color: Colors.limeAccent[400],
                      fontWeight: FontWeight.w700,
                      fontSize: 21.0),
                ),
              ),
            ),
            ElevatedButton(
              // color:Colors.green;
              child: Text(
                'query',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _query();
              },
            ),
            ElevatedButton(
              // color:Colors.green;
              child: Text(
                'queryStock',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _queryStock();
              },
            ),
            ElevatedButton(
              child: Text(
                'delete',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _delete('AAN');
              },
            ),
          ],
        )));
  }

  void _delete(String name) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(name);
    print('deleted $rowsDeleted row(s): row $name');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _queryStock() async {
    final allRows = await dbHelper.queryAllRowsStock();
    print('query all rows stock:');
    allRows.forEach((row) => print(row));
  }

  void _loadquote(stockname) {
    http
        .get("https://fmpcloud.io/api/v3/quote/" + stockname + '?' + apikey)
        .then((result) {
      stockquote = json.decode(result.body);
      // setState(() {
      //   loadingQuote = false;
      // });
      // print(stockquote);
    });
  }

  void _loadnews(stockname) {
    http
        .get("https://fmpcloud.io/api/v3/stock_news?tickers=" +
            stockname +
            "&limit=5&" +
            apikey)
        .then((result) {
      // setState(() {
      //   loadingNews = false;
      // });
      stocknews = json.decode(result.body);
      // print(stocknews);
    });
  }

  void _loadinfo(stockname) {
    http
        .get("https://fmpcloud.io/api/v3/profile/" + stockname + "?" + apikey)
        .then((result) {
      stockinfo = json.decode(result.body);
      // (stockinfo[0]['website'] == "") ? print('yes') : print('no');
      // setState(() {
      //   loadingNews = false;
      // });
    });
  }
}
