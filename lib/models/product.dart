

class Product {
  final String? id; 
  final String name;
  final int quantity;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  // Cette fonction transforme notre objet en "Map" pour que SQLite puisse l'enregistrer
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'quantity': quantity, 'price': price};
  }

  // Cette fonction fait l'inverse : elle crée un objet Product à partir des données de la base
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
