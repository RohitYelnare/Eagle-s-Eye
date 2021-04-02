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
  int stockCount;
  num stockCost;

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
