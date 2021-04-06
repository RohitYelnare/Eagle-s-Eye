import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'stockdata.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: isNews(context));
  }
}

Widget newsCard(BuildContext context, int index) {
  return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
      child: InkWell(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                  decoration: new BoxDecoration(color: Colors.white),
                  child: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
                    title: Text(
                      "${stocknews[index]['title']}",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      "\n${stocknews[index]['publishedDate'].substring(8, 10)} ${months[int.parse(stocknews[index]['publishedDate'].substring(5, 7)) - 1]} ${stocknews[index]['publishedDate'].substring(0, 4)} | ${stocknews[index]['site']}",
                      style: GoogleFonts.lato(
                          color: Colors.black.withOpacity(0.6)),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
                child: Text(
                  "${stocknews[index]['text']}",
                  style: GoogleFonts.lato(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Image.network(stocknews[index]['image']),
            ],
          ),
        ),
        onTap: () => launchURL(stocknews[index]['url']),
      ));
}

Widget isNews(BuildContext context) {
  Widget child;
  if ((stocknews != null)) {
    child = SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView.builder(
          padding: const EdgeInsets.all(0.0),
          itemCount: stocknews.length,
          itemBuilder: newsCard,
        ),
      ),
    );
  } else {
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
  }
  return new Container(child: child);
}
