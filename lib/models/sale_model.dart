import 'product_model.dart';

class Sale {
  final int? id;
  final List<Product> items;
  final double totalAmount;
  final DateTime timestamp;

  Sale({
    this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });
}
