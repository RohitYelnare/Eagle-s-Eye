import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../helper/add.dart';
import 'package:flutter/material.dart';
import 'cryptodata.dart';
import '../main.dart';
import 'stockdata.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:horizontal_data_table/horizontal_data_table.dart';
import '../helper/option.dart';
import '../helper/portfolioData.dart';
import '../database_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

dynamic topquote;
List<topStock> toplist = [];
String topoption;

class TopScreen extends StatefulWidget {
  TopScreen() : super();
  final String title = "TopScreen Demo";
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {});
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
        title: Text("Top " + topoption,
            style: GoogleFonts.lato(
                color: Color.fromRGBO(54, 54, 64, 1.0),
                fontWeight: FontWeight.w600)),
        iconTheme: IconThemeData(color: Color.fromRGBO(54, 54, 64, 1.0)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: 29,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: Text(
                toplist[index].ticker,
                style: TextStyle(color: Colors.white),
              ),
              title: Text(
                toplist[index].companyName,
                style: TextStyle(color: Colors.white, fontSize: 17.5),
              ),
              subtitle: Text(
                toplist[index].changes.toString() +
                    " " +
                    toplist[index].changesPercentage,
                style: TextStyle(
                    color: (toplist[index].changes >= 0)
                        ? Colors.limeAccent[400]
                        : Colors.red[400]),
              ),
              trailing: Text(
                r'$' + toplist[index].price,
                style: TextStyle(color: Colors.white, fontSize: 15.5),
              ),
              onTap: () async {
                stockquote = null;
                stockinfo = null;
                stocknews = null;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return SpinKitWave(color: Colors.white, size: 25.0);
                  },
                );
                await _loadquote(toplist[index].ticker);
                await _loadnews(toplist[index].ticker);
                await _loadinfo(toplist[index].ticker);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Stockdata()));
              });
        },
      ),
    );
  }

  Future<void> _loadquote(stockname) async {
    await http
        .get("https://fmpcloud.io/api/v3/quote/" + stockname + '?' + apikey)
        .then((result) {
      stockquote = json.decode(result.body);
    });
  }

  Future<void> _loadnews(stockname) async {
    await http
        .get("https://fmpcloud.io/api/v3/stock_news?tickers=" +
            stockname +
            "&limit=5&" +
            apikey)
        .then((result) {
      stocknews = json.decode(result.body);
    });
  }

  Future<void> _loadinfo(stockname) async {
    await http
        .get("https://fmpcloud.io/api/v3/profile/" + stockname + "?" + apikey)
        .then((result) {
      stockinfo = json.decode(result.body);
    });
  }
}

Future<void> loadtopactive(String option) async {
  toplist = [];
  await http
      .get("https://fmpcloud.io/api/v3/" + option + "?" + apikey)
      .then((result) {
    topquote = json.decode(result.body);
  });
  for (var i = 0; i <= 29; i++) {
    toplist.add(topStock(
        topquote[i]['ticker'],
        topquote[i]['changes'],
        topquote[i]['price'],
        topquote[i]['companyName'],
        topquote[i]['changesPercentage']));
  }
}
