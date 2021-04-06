import 'package:flutter/material.dart';
import 'watch.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'portfolio.dart';
import 'add.dart';
import 'database_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CallDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Financigram",
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
              Icons.remove_red_eye,
              color: Colors.white,
            ),
            title: Text(
              "Watch List",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WatchScreen()));
            },
          ),
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
                  return SpinKitWave(color: Colors.limeAccent[700], size: 25.0);
                },
              );
              new Future.delayed(new Duration(seconds: 6), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PortfolioScreen()));
              });
            },
          ),
        ],
      ),
    );
  }
}

String temp = "";
int count;
num cost;

// class EndDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: (MediaQuery.of(context).size.width / 100) * 80,
//       child: Stack(
//         children: <Widget>[
//           // background of the drawer
//           Align(
//             alignment: Alignment.topRight,
//             child: Container(
//               width: (MediaQuery.of(context).size.width / 100) * 75,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.black87, Colors.grey[800]],
//                 ),
//               ),
//             ),
//           ),

//           Positioned(
//             left: 0,
//             right: 0,
//             top: (MediaQuery.of(context).size.height / 100) * 10,
//             bottom: 0,
//             child: Container(
//               // color: Colors.red,
//               child: showchkbox
//                   ? Center(
//                       child: Container(
//                       padding: EdgeInsets.fromLTRB(0, 60.0, 0, 0),
//                       child: SpinKitWave(
//                           color: Colors.limeAccent[700], size: 25.0),
//                     ))
//                   : Column(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             child: Padding(
//                               padding: const EdgeInsets.all(18),
//                               child: ListTile(
//                                 // leading: Icon(Icons.add),
//                                 title: Text(
//                                   'Keep an eye',
//                                   textScaleFactor: 1.5,
//                                   style: GoogleFonts.lato(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 trailing: Checkbox(
//                                     checkColor: Colors.grey[700],
//                                     activeColor: Colors.limeAccent[700],
//                                     value: checkExist,
//                                     onChanged: (newValue) {
//                                       setState(() {
//                                         checkExist = newValue;
//                                         print('Set state called');
//                                       });
//                                       if (checkExist) {
//                                         _insert(stockquote[0]['symbol']);
//                                         final snackBar = SnackBar(
//                                           content: Text('Inserted value!'),
//                                           duration: Duration(seconds: 2),
//                                           action: SnackBarAction(
//                                               label: 'Dismiss',
//                                               onPressed: () {
//                                                 Scaffold.of(context)
//                                                     .hideCurrentSnackBar();
//                                               }),
//                                         );
//                                         Scaffold.of(context)
//                                             .showSnackBar(snackBar);
//                                       } else {
//                                         _delete(stockquote[0]['symbol']);
//                                         final snackBar = SnackBar(
//                                           content: Text('Deleted value!'),
//                                           duration: Duration(seconds: 2),
//                                           action: SnackBarAction(
//                                               label: 'Dismiss',
//                                               onPressed: () {
//                                                 Scaffold.of(context)
//                                                     .hideCurrentSnackBar();
//                                               }),
//                                         );
//                                         Scaffold.of(context)
//                                             .showSnackBar(snackBar);
//                                       }
//                                     }),
//                                 subtitle: Text(
//                                   'This stock will be added to watchscreen to keep a track on multiple stocks simultaneously',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 selected: true,
//                                 onTap: () {
//                                   // setState(() {
//                                   //   txt = 'List Tile pressed';
//                                   // });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           txt,
//                           textScaleFactor: 2,
//                         ),
//                         TextField(
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               icon: const Icon(Icons.person),
//                               hintText: 'Enter no. of stocks bought',
//                               labelText: 'Count',
//                             ),
//                             onChanged: (value) {
//                               temp = value;
//                               count = int.parse(temp);
//                             }),
//                         TextField(
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               icon: const Icon(Icons.person),
//                               hintText: 'Enter cost. of stocks bought',
//                               labelText: 'Cost',
//                             ),
//                             onChanged: (value) {
//                               temp = value;
//                               cost = num.parse(temp);
//                             }),
//                         ElevatedButton(
//                           // color:Colors.grey,
//                           child: Text(
//                             'insert',
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           onPressed: () {
//                             _insertStock(count, cost);
//                             final snackBar = SnackBar(
//                               content: Text('Inserted value!'),
//                               duration: Duration(seconds: 4),
//                               action: SnackBarAction(
//                                   label: 'Undo',
//                                   onPressed: () {
//                                     _deleteStock();
//                                   }),
//                             );
//                             Scaffold.of(context).showSnackBar(snackBar);
//                           },
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topRight,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 Container(
//                   width: (MediaQuery.of(context).size.width / 100) * 75,
//                   height: (MediaQuery.of(context).size.height / 100) * 10,
//                   color: Colors.transparent,
//                   alignment: Alignment.center,
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         top: (MediaQuery.of(context).size.height / 100) * 3),
//                     child: Text(
//                       'TITLE',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _insert(String name) async {
//     // row to insert
//     Map<String, dynamic> row = {
//       DatabaseHelper.columnName: name,
//       DatabaseHelper.columnAge: 1
//     };
//     final id = await dbHelper.insert(row);
//     print('inserted row id: $id, $name');
//   }

//   void _insertStock(int count, num cost) async {
//     // row to insert
//     Map<String, dynamic> row = {
//       DatabaseHelper.stockName: stockquote[0]['symbol'],
//       DatabaseHelper.stockCount: count,
//       DatabaseHelper.stockCost: cost
//     };
//     final id = await dbHelper.insertStock(row);
//     print('inserted row in table 2 id: $id');
//   }

//   void _delete(String name) async {
//     final rowsDeleted = await dbHelper.delete(name);
//     print('deleted $rowsDeleted row(s): row $name');
//   }

//   void _deleteStock() async {
//     final id = await dbHelper.queryRowCountStock();
//     final rowsDeleted = await dbHelper.deleteStockId(id);
//     print('deleted $rowsDeleted row(s): row $id');
//   }
// }
