import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/stock.dart';

class StockProvider with ChangeNotifier {
  final WebSocketChannel _channel;
  bool isListened = false; // сделать приватными
  bool isFetched = false;
  String _searchValue = '';

  StockProvider()
      : _channel = WebSocketChannel.connect(
          Uri.parse('wss://ws.finnhub.io?token=c8qe2kaad3ienapjk0kg'),
        );

  List<StockItem> _stocks = [
    StockItem(symbol: 'AAPL', description: 'AAPL'),
    StockItem(symbol: 'MSFT', description: 'MSFT'),
    StockItem(symbol: 'BINANCE:BTCUSDT', description: 'BINANCE:BTCUSDT'),
    StockItem(symbol: 'IC MARKETS:1', description: 'IC MARKETS:1'),
    StockItem(symbol: 'AMZN', description: 'AMZN'),
    StockItem(symbol: 'BYND', description: 'BYND')
  ];

  List<StockItem> _renderedStocks =
      []; // вынести функцию поиска в UI и удалить _renderedStocks

  List<StockItem> get stocks {
    return [..._renderedStocks];
  }

  String get searchValue {
    return _searchValue;
  }

  void openWebSocket() {
    print('OPEN');
    _stocks.forEach((element) {
      _channel.sink.add('{"type":"subscribe","symbol":"${element.symbol}"}');
    });
  }

  Future<String> fetchDataFromApi() async {
    var url = Uri.parse(
        'https://finnhub.io/api/v1/stock/symbol?exchange=US&token=c8qe2kaad3ienapjk0kg');
    var jsonData = await http.get(url);
    var fetchData = jsonDecode(jsonData.body);

    for (int i = 200; i < 230; i++) {
      String stockSymbol = fetchData[i]['displaySymbol'];
      _stocks.add(StockItem(
        symbol: stockSymbol,
        description: fetchData[i]['description'],
      ));
    }
    _renderedStocks = [..._stocks];
    openWebSocket();
    listenStock();
    notifyListeners();
    return "Success";
  }

  void closeWebSocket() {
    _channel.sink.close();
  }

  void listenStock() {
    print('LISTEN');
    if (!isListened) {
      // перенести проверку в fetchDataFromApi
      isListened = true;
      _channel.stream.listen((data) {
        _stocks
            .firstWhere((el) => el.symbol == jsonDecode(data)['data'][0]['s'])
            .price = jsonDecode(data)['data'][0]['p'];
        _stocks
            .firstWhere((el) => el.symbol == jsonDecode(data)['data'][0]['s'])
            .volume = jsonDecode(data)['data'][0]['v'];
        notifyListeners();
        // print(data);
        // print(jsonDecode(data)['data'][0]['p']);
      });
    }
  }

  void searchHandler(String value) {
    _searchValue = value.toUpperCase();
    notifyListeners();
  }
}
