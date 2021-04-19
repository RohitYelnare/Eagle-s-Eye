import 'main.dart';
import 'database_helper.dart';

bool checkExist, showchkbox;

final dbHelper = DatabaseHelper.instance;
String txt = '';
Future<void> findConfig() async {
  int a = await dbHelper.getOneData(stockquote[0]['symbol']);
  // print('value of a = $a');
  //initial value of checkExist is set to 0
  checkExist = (a == 0) ? false : true;
  // print('value of check = $checkExist');
  showchkbox = false;
}
