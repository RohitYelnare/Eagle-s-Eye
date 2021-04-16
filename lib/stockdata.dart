import 'package:flutter/material.dart';
import 'main.dart';
import 'global.dart' as global;
import 'package:url_launcher/url_launcher.dart';
import 'news.dart';
import 'drawer.dart';
import 'quote.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'add.dart';
import 'database_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_switch/flutter_switch.dart';

var months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "June",
  "July",
  "Aug",
  "Sept",
  "Oct",
  "Nov",
  "Dec"
];
double icondiff;
bool icondisplay = true;
bool loadImage = false;
bool checkExist, showchkbox;

String txt = '';
Future<void> findConfig() async {
  int a = await dbHelper.getOneData(stockquote[0]['symbol']);
  print('value of a = $a');
  //initial value of checkExist is set to 0
  checkExist = (a == 0) ? false : true;
  print('value of check = $checkExist');
  showchkbox = false;
}

class Stockdata extends StatefulWidget {
  @override
  _StockdataState createState() => _StockdataState();
}

class _StockdataState extends State<Stockdata> {
  final _costtextfield = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String tmpcount = "", tmpcost = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          endDrawer: Container(
            width: (MediaQuery.of(context).size.width / 100) * 80,
            child: Stack(
              children: <Widget>[
                // background of the drawer
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 100) * 75,
                    // color: Colors.limeAccent[700],
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  top: (MediaQuery.of(context).size.height / 100) * 10,
                  bottom: 0,
                  child: Container(
                    child: showchkbox
                        ? Center(
                            child: Container(
                            padding: EdgeInsets.fromLTRB(0, 60.0, 0, 0),
                            child: SpinKitWave(
                                color: Color.fromRGBO(54, 54, 64, 1.0),
                                size: 25.0),
                          ))
                        : Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: ListTile(
                                      title: Text(
                                        'Add to WatchList',
                                        textScaleFactor: 1.3,
                                        style: GoogleFonts.lato(
                                          color:
                                              Color.fromRGBO(54, 54, 64, 1.0),
                                        ),
                                      ),
                                      trailing: Checkbox(
                                          checkColor: Colors.white,
                                          activeColor:
                                              Color.fromRGBO(54, 54, 64, 1.0),
                                          value: checkExist,
                                          onChanged: (newValue) {
                                            setState(() {
                                              checkExist = newValue;
                                              print('Set state called');
                                            });
                                            if (checkExist) {
                                              _insert(stockquote[0]['symbol']);
                                              // final snackBar = SnackBar(
                                              //   content:
                                              //       Text('Inserted value!'),
                                              //   duration: Duration(seconds: 2),
                                              //   action: SnackBarAction(
                                              //       label: 'Dismiss',
                                              //       onPressed: () {
                                              //         Scaffold.of(context)
                                              //             .hideCurrentSnackBar();
                                              //       }),
                                              // );
                                              // Scaffold.of(context)
                                              //     .showSnackBar(snackBar);
                                            } else {
                                              _delete(stockquote[0]['symbol']);
                                              // final snackBar = SnackBar(
                                              //   content: Text('Deleted value!'),
                                              //   duration: Duration(seconds: 2),
                                              //   action: SnackBarAction(
                                              //       label: 'Dismiss',
                                              //       onPressed: () {
                                              //         Scaffold.of(context)
                                              //             .hideCurrentSnackBar();
                                              //       }),
                                              // );
                                              // Scaffold.of(context)
                                              //     .showSnackBar(snackBar);
                                            }
                                          }),
                                      selected: true,
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                child: Text("Add to portfolio",
                                    style: GoogleFonts.lato(
                                        color: Colors.white, fontSize: 17)),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.fromLTRB(25, 15, 25, 15)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromRGBO(54, 54, 64, 1.0)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromRGBO(54, 54, 64, 1.0)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: BorderSide(color: Color.fromRGBO(54, 54, 64, 1.0))))),
                                onPressed: () async {
                                  await _asyncInputDialog(context);
                                },
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color.fromRGBO(54, 54, 64, 1.0),
          drawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color.fromRGBO(54, 54, 64,
                    1.0), //This will change the drawer background to blue.
                //other styles
              ),
              child: CallDrawer()),
          appBar: AppBar(
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
            title: Text(
              stockquote[0]['exchange'] + ": " + stockquote[0]['symbol'],
              style: GoogleFonts.lato(
                  color: Color.fromRGBO(54, 54, 64, 1.0),
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Color.fromRGBO(54, 54, 64, 1.0)),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Color.fromRGBO(54, 54, 64, 1.0),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Color.fromRGBO(54, 54, 64, 1.0)),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Stats"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("News"),
                  ),
                ),
                // Tab(
                //   child: Align(
                //     alignment: Alignment.center,
                //     child: Text("Add"),
                //   ),
                // ),
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
              QuoteScreen(),
              NewsScreen(),
              // AddScreen(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    showchkbox = true;
    super.initState();
    findConfig();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        showchkbox = false;
      });
    });
    setState(() {
      if (stockquote != null) {
        global.arrow = (stockquote[0]['change'] >= 0.0)
            ? "assets/green_up.png"
            : "assets/red_down.png";
      }
      _costtextfield.text = stockquote[0]['price'].toString();
      tmpcost = stockquote[0]['price'].toString();
    });
  }

  @override
  void dispose() {
    // other dispose methods
    _costtextfield.dispose();
    super.dispose();
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

  void _insertStock(int count, num cost) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.stockName: stockquote[0]['symbol'],
      DatabaseHelper.stockCount: count,
      DatabaseHelper.stockCost: cost
    };
    final id = await dbHelper.insertStock(row);
    print('inserted row in table 2 id: $id');
  }

  void _delete(String name) async {
    final rowsDeleted = await dbHelper.delete(name);
    print('deleted $rowsDeleted row(s): row $name');
  }

  void _deleteStock() async {
    final id = await dbHelper.queryRowCountStock();
    final rowsDeleted = await dbHelper.deleteStockId(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  Future _asyncInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text('Enter info'),
              content: new Row(
                children: [
                  new Expanded(
                      child: new TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(labelText: 'No. of shares'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter no. of shares';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      tmpcount = value;
                    },
                  )),
                  Container(
                    child: Text('\t\t'),
                    // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  ),
                  new Expanded(
                      child: new TextFormField(
                    controller: _costtextfield,
                    keyboardType: TextInputType.number,
                    decoration:
                        new InputDecoration(labelText: 'Price(' + r'$' + ')'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter cost';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      tmpcost = value;
                    },
                  ))
                ],
              ),
              actions: [
                FlatButton(
                  child: Text('Add'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      count = int.parse(tmpcount);
                      cost = num.parse(tmpcost);
                      _insertStock(count, cost);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ));
      },
    );
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
