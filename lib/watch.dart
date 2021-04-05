import 'package:financigram/search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';

List<String> watchlist = [];
String watchquery = "";
bool loadingdatatable;
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
    loadingdatatable = true;
    Future.delayed(const Duration(milliseconds: 2000), () {
      loadingdatatable = false;
      setState(() {
        loadingdatatable = false;
      });
    });
    _watchquerymaker();
    super.initState();
    // stock.sortName(isAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text(
          "Financigram",
          style: TextStyle(
              color: Colors.grey[800],
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.limeAccent[700],
      ),
      body: loadingdatatable
          ? Center(
              child: Container(
              padding: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
              child: SpinKitWave(color: Colors.white, size: 25.0),
            ))
          : (watchquery == "")
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
                          'No stocks added to keep an eye on',
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 18.0),
                        ))
                  ]),
                ))
              : _getBodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AutoComplete()));
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.limeAccent[700],
      ),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: (MediaQuery.of(context).size.width) * 0.3,
        rightHandSideColumnWidth: (MediaQuery.of(context).size.width) * 1.28,
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
          _watchquerymaker();
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
          'Mkt Cap', (MediaQuery.of(context).size.width) * 0.20),
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
                stock.stockinfo[index].pe,
                style: TextStyle(color: Colors.white),
              ),
              width: (MediaQuery.of(context).size.width) * 0.15,
              height: 52,
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              alignment: Alignment.centerLeft,
            )),
        FlatButton(
          onPressed: () {
            Clipboard.setData(
                new ClipboardData(text: stock.stockinfo[index].sym));
            final snackBar = SnackBar(
              content:
                  Text(stock.stockinfo[index].sym + ' real-time quote copied'),
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    print("undo pressed");
                  }),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Icon(
            Icons.content_copy,
            color: Colors.blue,
          ),
        ),
        FlatButton(
          onPressed: () {
            String tmp = stock.stockinfo[index].sym;
            // setState(() {
            //   _watchquerymaker();
            // });
            // stock.stockinfo.remove(stock.stockinfo[index].sym);
            _delete(tmp);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => WatchScreen()));
          },
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        )
      ],
    );
  }
}

void _delete(String sym) async {
  // Assuming that the number of rows is the id for the last row.
  final rowsDeleted = await dbHelper.delete(sym);
  print('deleted $rowsDeleted row(s): row $sym');
}

void _insert(String name) async {
  // row to insert
  Map<String, dynamic> row = {
    DatabaseHelper.columnName: name,
    DatabaseHelper.columnAge: 1
  };
  final id = await dbHelper.insert(row);
  print('inserted row id: $id, $name');
}

Stock stock = Stock();

class Stock {
  List<Stockinfo> stockinfo = [];

  void initData(int size) {
    stockinfo.clear();
    // print(','.allMatches(watchquery).length);
    for (int i = 0; i < size; i++) {
      stockinfo.add(Stockinfo(
          stockquotes[i]['symbol'],
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

class Stockinfo {
  String sym;
  String name;
  double change;
  double price;
  String registerDate;
  String pe;

  Stockinfo(
      this.sym, this.name, this.change, this.price, this.registerDate, this.pe);
}

dynamic stockquotes;
void loadquote() {
  if (watchquery != "") {
    http
        .get("https://fmpcloud.io/api/v3/quote/" + watchquery + '?' + apikey)
        .then((result) {
      stockquotes = json.decode(result.body);
      stock.initData(','.allMatches(watchquery).length + 1);
    });
  }
}
