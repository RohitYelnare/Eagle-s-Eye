class Option {
  String symbol;
  String name;
  String exchangeShortName;

  Option({this.symbol, this.name, this.exchangeShortName});

  factory Option.fromJson(Map<String, dynamic> parsedJson) {
    return Option(
      symbol: parsedJson["symbol"] as String,
      name: parsedJson["name"] as String,
      exchangeShortName: parsedJson["exchangeShortName"] as String,
    );
  }
}
