import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StockItem {
  double price;
  final String symbol;
  double volume;
  final String description;

  StockItem({
    this.price = 0,
    this.symbol = 'No data',
    this.volume = 0,
    this.description = 'No data',
  });
}

class StockProvider with ChangeNotifier {
  final WebSocketChannel _channel;
  bool isListened = false;
  bool isFetched = false;

  StockProvider()
      : _channel = WebSocketChannel.connect(
          Uri.parse('wss://ws.finnhub.io?token=c8qe2kaad3ienapjk0kg'),
        );

  List<String> _stockNames = [
    'AAPL',
    'MSFT',
    'AMZN',
    'BINANCE:BTCUSDT',
    'IC MARKETS:1',
    'BYND'
  ];

  List<StockItem> _stocks = [
    StockItem(symbol: 'AAPL', description: 'AAPL'),
    StockItem(symbol: 'MSFT', description: 'MSFT'),
    StockItem(symbol: 'BINANCE:BTCUSDT', description: 'BINANCE:BTCUSDT'),
    StockItem(symbol: 'IC MARKETS:1', description: 'IC MARKETS:1'),
    StockItem(symbol: 'AMZN', description: 'AMZN'),
    StockItem(symbol: 'BYND', description: 'BYND')
  ];

  List<StockItem> _renderedStocks = [];

  List<String> get stockNames {
    return [..._stockNames];
  }

  List<StockItem> get stocks {
    return [..._renderedStocks];
  }

  void openWebSocket() {
    print('OPEN');
    for (int i = 0; i < _stockNames.length; i++) {
      var element = _stockNames[i];
      _channel.sink.add('{"type":"subscribe","symbol":"$element"}');
      print(element);
    }
  }

  Future<String> fetchDataFromApi() async {
    var url = Uri.parse(
        'https://finnhub.io/api/v1/stock/symbol?exchange=US&token=c8qe2kaad3ienapjk0kg');
    var jsonData = await http.get(url);
    var fetchData = jsonDecode(jsonData.body);

    for (int i = 200; i < 230; i++) {
      String stockSymbol = fetchData[i]['displaySymbol'];
      _stockNames.add(stockSymbol);
      _stocks.add(StockItem(
        symbol: stockSymbol,
        description: fetchData[i]['description'],
      ));
      if (i == 229) {
        _renderedStocks = [..._stocks];
        openWebSocket();
        listenStock();
        notifyListeners();
        print(_stockNames);
        print(_stocks);
      }
    }
    return "Success";
  }

  void closeWebSocket() {
    _channel.sink.close();
  }

  void listenStock() {
    print('LISTEN');
    if (!isListened) {
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
    List<StockItem> newStocks = [];
    if (value == null) {
      _renderedStocks = [..._stocks];
      return;
    }
    _stocks.forEach((element) {
      if (element.description.startsWith(value) ||
          element.symbol.startsWith(value)) {
        newStocks.add(element);
      }
    });
    _renderedStocks = newStocks;
    notifyListeners();
  }
}
