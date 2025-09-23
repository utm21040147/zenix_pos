class Product {
  final int? id; // El ID será nulo al crear, pero la BD lo asignará
  final String name;
  final double price;
  int stock; // Cantidad en inventario

  Product({this.id, required this.name, required this.price, this.stock = 0});

  // Método para convertir de Map a Product (cuando leemos de la BD)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      stock: map['stock'],
    );
  }

  // Método para convertir de Product a Map (cuando escribimos en la BD)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'stock': stock};
  }
}
