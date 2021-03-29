import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'option.dart';
import 'stockdata.dart';
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'watch.dart';

List<Option> options = [];

void main() {
  var rng = new Random();
  var randomkey = rng.nextInt(9);
  switch (randomkey) {
    case 0:
      apikey = apikey0;
      break;
    case 1:
      apikey = apikey1;
      break;
    case 2:
      apikey = apikey2;
      break;
    case 3:
      apikey = apikey3;
      break;
    case 4:
      apikey = apikey4;
      break;
    case 5:
      apikey = apikey5;
      break;
    case 6:
      apikey = apikey6;
      break;
    case 7:
      apikey = apikey7;
      break;
    case 8:
      apikey = apikey8;
      break;
    default:
      // print('Error fetching api key\n');
      break;
  }
  // print(randomkey);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MyApp(),
  );
}

String apikey;
final String apikey0 =
    'apikey=f5a750d76ab02994a397e12781219b26'; //fmpcloud-ryelnare
final String apikey1 =
    'apikey=5e1a9467fe60feb2acc764cf1714532e'; //fmpcloud-yelnarerohit
final String apikey2 =
    'apikey=ae307e491de599cfd87b9e2f6757683a'; //fmpcloud-yelnarer
final String apikey3 =
    'apikey=45d3c392bb9aae9616b60eb3369c421f'; //fmpcloud-inst acc
final String apikey4 =
    'apikey=99b411da22838ce8a9481d74077e28b2'; //fmpcloud-jryelnare
final String apikey5 =
    'apikey=d946a45c3b6746a6a80bf63b66edccf3'; //fmpcloud-waifake
final String apikey6 =
    'apikey=df691b729757c43093652f9eaea01a78'; //fmpcloud-pnffake
final String apikey7 =
    'apikey=79b13e9258ad097b8858b500f600bfe5'; //fmpcloud-vryelnare
final String apikey8 =
    'apikey=d78f189cdcc5b45e34db4f415b7121ab'; //fmpcloud-financigram

String optionquery;
dynamic stockquote, stocknews, stockinfo;
bool loadingNasdaq = false;
bool loadingNyse = false;
bool loadingFinal = true;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.grey[700],
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/investigeekhome.jpg',
                        height: MediaQuery.of(context).size.height / 1.4,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Investigeek',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 45,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: RawMaterialButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => AutoComplete()),
                              // );
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
                                                fontSize: 20,
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
                                            AutoComplete()));
                              });
                            },
                            elevation: 3.0,
                            fillColor: Colors.limeAccent[400],
                            child: Text(
                              '\t\t Get\nStarted',
                              style: GoogleFonts.lato(
                                  fontSize: 17, color: Colors.grey[700]),
                            ),
                            padding: EdgeInsets.all(28.0),
                            shape: CircleBorder(),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, left: 25, right: 25, bottom: 7),
                        child: Text(
                            'Your one-stop app to know latest key stats and news of stocks listed on NYSE and NASDAQ',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    getNasdaqOptions();
  }

  String urlNasdaq =
      'https://fmpcloud.io/api/v3/search?query=&limit=10000&exchange=NASDAQ&' +
          apikey;
  String urlNyse =
      'https://fmpcloud.io/api/v3/search?query=&limit=10000&exchange=NYSE&' +
          apikey;
  void getNasdaqOptions() async {
    http.get(urlNasdaq).then((result) {
      options += loadOptions(result.body);
      // print('NASDAQ Options: ${options.length}');
      // setState(() {
      //   loadingNasdaq = true;
      //   loadingFinal = !(loadingNasdaq && loadingNyse);
      //   print('loadingFinal');
      //   print('loadingNasdaq');
      //   print('loadingNyse');
      //   print(loadingFinal);
      //   print(loadingNasdaq);
      //   print(loadingNyse);
      // });
    });
    http.get(urlNyse).then((result) {
      options += loadOptions(result.body);
      // print('NYSE Options: ${options.length}');
      // setState(() {
      //   loadingNyse = true;
      //   loadingFinal = !(loadingNasdaq && loadingNyse);
      // });
      // print('loadingFinal');
      // print('loadingNasdaq');
      // print('loadingNyse');
      // print(loadingFinal);
      // print(loadingNasdaq);
      // print(loadingNyse);
    });

    // print('Options: ${options.length}');
  }

  List<Option> loadOptions(String jsonString) {
    dynamic parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Option>((json) => Option.fromJson(json)).toList();
  }
}

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
            TextField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your name',
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  name = value;
                }),
            ElevatedButton(
              // color:Colors.grey,
              child: Text(
                'insert',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _insert(name);
              },
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

  void _insert(String name) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnAge: 0
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _delete(String name) async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(name);
    print('deleted $rowsDeleted row(s): row $name');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
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
