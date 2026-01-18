import '../models/product.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    // Simulation du délai réseau
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      Product(
        id: 1,
        name: "PANTINOX SR9 ...",
        price: 24500,
        category: "Peinture et revêtements",
        image: "assets/produits/peinture.jpeg",
      ),
      Product(
        id: 2,
        name: "Grillage 1 doigt ...",
        price: 12000,
        category: "Quincaillerie",
        image: "assets/produits/grillage.jpg",
      ),
      Product(
        id: 3,
        name: "Ciment CPJ 45 ...",
        price: 4500,
        category: "Matériaux",
        image: "assets/produits/ciment.png",
      ),
      Product(
        id: 4,
        name: "Poubelle Ville ...",
        price: 15000,
        category: "Plomberie et sanitaires",
        image: "assets/produits/poubelle.webp",
      ),
      Product(
        id: 5,
        name: "Barre de terre",
        price: 8500,
        category: "Electricité",
        image: "assets/produits/Barre-de-terre.jpg",
      ),
      Product(
        id: 6,
        name: "EMTOP Pistolet",
        price: 32000,
        category: "Outils",
        image: "assets/produits/EMTOP+Pistolet.webp",
      ),
      Product(
        id: 7,
        name: "Groupe de sécurité",
        price: 12500,
        category: "Plomberie et sanitaires",
        image: "assets/produits/groupe-de-securite-chauffe-eau-mini.webp",
      ),
      Product(
        id: 8,
        name: "Nettoyeur HP",
        price: 145000,
        category: "Outils",
        image: "assets/produits/nettoyeur-haute-pression.jpg",
      ),
    ];
  }

  // Dans lib/services/api_service.dart

  Future<Product?> fetchProductDetails(String name) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final all = await fetchProducts();
    try {
      return all.firstWhere((p) => p.name == name);
    } catch (e) {
      return null;
    }
  }

  // Dans lib/services/api_service.dart
  Future<List<Product>> fetchFavoriteDetails(
    List<Map<String, String>> localFavorites,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final allProducts = await fetchProducts();

    // On filtre les produits réels qui correspondent aux noms stockés en local
    return allProducts
        .where((p) => localFavorites.any((fav) => fav['name'] == p.name))
        .toList();
  }

  // Dans lib/services/api_service.dart
  Future<List<Map<String, String>>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      {
        "title": "Protection\net sécurité",
        "image": "assets/categorie/protection-securite.png",
      },
      {"title": "Outils", "image": "assets/categorie/outils.png"},
      {
        "title": "Menuiserie\net serrurerie",
        "image": "assets/categorie/menuiserie-serrurerie.png",
      },
      {"title": "Quincaillerie", "image": "assets/categorie/quincaillerie.png"},
      {
        "title": "Peinture et\nrevêtements",
        "image": "assets/categorie/peinture-revetement.png",
      },
      {"title": "Electricité", "image": "assets/categorie/electricite.png"},
      {
        "title": "Plomberie et\nsanitaires",
        "image": "assets/categorie/plomberie-sanitaires.png",
      },
    ];
  }
}
