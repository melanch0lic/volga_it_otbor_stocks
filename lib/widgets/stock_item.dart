import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';

import '../models/stock.dart';

class Stock extends StatefulWidget {
  final StockItem stockItem;

  Stock(this.stockItem);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  var provider;
  @override
  void initState() {
    provider = Provider.of<StockProvider>(context, listen: false);
    provider.subStock(widget.stockItem);
    super.initState();
  }

  @override
  void dispose() {
    provider.unsubStock(widget.stockItem);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${widget.stockItem.symbol}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${widget.stockItem.description}',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 20,
        ),
      ),
      contentPadding: const EdgeInsets.all(10),
      trailing:
          widget.stockItem.price == null && widget.stockItem.lastPrice == null
              ? const CircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${widget.stockItem.lastPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: Text('+${widget.stockItem.volume}%',
                          style: const TextStyle(
                            color: Colors.white,
                          )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: widget.stockItem.volume! < 0
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
