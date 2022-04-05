import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/stock_provider.dart';
import '../widgets/stock_list.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    if (!stockProvider.isFetched) {
      stockProvider
          .fetchDataFromApi(); // вставить при инициализации конструктора StockProvider
      // stockProvider.listenStock();
      stockProvider.isFetched = true;
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
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
                DateFormat.yMMMMEEEEd()
                    .format(DateTime.now()), // поменять отображение времени
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // поменять на другой виджет
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
                          // отцентрировать Иконку
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
