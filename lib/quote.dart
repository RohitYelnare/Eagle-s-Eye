import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'stockdata.dart';
import 'global.dart' as global;
import 'package:recase/recase.dart';

class QuoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: isQuote(context));
  }
}

Widget industryTile(BuildContext context) {
  Widget child;
  if ((stockinfo[0]['sector'] != "")) {
    child = ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 30,
          minHeight: 30,
          maxWidth: 50,
          maxHeight: 50,
        ),
        child: Icon(
          Icons.business_outlined,
          color: Colors.white,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(35.0, 5.0, 15.0, 0.0),
      title: Text(
        "${stockinfo[0]['industry']}",
        style: GoogleFonts.lato(
            fontWeight: FontWeight.w400, fontSize: 18.0, color: Colors.white),
      ),
    );
  } else {
    child = Container();
  }
  return new Container(child: child);
}

Widget employeesTile(BuildContext context) {
  Widget child;
  if ((stockinfo[0]['fullTimeEmployees'] != null)) {
    child = ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 30,
          minHeight: 30,
          maxWidth: 50,
          maxHeight: 50,
        ),
        child: Icon(
          Icons.people,
          color: Colors.white,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(35.0, 5.0, 15.0, 0.0),
      title: Text(
        "${stockinfo[0]['fullTimeEmployees']} Employees",
        style: GoogleFonts.lato(
            fontWeight: FontWeight.w400, fontSize: 18.0, color: Colors.white),
      ),
    );
  } else {
    child = Container();
  }
  return new Container(child: child);
}

Widget placeTile(BuildContext context) {
  Widget child;
  if ((stockinfo[0]['city'] != null &&
      stockinfo[0]['state'] != null &&
      stockinfo[0]['country'] != null)) {
    child = ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 30,
          minHeight: 30,
          maxWidth: 50,
          maxHeight: 50,
        ),
        child: Icon(
          Icons.location_pin,
          color: Colors.white,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(35.0, 5.0, 15.0, 0.0),
      title: Text(
        "${stockinfo[0]['city']}, ${ReCase(stockinfo[0]['state']).sentenceCase}, ${stockinfo[0]['country']}",
        style: GoogleFonts.lato(
            fontWeight: FontWeight.w400, fontSize: 18.0, color: Colors.white),
      ),
    );
  } else {
    child = Container();
  }
  return new Container(child: child);
}

Widget websiteTile(BuildContext context) {
  Widget child;
  if ((stockinfo[0]['website'] != "")) {
    child = ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 30,
          minHeight: 30,
          maxWidth: 50,
          maxHeight: 50,
        ),
        child: Icon(
          Icons.insert_link,
          color: Colors.white,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(35.0, 5.0, 15.0, 0.0),
      title: Text(
        "Website",
        style: GoogleFonts.lato(
            fontWeight: FontWeight.w400, fontSize: 18.0, color: Colors.white),
      ),
      onTap: () => launchURL(stockinfo[0]['website']),
    );
  } else {
    child = Container();
  }
  return new Container(child: child);
}

