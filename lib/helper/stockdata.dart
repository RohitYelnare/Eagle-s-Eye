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
