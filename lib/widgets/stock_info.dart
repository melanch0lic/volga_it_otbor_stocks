import 'package:flutter/material.dart';

import '../models/company.dart';

class StockInfo extends StatelessWidget {
  final Company? company;

  StockInfo(this.company);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Center(
        child: Card(
          elevation: 1,
          color: Color.fromRGBO(59, 64, 67, 1),
          shadowColor: Colors.grey,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black45,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            width: 300,
            height: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company Name: ${company!.companyName}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Country: ${company!.country}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Exchange: ${company!.exchange}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Finnhub industry classification: ${company!.finnhubIndustry}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'IPO date: ${company!.ipo}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Logo image: ${company!.logoLink}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Market Capitalization: ${company!.marketCapitalization}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Number of oustanding shares: ${company!.shareOutstanding}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Company website: ${company!.webUrl}',
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      company!.logoLink!,
                      // errorBuilder: (context, error, stackTrace) =>
                      //     Image.network(
                      //   'https://pro2-bar-s3-cdn-cf1.myportfolio.com/595e16db507530aedc596bfea5b9b205/c4942518-4c81-4440-b5e6-a81ee775fccd_car_202x158.gif?h=7f6473aa96778a9138ad4bbdbcdf698d',
                      // ),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
