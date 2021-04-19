import 'package:flutter/material.dart';

class portData {
  int id;
  String name;
  int age;
  portData.storeAll(this.id, this.name, this.age);
  portData(this.name, this.age);

  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age};
  }
}

class stockData {
  int stockId;
  String stockName;
  String exchange;
  String fullname;
  int stockCount;
  num stockCost;
  num price;

  stockData.storeAll(
      this.stockId, this.stockName, this.stockCount, this.stockCost);
  stockData(this.stockName, this.stockCount, this.stockCost);

  Map<String, dynamic> toMap() {
    return {
      'stockName': stockName,
      'stockCount': stockCount,
      'stockCost': stockCost
    };
  }
}

class topStock {
  String ticker;
  String changesPercentage;
  String companyName;
  double changes;
  String price;

  topStock.storeAll(this.ticker, this.changes, this.price, this.companyName,
      this.changesPercentage);
  topStock(this.ticker, this.changes, this.price, this.companyName,
      this.changesPercentage);

  Map<String, dynamic> toMap() {
    return {'ticker': ticker, 'companyName': companyName, 'changes': changes};
  }
}