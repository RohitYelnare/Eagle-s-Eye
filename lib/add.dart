import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'portfolioData.dart';
import 'main.dart';
import 'quote.dart';
import 'stockdata.dart';
import 'database_helper.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

bool checkExist;

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
    super.initState();
    findConfig();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Container(
        child: Column(
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
                      style: TextStyle(
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
                          } else {
                            _delete(stockquote[0]['symbol']);
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
            )
          ],
        ),
      ),
    );
  }

  void _insert(String name) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnAge: 0,
      DatabaseHelper.columnAge: 1
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id, $name');
  }

  void _delete(String name) async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(name);
    print('deleted $rowsDeleted row(s): row $name');
  }

  // void _checkboxValue() async {
  //   // checkExist = newValue;
  //   if (checkExist) {
  //     _insert(stockquote[0]['symbol']);
  //   } else {
  //     _delete(stockquote[0]['symbol']);
  //   }
  // }
}