Widget isQuote(BuildContext context) {
  Widget child;
  if (stockinfo == null || stockquote == null) {
    child = Center(
        child: Container(
            child: Column(children: [
      Text('\n\n'),
      Container(
          child: Icon(
        Icons.block,
        color: Colors.white,
      )),
      Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
          child: Text(
            'ERROR: Unable to reach server. Reload the app with an active internet connection.',
            style: GoogleFonts.lato(color: Colors.white, fontSize: 18.0),
          ))
    ])));
  } else {
    child = SingleChildScrollView(
        child: Column(
      children: [
        Container(
          child: ListTile(
            leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 30,
                  minHeight: 30,
                  maxWidth: 50,
                  maxHeight: 50,
                ),
                child: Image.network(stockinfo[0]['image'])),
            contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
            title: Text(
              "${stockinfo[0]['companyName']}",
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            subtitle: Text(
              "${stockinfo[0]['exchangeShortName']}: ${stockinfo[0]['symbol']}",
              style: GoogleFonts.lato(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          child: ListTile(
            leading: Image.asset(
              global.arrow,
              fit: BoxFit.cover,
              width: 25,
              height: 25,
            ),
            contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
            title: Text(
              "Price: \$${stockquote[0]['price']}",
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  color: (stockquote[0]['change'] >= 0)
                      ? Colors.limeAccent[400]
                      : Colors.deepOrangeAccent[400]),
            ),
            trailing: Text(
              '${(stockquote[0]['change'] >= 0.0) ? '+' : '-'}\$${stockquote[0]['change'].abs().toStringAsFixed(2)}\n\t${stockquote[0]['changesPercentage'].toStringAsFixed(2)}%',
              style: GoogleFonts.lato(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: (stockquote[0]['change'] >= 0.0)
                      ? Colors.limeAccent[400]
                      : Colors.deepOrangeAccent[400]),
            ),
          ),
        ),
        Container(
          child: FittedBox(
              child: DataTable(
            dataRowHeight: 70,
            showBottomBorder: false,
            columnSpacing: 25,
            columns: [
              DataColumn(
                  label: Expanded(
                child: Text('Open',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              )),
              DataColumn(
                  label: Expanded(
                child: Text('Prev Close',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              )),
              DataColumn(
                  label: Expanded(
                child: Text('High',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              )),
              DataColumn(
                  label: Expanded(
                child: Text('Low',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              )),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: Text(stockquote[0]['open'].toStringAsFixed(2),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.white)),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: Text(
                        stockquote[0]['previousClose'].toStringAsFixed(2),
                        style:
                            GoogleFonts.lato(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.center),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: Text(stockquote[0]['dayHigh'].toStringAsFixed(2),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.white)),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: Text(stockquote[0]['dayLow'].toStringAsFixed(2),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.white)),
                  )),
                ],
              ),
            ],
          )),
        ),
        Container(
          child: FittedBox(
              child: DataTable(
            dataRowHeight: 70,
            showBottomBorder: false,
            columnSpacing: 15,
            columns: [
              DataColumn(
                  label: Expanded(
                child: Text('Year High',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              )),
              DataColumn(
                  label: Expanded(
                child: Text('Year Low',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              )),
              DataColumn(
                  label: Expanded(
                child: Text('Mkt Cap',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              )),
              DataColumn(
                  label: Expanded(
                child: Text('P/E',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              )),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: Text(stockquote[0]['yearHigh'].toStringAsFixed(2),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.white)),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: Text(stockquote[0]['yearLow'].toStringAsFixed(2),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.white)),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: Text(
                        (stockquote[0]['marketCap'] != null)
                            ? (stockquote[0]['marketCap'] > 1000000000)
                                ? (stockquote[0]['marketCap'] > 1000000000000)
                                    ? "\$${(stockquote[0]['marketCap'] / 1000000000000).toStringAsFixed(3)}T"
                                    : "\$${(stockquote[0]['marketCap'] / 1000000000).toStringAsFixed(2)}B"
                                : "\$${(stockquote[0]['marketCap'] / 1000000).toStringAsFixed(2)}M"
                            : "-",
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.white)),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: Text(
                        (stockquote[0]['pe'] != null)
                            ? stockquote[0]['pe'].toStringAsFixed(2)
                            : "-",
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.white)),
                  )),
                ],
              ),
            ],
          )),
        ),
        Container(child: industryTile(context)),
        Container(child: employeesTile(context)),
        Container(child: placeTile(context)),
        Container(child: websiteTile(context)),
        Container(
            child: ExpansionTile(
          leading: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 30,
              minHeight: 30,
              maxWidth: 50,
              maxHeight: 50,
            ),
            child: Icon(
              Icons.description,
              color: Colors.white,
            ),
          ),
          title: Text(
            "About",
            style: GoogleFonts.lato(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              subtitle: Text(
                "\t\t\t\t\t\t\t${stockinfo[0]['description']}",
                textAlign: TextAlign.justify,
                style: GoogleFonts.lato(color: Colors.white, fontSize: 15.0),
              ),
            )
          ],
        )),
      ],
    ));
  }
  return new Container(child: child);
}
