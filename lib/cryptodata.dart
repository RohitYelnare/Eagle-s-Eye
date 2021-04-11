import 'package:flutter/material.dart';
import 'main.dart';
import 'global.dart' as global;
import 'package:url_launcher/url_launcher.dart';
import 'drawer.dart';
import 'crypto.dart';
import 'add.dart';
import 'database_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

class Cryptodata extends StatefulWidget {
  @override
  _CryptodataState createState() => _CryptodataState();
}

class _CryptodataState extends State<Cryptodata> {
  String temp1 = "", temp2 = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 1,
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
                    // color: Colors.red,
                    child: showchkbox
                        ? Center(
                            child: Container(
                            padding: EdgeInsets.fromLTRB(0, 60.0, 0, 0),
                            child: SpinKitWave(color: Colors.white, size: 25.0),
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
                                              final snackBar = SnackBar(
                                                content:
                                                    Text('Inserted value!'),
                                                duration: Duration(seconds: 2),
                                                action: SnackBarAction(
                                                    label: 'Dismiss',
                                                    onPressed: () {
                                                      Scaffold.of(context)
                                                          .hideCurrentSnackBar();
                                                    }),
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              _delete(stockquote[0]['symbol']);
                                              final snackBar = SnackBar(
                                                content: Text('Deleted value!'),
                                                duration: Duration(seconds: 2),
                                                action: SnackBarAction(
                                                    label: 'Dismiss',
                                                    onPressed: () {
                                                      Scaffold.of(context)
                                                          .hideCurrentSnackBar();
                                                    }),
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }),
                                      selected: true,
                                      onTap: () {
                                        // setState(() {
                                        //   txt = 'List Tile pressed';
                                        // });
                                      },
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
            title: Text(
              "Financigram",
              style: GoogleFonts.lato(
                  color: Color.fromRGBO(54, 54, 64, 1.0),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Color.fromRGBO(54, 54, 64, 1.0)),
            bottom: TabBar(
              // indicatorColor: Color.fromRGBO(54, 54, 64, 1.0),
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
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: CryptoScreen(),
          // body: TabBarView(
          //   children: [CryptoScreen()],
          // ),
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
      showchkbox = false;
      setState(() {
        showchkbox = false;
        // Here you can write your code for open new view
      });
    });
    setState(() {
      if (stockquote != null) {
        if (stockquote[0]['change'] >= 0.0) {
          global.arrow = "assets/green_up.png";
        } else {
          global.arrow = "assets/red_down.png";
        }
      }
    });
  }

  Future _asyncInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter info'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(labelText: 'No. of coins'),
                onChanged: (value) {
                  temp1 = value;
                },
              )),
              Container(
                child: Text('\t\t'),
                // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              ),
              new Expanded(
                  child: new TextField(
                keyboardType: TextInputType.number,
                decoration:
                    new InputDecoration(labelText: 'Price(' + r'$' + ')'),
                onChanged: (value) {
                  temp2 = value;
                },
              ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                count = int.parse(temp1);
                cost = num.parse(temp2);
                _insertStock(count, cost);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
