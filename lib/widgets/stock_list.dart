import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_stock_app/providers/stock_provider.dart';

class StockList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    return ListView.separated(
        itemBuilder: (ctx, i) {
          return Stock(
            stockProvider.stocks[i].price,
            stockProvider.stocks[i].symbol,
            stockProvider.stocks[i].volume,
            stockProvider.stocks[i].description,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
        itemCount: stockProvider.stocks.length);
  }
}

class Stock extends StatelessWidget {
  double price;
  String symbol;
  double volume;
  String description;

  Stock(this.price, this.symbol, this.volume, this.description);

  @override
  Widget build(BuildContext context) {
    if (price == 0) {
      return ListTile(
        contentPadding: EdgeInsets.all(10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${symbol}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${description}',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              ),
            ),
          ],
        ),
        trailing: CircularProgressIndicator(),
      );
    }
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${symbol}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${description}',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 20,
            ),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${price}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 75,
            height: 20,
            child: Text('+${volume}%',
                style: TextStyle(
                  color: Colors.white,
                )),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
