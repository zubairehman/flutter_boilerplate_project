import 'package:boilerplate/models/stock/stock.dart';

class StocksList {
  final List<Stock> stocks;

  StocksList({
    this.stocks,
  });

  factory StocksList.fromJson(List<dynamic> json) {
    List<Stock> stocks = List<Stock>();
    stocks = json.map((stock) => Stock.fromMap(stock)).toList();

    return StocksList(
      stocks: stocks,
    );
  }
}
