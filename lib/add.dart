import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'portfolioData.dart';
import 'main.dart';
import 'drawer.dart';
import 'quote.dart';
import 'stockdata.dart';
import 'database_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

bool checkExist, showchkbox;

final dbHelper = DatabaseHelper.instance;
String txt = '';
Future<void> findConfig() async {
  int a = await dbHelper.getOneData(stockquote[0]['symbol']);
  print('value of a = $a');
  //initial value of checkExist is set to 0
  checkExist = (a == 0) ? false : true;
  print('value of check = $checkExist');
}

class _AddScreenState extends State<AddScreen> {
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
  }

  String temp = "";
  int count;
  num cost;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: SingleChildScrollView(
        child: Container(
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
                            // leading: Icon(Icons.add),
                            title: Text(
                              'Keep an eye',
                              textScaleFactor: 1.5,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                              ),
                            ),
                            trailing: Checkbox(
                                checkColor: Colors.grey[700],
                                activeColor: Colors.limeAccent[700],
                                value: checkExist,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkExist = newValue;
                                    print('Set state called');
                                  });
                                  if (checkExist) {
                                    _insert(stockquote[0]['symbol']);
                                    final snackBar = SnackBar(
                                      content: Text('Inserted value!'),
                                      duration: Duration(seconds: 2),
                                      action: SnackBarAction(
                                          label: 'Dismiss',
                                          onPressed: () {
                                            Scaffold.of(context)
                                                .hideCurrentSnackBar();
                                          }),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
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
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                }),
                            subtitle: Text(
                              'This stock will be added to watchscreen to keep a track on multiple stocks simultaneously',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
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
                    Text(
                      txt,
                      textScaleFactor: 2,
                    ),
                    TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter no. of stocks bought',
                          labelText: 'Count',
                        ),
                        onChanged: (value) {
                          temp = value;
                          count = int.parse(temp);
                        }),
                    TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter cost. of stocks bought',
                          labelText: 'Cost',
                        ),
                        onChanged: (value) {
                          temp = value;
                          cost = num.parse(temp);
                        }),
                    ElevatedButton(
                      // color:Colors.grey,
                      child: Text(
                        'insert',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        _insertStock(count, cost);
                        final snackBar = SnackBar(
                          content: Text('Inserted value!'),
                          duration: Duration(seconds: 4),
                          action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                _deleteStock();
                              }),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ],
                ),
        ),
      ),
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

  void _deleteStock() async {
    final id = await dbHelper.queryRowCountStock();
    final rowsDeleted = await dbHelper.deleteStockId(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
