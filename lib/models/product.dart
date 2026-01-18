class Product {
  final int? id;
  final String name;
  final String category;
  final String image;
  final double price;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    this.description = "",
  });

  // --- POUR L'API (JSON) ---
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'] ?? json['name'], 
      category: json['category'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? "",
    );
  }

  // --- POUR LA BASE DE DONNÉES (SQL) ---
  // Cette méthode enlève le rouge sur product.toMap()
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'image': image,
      // On peut ajouter quantity si tu en as besoin pour le stock
    };
  }

  // Cette méthode enlève le rouge sur Product.fromMap()
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      category: map['category'] ?? "Inconnu",
      image: map['image'] ?? "",
    );
  }
}