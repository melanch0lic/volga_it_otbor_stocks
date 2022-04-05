import 'package:flutter/material.dart';

import '../models/stock.dart';

class Stock extends StatelessWidget {
  final StockItem stockItem;

  Stock(this.stockItem);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${stockItem.symbol}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${stockItem.description}',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 20,
        ),
      ),
      contentPadding: const EdgeInsets.all(10),
      trailing: stockItem.price == 0
          ? const CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${stockItem.price}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  child: Text('+${stockItem.volume}%',
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: stockItem.volume < 0
                        ? Colors.red
                        : Colors
                            .green, // настроить в зависимости от знака и процента
                  ),
                )
              ],
            ),
    );
  }
}
