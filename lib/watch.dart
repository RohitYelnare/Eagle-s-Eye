import 'add.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'global.dart' as global;
import 'package:url_launcher/url_launcher.dart';
import 'stockdata.dart';
import 'news.dart';
import 'quote.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'option.dart';
import 'database_helper.dart';

List<String> watchlist = [];
String watchquery = "";
void _watchquerymaker() async {
  watchlist.clear();
  watchquery = "";
  final allRows = await dbHelper.queryAllRows();
  allRows.forEach((row) {
    watchlist.add(row['name']);
  });
  watchquery = watchlist.toSet().toList().join(',');
  loadquote();
}

class WatchScreen extends StatefulWidget {
  WatchScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  static const int sortName = 0;
  static const int sortChange = 1;
  static const int sortPrice = 1;
  bool isAscending = true;
  int sortType = sortName;

  @override
  void initState() {
    _watchquerymaker();
    super.initState();
    // stock.sortName(isAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Investigeek",
          style: TextStyle(
              color: Colors.grey[800],
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.limeAccent[700],
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: (MediaQuery.of(context).size.width) * 0.3,
        rightHandSideColumnWidth: (MediaQuery.of(context).size.width) * 0.8744,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: stock.stockinfo.length,
        rowSeparatorWidget: const Divider(
          color: Colors.white,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Colors.grey[700],
        rightHandSideColBackgroundColor: Colors.grey[700],
        enablePullToRefresh: true,
        refreshIndicator: const WaterDropHeader(),
        refreshIndicatorHeight: 69,
        onRefresh: () {
          loadquote();
          _hdtRefreshController.refreshCompleted();
        },
        htdRefreshController: _hdtRefreshController,
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      FlatButton(
        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
        child: _getTitleItemWidget(
            'Name' + (sortType == sortName ? (isAscending ? '↓' : '↑') : ''),
            (MediaQuery.of(context).size.width) * 0.3),
        onPressed: () {
          sortType = sortName;
          isAscending = !isAscending;
          stock.sortName(isAscending);
          setState(() {});
        },
      ),
      FlatButton(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: _getTitleItemWidget(
            'Change' +
                (sortType == sortChange ? (isAscending ? '↓' : '↑') : ''),
            (MediaQuery.of(context).size.width) * 0.25),
        onPressed: () {
          sortType = sortChange;
          isAscending = !isAscending;
          stock.sortChange(isAscending);
          setState(() {});
        },
      ),
      // FlatButton(
      //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      //   child: _getTitleItemWidget(
      //       'Price' + (sortType == sortChange ? (isAscending ? '↓' : '↑') : ''),
      //       (MediaQuery.of(context).size.width) * 0.20),
      //   onPressed: () {
      //     sortType = sortPrice;
      //     isAscending = !isAscending;
      //     stock.sortPrice(isAscending);
      //     setState(() {});
      //   },
      // ),
      _getTitleItemWidget('Price', (MediaQuery.of(context).size.width) * 0.20),
      _getTitleItemWidget(
          'Mkt Cap', (MediaQuery.of(context).size.width) * 0.25),
      _getTitleItemWidget('P/E', (MediaQuery.of(context).size.width) * 0.15),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      width: width,
      height: (MediaQuery.of(context).size.height) * 0.09,
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(stock.stockinfo[index].name,
          style: TextStyle(color: Colors.white)),
      width: (MediaQuery.of(context).size.width) * 0.13,
      height: 52,
      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        ColoredBox(
            color: (stock.stockinfo[index].change > 0)
                ? Colors.greenAccent[400]
                : Colors.red[400],
            child: Container(
              child: Row(
                children: <Widget>[
                  // Icon(
                  //     stock.stockinfo[index].change
                  //         ? Icons.notifications_off
                  //         : Icons.notifications_active,
                  //     color: stock.stockinfo[index].change
                  //         ? Colors.red[400]
                  //         : Colors.greenAccent[400]),
                  // Text(stock.stockinfo[index].change ? 'Disabled' : 'Active')
                  Text(stock.stockinfo[index].change.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white))
                ],
              ),
              width: (MediaQuery.of(context).size.width) * 0.25,
              height: 52,
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              alignment: Alignment.centerLeft,
            )),
        ColoredBox(
            color: (stock.stockinfo[index].change > 0)
                ? Colors.greenAccent[400]
                : Colors.red[400],
            child: Container(
              child: Text(
                stock.stockinfo[index].price.toStringAsFixed(2),
                style: TextStyle(color: Colors.white),
              ),
              width: (MediaQuery.of(context).size.width) * 0.20,
              height: 52,
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              alignment: Alignment.centerLeft,
            )),
        ColoredBox(
            color: (stock.stockinfo[index].change > 0)
                ? Colors.greenAccent[400]
                : Colors.red[400],
            child: Container(
              child: Text(
                stock.stockinfo[index].registerDate,
                style: TextStyle(color: Colors.white),
              ),
              width: (MediaQuery.of(context).size.width) * 0.25,
              height: 52,
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              alignment: Alignment.centerLeft,
            )),
        ColoredBox(
            color: (stock.stockinfo[index].change > 0)
                ? Colors.greenAccent[400]
                : Colors.red[400],
            child: Container(
              child: Text(
                stock.stockinfo[index].terminationDate,
                style: TextStyle(color: Colors.white),
              ),
              width: (MediaQuery.of(context).size.width) * 0.15,
              height: 52,
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              alignment: Alignment.centerLeft,
            )),
      ],
    );
  }
}

