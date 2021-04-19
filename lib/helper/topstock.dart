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
