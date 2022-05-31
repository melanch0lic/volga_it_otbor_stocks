import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stock_provider.dart';
import '../widgets/stock_list.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var stockProvider;
  @override
  void initState() {
    stockProvider = Provider.of<StockProvider>(context, listen: false);
    stockProvider.listenStock();
    stockProvider.getStocksPrice();
    super.initState();
  }

  @override
  void dispose() {
    stockProvider.closeWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(59, 64, 67, 1),
          leading: Image.asset(
            'lib/assets/elsa.png',
            width: 20,
            height: 20,
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: SizedBox(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  stockProvider.searchHandler(value);
                },
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                    hintText: "Search Stock...",
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    fillColor: Color.fromRGBO(69, 75, 77, 1),
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    )),
              ),
            ),
          ),
          actions: const [
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ))
          ],
        ),
        backgroundColor: Color.fromRGBO(12, 13, 16, 1),
        body: Column(
          children: [
            Expanded(
              child: StockList(),
            ),
          ],
        ));
  }
}
