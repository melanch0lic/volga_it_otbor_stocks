import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_stock_app/pages/main_page.dart';
import 'package:test_stock_app/providers/stock_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StockProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stocks',
      home: MainPage(),
    );
  }
}
