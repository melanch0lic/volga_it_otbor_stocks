import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test_stock_app/models/company.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config.dart';

import '../models/stock.dart';

class StockProvider with ChangeNotifier {
  final WebSocketChannel _channel;
  String _searchValue = '';

  StockProvider()
      : _channel = WebSocketChannel.connect(
          Uri.parse('wss://ws.finnhub.io?token=${Config.token}'),
        ) {
    // fetchDataFromApi();
  }

  final List<StockItem> _stocks = [
    StockItem(symbol: 'AAPL', description: 'Apple Inc'),
    StockItem(symbol: 'MSFT', description: 'Microsoft Corp'),
    StockItem(symbol: 'BINANCE:BTCUSDT', description: 'Binance Bitcoin'),
    StockItem(symbol: 'IC MARKETS:1', description: 'IC markets'),
    StockItem(symbol: 'DIS', description: 'Walt Disney Co'),
    StockItem(symbol: 'AMZN', description: 'Amazon.com Inc'),
    StockItem(symbol: 'BYND', description: 'Beyond Meat Inc'),
    StockItem(symbol: 'GOOGL', description: 'Alphabet Inc'),
    StockItem(symbol: 'TSLA', description: 'Tesla Inc'),
    StockItem(symbol: 'FB', description: 'Meta Platforms Inc'),
    StockItem(symbol: 'NVDA', description: 'NVIDIA Corp'),
    StockItem(symbol: 'NKE', description: 'Nike Inc'),
    StockItem(symbol: 'TM', description: 'Toyota Motor Corp'),
    StockItem(symbol: 'V', description: 'Visa Inc'),
    StockItem(symbol: 'PEP', description: 'PepsiCo Inc'),
    StockItem(symbol: 'BABA', description: 'Alibaba Group Holding Ltd'),
    StockItem(symbol: 'INTC', description: 'Intel Corp'),
    StockItem(symbol: 'KO', description: 'Coca-Cola CO'),
    StockItem(symbol: 'WMT', description: 'Walmart Inc'),
    StockItem(symbol: 'MA', description: 'Mastercard Inc'),
  ];

  List<StockItem> get stocks {
    return [..._stocks];
  }

  String get searchValue {
    return _searchValue;
  }

  void subStock(StockItem element) {
    _channel.sink.add('{"type":"subscribe","symbol":"${element.symbol}"}');
  }

  void unsubStock(StockItem element) {
    _channel.sink.add('{"type":"usubscribe","symbol":"${element.symbol}"}');
  }

  Future<String> fetchDataFromApi() async {
    try {
      var url = Uri.parse(
          'https://finnhub.io/api/v1/stock/symbol?exchange=US&token=${Config.token}');
      var jsonData = await http.get(url);
      var fetchData = jsonDecode(jsonData.body);

      for (int i = 0; i < 30; i++) {
        String stockSymbol = fetchData[i]['displaySymbol'];
        _stocks.add(StockItem(
          symbol: stockSymbol,
          description: fetchData[i]['description'],
        ));
      }
    } catch (err) {
      print('Информация не получена: $err');
      return "Failure";
    }
    return "Success";
  }

  Future<String> getStock(StockItem stock) async {
    final url = Uri.parse(
        'https://finnhub.io/api/v1/quote?symbol=${stock.symbol}&token=${Config.token}');
    try {
      final response = await http.get(url);
      if (response.body != null) {
        stock.price = jsonDecode(response.body)['o'] * 1.0;
        stock.lastPrice = jsonDecode(response.body)['o'] * 1.0;
        notifyListeners();
      }
    } catch (err) {
      print(err);
      return 'Failure';
    }
    return 'Success';
  }

  Future<Company?> getCompanyInfo(String symbol) async {
    final url = Uri.parse(
        'https://finnhub.io/api/v1/stock/profile2?symbol=${symbol}&token=${Config.token}');
    try {
      final response = await http.get(url);
      if (response.body != null) {
        final jsonData = jsonDecode(response.body);
        if (jsonData.isEmpty) throw 'Error: Empty json data';
        return Company(
          country: jsonData['country'],
          currency: jsonData['currency'],
          exchange: jsonData['exchange'],
          finnhubIndustry: jsonData['finnhubIndustry'],
          ipo: jsonData['ipo'],
          logoLink: jsonData['logo'],
          marketCapitalization: jsonData['marketCapitalization'],
          companyName: jsonData['name'],
          phone: jsonData['phone'],
          shareOutstanding: jsonData['shareOutstanding'],
          symbol: jsonData['ticker'],
          webUrl: jsonData['weburl'],
        );
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  void getStocksPrice() {
    _stocks.forEach((element) {
      getStock(element);
    });
  }

  void closeWebSocket() {
    _channel.sink.close();
  }

  void listenStock() {
    _channel.stream.listen((data) {
      final receivedData = jsonDecode(data)['data'];
      _stocks.firstWhere((el) => el.symbol == receivedData[0]['s']).lastPrice =
          receivedData[0]['p'];
      notifyListeners();
    }, onError: (error) => print(error));
  }

  void searchHandler(String value) {
    _searchValue = value.toUpperCase();
    notifyListeners();
  }
}
