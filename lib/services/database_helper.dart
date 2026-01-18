import '../models/product.dart';

class DatabaseHelper {
  // Garde la même structure pour ne pas casser tes pages
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  // On simule la base de données avec une liste en mémoire
  static List<Product> _mockDatabase = [];

  // On simule l'ouverture de la DB
  Future<dynamic> get database async => null;

  // AJOUTER
  Future<int> insert(Product product) async {
    // On simule un ID auto-incrémenté
    final newProduct = Product(
      id: _mockDatabase.length + 1,
      name: product.name,
      category: product.category,
      image: product.image,
      price: product.price,
      description: product.description,
    );
    _mockDatabase.add(newProduct);
    return 1;
  }

  // RÉCUPÉRER
  Future<List<Product>> getAllProducts() async {
    return List.from(_mockDatabase);
  }

  // SUPPRIMER
  Future<int> delete(int id) async {
    _mockDatabase.removeWhere((p) => p.id == id);
    return 1;
  }
}