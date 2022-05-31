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
        body: Stack(
      children: [
        Container(
          color: Color.fromRGBO(9, 10, 12, 1),
        ),
        FutureBuilder(
            future: Provider.of<StockProvider>(context, listen: false)
                .getCompanyInfo(symbol),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Company company = snapshot.data as Company;
                return StockInfo(company);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                child: Text(
                  'No Data',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              );
            }),
        AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            'Stock Info',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ],
    ));
  }
}
