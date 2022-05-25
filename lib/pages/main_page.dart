import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          actions: const [
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.white,
                ))
          ],
          backgroundColor: Colors.grey[800],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stocks',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                DateFormat.yMMMMEEEEd().format(DateTime.now()),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: SizedBox(
                  height: 50,
                  child: TextField(
                    onChanged: (value) {
                      stockProvider.searchHandler(value);
                    },
                    decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 16),
                        hintText: "Search",
                        prefixIcon: const Icon(
                          Icons.search,
                        ),
                        fillColor: Colors.grey[800],
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        )),
                  )),
            ),
            Expanded(
              child: StockList(),
            ),
          ],
        ));
  }
}
