class StockItem {
  double? lastPrice;
  double? price;
  final String? symbol;
  final String? description;

  StockItem({
    this.lastPrice,
    this.price,
    this.symbol,
    this.description = 'No data',
  });
}
