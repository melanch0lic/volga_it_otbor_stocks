import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stock_provider.dart';
import '../widgets/stock_item.dart';

class StockList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    final stockList = provider.stocks
        .where((element) =>
            element.description!.startsWith(provider.searchValue) ||
            element.symbol!.startsWith(provider.searchValue))
        .toList();
    return ListView.separated(
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (ctx, i) {
          return Stock(stockList[i]);
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
        itemCount: stockList.length);
  }
}
