import 'product_model.dart';

class Sale {
  final int? id;
  final double total;
  final DateTime date;
  final List<Product> items;

  Sale({
    this.id,
    required this.total,
    required this.date,
    this.items = const [],
  });
}
