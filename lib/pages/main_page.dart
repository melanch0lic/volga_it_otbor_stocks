import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_stock_app/providers/stock_provider.dart';
import 'package:test_stock_app/widgets/stock_list.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    if (!stockProvider.isFetched) {
      stockProvider.fetchDataFromApi();
      // stockProvider.listenStock();
      stockProvider.isFetched = true;
    }
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text('Stocks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Text(
                DateFormat.yMMMMEEEEd().format(DateTime.now()),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        stockProvider.searchHandler(value);
                      },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          hintText: "Search",
                          prefix: const Icon(
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
              SizedBox(
                  height: MediaQuery.of(context).size.height - 210,
                  child: StockList()),
            ],
          ),
        ));
  }
}