Stock stock = Stock();

class Stock {
  List<Stockinfo> stockinfo = [];

  void initData(int size) {
    stockinfo.clear();
    // print(','.allMatches(watchquery).length);
    for (int i = 0; i < size; i++) {
      stockinfo.add(Stockinfo(
          stockquotes[i]['name'],
          stockquotes[i]['change'],
          stockquotes[i]['price'],
          (stockquotes[i]['marketCap'] != null)
              ? (stockquotes[i]['marketCap'] > 1000000000)
                  ? (stockquotes[i]['marketCap'] > 1000000000000)
                      ? "\$${(stockquotes[i]['marketCap'] / 1000000000000).toStringAsFixed(3)}T"
                      : "\$${(stockquotes[i]['marketCap'] / 1000000000).toStringAsFixed(2)}B"
                  : "\$${(stockquotes[i]['marketCap'] / 1000000).toStringAsFixed(2)}M"
              : "-",
          (stockquotes[i]['pe'] != null)
              ? stockquotes[i]['pe'].toStringAsFixed(1)
              : '-'));
    }
  }

  ///
  /// Single sort, sort Name's id
  void sortName(bool isAscending) {
    (isAscending == false)
        ? stockinfo.sort((a, b) => a.name.compareTo(b.name))
        : stockinfo.sort((a, b) => b.name.compareTo(a.name));
  }

  void sortChange(bool isAscending) {
    (isAscending == false)
        ? stockinfo.sort((a, b) => a.change.compareTo(b.change))
        : stockinfo.sort((a, b) => b.change.compareTo(a.change));
  }

  void sortPrice(bool isAscending) {
    (isAscending == false)
        ? stockinfo.sort((a, b) => a.change.compareTo(b.change))
        : stockinfo.sort((a, b) => b.change.compareTo(a.change));
  }

  List<Option> loadOptions(String jsonString) {
    dynamic parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Option>((json) => Option.fromJson(json)).toList();
  }
}

var tmp = new Stockinfo("", 0, 0, "", "");

class Stockinfo {
  String name;
  double change;
  double price;
  String registerDate;
  String terminationDate;

  Stockinfo(this.name, this.change, this.price, this.registerDate,
      this.terminationDate);
}

dynamic stockquotes;
void loadquote() {
  http
      .get("https://fmpcloud.io/api/v3/quote/" + watchquery + '?' + apikey)
      .then((result) {
    stockquotes = json.decode(result.body);
    stock.initData(','.allMatches(watchquery).length + 1);
  });
}
