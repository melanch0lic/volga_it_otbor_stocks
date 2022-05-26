import 'package:flutter/material.dart';

import '../models/company.dart';

class StockInfo extends StatelessWidget {
  final Company? company;

  StockInfo(this.company);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            elevation: 0,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black45,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              width: 300,
              height: 800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Company Name: ${company!.companyName}'),
                  Text('Country: ${company!.country}'),
                  Text('Exchange: ${company!.exchange}'),
                  Text(
                      'Finnhub industry classification: ${company!.finnhubIndustry}'),
                  Text('IPO date: ${company!.ipo}'),
                  Text('Logo image: ${company!.logoLink}'),
                  Text(
                      'Market Capitalization: ${company!.marketCapitalization}'),
                  Text(
                      'Number of oustanding shares: ${company!.shareOutstanding}'),
                  Text('Company website: ${company!.webUrl}'),
                ],
              ),
            ),
          ),
        ));
  }
}
