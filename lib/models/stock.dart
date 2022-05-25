class StockItem {
  double? lastPrice;
  double? price;
  final String? symbol;
  double? volume;
  final String? description;

  StockItem({
    this.lastPrice,
    this.price,
    this.symbol,
    this.volume,
    this.description = 'No data',
  });
}
