import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
    StockItem(symbol: 'AAPL'),
    StockItem(symbol: 'MSFT'),
    StockItem(symbol: 'BINANCE:BTCUSDT'),
    StockItem(symbol: 'IC MARKETS:1'),
    StockItem(symbol: 'DIS'),
    StockItem(symbol: 'AMZN'),
    StockItem(symbol: 'BYND'),
    StockItem(symbol: 'GOOGL'),
    StockItem(symbol: 'TSLA'),
    StockItem(symbol: 'FB'),
    StockItem(symbol: 'NVDA'),
    StockItem(symbol: 'NKE'),
    StockItem(symbol: 'TM'),
    StockItem(symbol: 'V'),
    StockItem(symbol: 'PEP'),
    StockItem(symbol: 'BABA'),
    StockItem(symbol: 'INTC'),
    StockItem(symbol: 'KO'),
    StockItem(symbol: 'WMT'),
    StockItem(symbol: 'MA'),
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
        notifyListeners();
      }
    } catch (err) {
      print(err);
      return 'Failure';
    }
    return 'Success';
  }

  void closeWebSocket() {
    _channel.sink.close();
  }

  void listenStock() {
    _channel.stream.listen((data) {
      final receivedData = jsonDecode(data)['data'];
      _stocks.firstWhere((el) => el.symbol == receivedData[0]['s']).lastPrice =
          receivedData[0]['p'];
      _stocks.firstWhere((el) => el.symbol == receivedData[0]['s']).volume =
          receivedData[0]['v'];
      notifyListeners();
    }, onError: (error) => print(error));
  }

  void searchHandler(String value) {
    _searchValue = value.toUpperCase();
    notifyListeners();
  }
}
