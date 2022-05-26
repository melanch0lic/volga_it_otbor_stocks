import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';

import '../pages/details_page.dart';

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
    final priceChange =
        widget.stockItem.lastPrice != null && widget.stockItem.price != null
            ? ((widget.stockItem.lastPrice! - widget.stockItem.price!) /
                widget.stockItem.price! *
                100)
            : 0;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StockDetailsPage(widget.stockItem.symbol!))),
      child: ListTile(
        title: Text(
          '${widget.stockItem.symbol}',
          style: const TextStyle(
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
            widget.stockItem.price == null || widget.stockItem.lastPrice == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator()),
                      if (widget.stockItem.price != null)
                        const SizedBox(
                          height: 8,
                        ),
                      if (widget.stockItem.price != null)
                        Text(
                          'Last price : \$${widget.stockItem.price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                    ],
                  )
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
                        child: Text('${priceChange.toStringAsFixed(2)}%',
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: priceChange >= 0
                              ? priceChange > 0
                                  ? Colors.green
                                  : Colors.yellow
                              : Colors
                                  .red, // настроить в зависимости от знака и процента
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
