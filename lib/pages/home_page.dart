import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'details_page.dart';
import '../utils/data_manager.dart';

// 1. On transforme le StatelessWidget en StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 2. Fonction pour ajouter/retirer des favoris et rafraîchir l'écran
  void toggleFavorite(
    String name,
    String category,
    String price,
    String imgPath,
  ) {
    setState(() {
      // On cherche si le produit existe déjà dans la liste globale favoriteProducts
      int index = favoriteProducts.indexWhere((p) => p['name'] == name);

      if (index != -1) {
        favoriteProducts.removeAt(index); // Supprimer si présent
      } else {
        favoriteProducts.add({
          'name': name,
          'category': category,
          'price': price,
          'image': imgPath,
        }); // Ajouter si absent
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blokBlue,
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          "Acceuil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _buildAppBarIcon(Icons.settings),
          const SizedBox(width: 10),
          _buildAppBarIcon(Icons.notifications),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text(
                "categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: [
                  _buildCategoryCard(
                    "Protection\net sécurité",
                    "assets/categorie/protection-securite.png",
                  ),
                  _buildCategoryCard("Outils", "assets/categorie/outils.png"),
                  _buildCategoryCard(
                    "Menuiserie\net serrurerie",
                    "assets/categorie/menuiserie-serrurerie.png",
                  ),
                  _buildCategoryCard(
                    "Quincaillerie",
                    "assets/categorie/quincaillerie.png",
                  ),
                  _buildCategoryCard(
                    "Peinture et\nrevêtements",
                    "assets/categorie/peinture-revetement.png",
                  ),
                  _buildCategoryCard(
                    "Electricité",
                    "assets/categorie/electricite.png",
                  ),
                  _buildCategoryCard(
                    "Plomberie et\nsanitaires",
                    "assets/categorie/plomberie-sanitaires.png",
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Nouveaux produits",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "voir plus",
                      style: TextStyle(color: blokOrange),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.72,
                children: [
                  // Suppression du booléen fixe 'false' ou 'true' : on vérifie dynamiquement
                  _buildProductCard(
                    context,
                    "PANTINOX SR9 ...",
                    "Peinture et revêtements",
                    "24 500 fcfa",
                    "assets/produits/peinture.jpeg",
                  ),
                  _buildProductCard(
                    context,
                    "Grillage 1 doigt ...",
                    "Quincaillerie",
                    "12 000 fcfa",
                    "assets/produits/grillage.jpg",
                  ),
                  _buildProductCard(
                    context,
                    "Ciment CPJ 45 ...",
                    "Matériaux",
                    "4 500 fcfa",
                    "assets/produits/ciment.png",
                  ),
                  _buildProductCard(
                    context,
                    "Poubelle Ville ...",
                    "Sanitaire",
                    "15 000 fcfa",
                    "assets/produits/poubelle.webp",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF3F4C7A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF7A21), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.5),
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    stops: const [0.0, 0.4],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    String name,
    String category,
    String price,
    String imgPath,
  ) {
    // 3. Vérification si le produit est actuellement dans les favoris
    bool isFavorite = favoriteProducts.any((p) => p['name'] == name);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              productName: name,
              productPrice: price,
              productImage: imgPath,
              productCategory: category,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.asset(
                      imgPath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      // 4. On appelle toggleFavorite lors du clic sur le cœur
                      onTap: () =>
                          toggleFavorite(name, category, price, imgPath),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: isFavorite ? blokOrange : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      color: Color(0xFF3F4C7A),
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blokOrange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 16),
                          Text(
                            " AJOUTER",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
