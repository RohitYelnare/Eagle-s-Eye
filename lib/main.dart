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
import 'search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            backgroundColor: Color.fromRGBO(54, 54, 64, 1.0),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/financigramhome.jpg',
                        height: MediaQuery.of(context).size.height / 1.4,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Financigram',
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
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return SpinKitWave(
                                      color: Colors.white, size: 25.0);
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
                            fillColor: Colors.white,
                            child: Text(
                              '\t\t Get\nStarted',
                              style: GoogleFonts.lato(
                                  fontSize: 17,
                                  color: Color.fromRGBO(54, 54, 64, 1.0)),
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
  String urlCrypto =
      'https://fmpcloud.io/api/v3/symbol/available-cryptocurrencies?' + apikey;
  void getNasdaqOptions() async {
    http.get(urlNasdaq).then((result) {
      options += loadOptions(result.body);
    });
    http.get(urlNyse).then((result) {
      options += loadOptions(result.body);
    });
    http.get(urlCrypto).then((result) {
      options += loadOptions(result.body);
    });

    // print('Options: ${options.length}');
  }

  List<Option> loadOptions(String jsonString) {
    dynamic parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Option>((json) => Option.fromJson(json)).toList();
  }
}
