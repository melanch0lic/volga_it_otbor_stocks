import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_stock_app/models/company.dart';
import '../providers/stock_provider.dart';

import '../widgets/stock_info.dart';

class StockDetailsPage extends StatelessWidget {
  final String symbol;

  StockDetailsPage(this.symbol);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Stock Info',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: FutureBuilder(
          future: Provider.of<StockProvider>(context).getCompanyInfo(symbol),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Company company = snapshot.data as Company;
              return StockInfo(company);
            }
            return Center(
              child: Text('No Data'),
            );
          }),
    );
  }
}
