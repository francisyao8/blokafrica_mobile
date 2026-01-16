import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'details_page.dart';
import '../utils/data_manager.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  
  // Fonction pour supprimer un produit et mettre à jour l'écran
  void removeFromFavorites(String name) {
    setState(() {
      favoriteProducts.removeWhere((p) => p['name'] == name);
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
          "Favoris", 
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)
        ),
        actions: [
          _buildAppBarIcon(Icons.settings),
          const SizedBox(width: 10),
          _buildAppBarIcon(Icons.notifications),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mes favoris", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            Expanded(
              child: favoriteProducts.isEmpty 
                ? const Center(
                    child: Text(
                      "Aucun favori pour le moment",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    itemCount: favoriteProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final p = favoriteProducts[index];
                      return _buildFavoriteCard(
                        context,
                        p['name']!,
                        p['category']!,
                        p['price']!,
                        p['image']!,
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon) {
    return Container(
      width: 45, height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF3F4C7A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, String name, String category, String price, String imgPath) {
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      imgPath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // COEUR CLIQUABLE POUR SUPPRIMER
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => removeFromFavorites(name),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite, color: blokOrange, size: 20),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10, left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        price,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
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
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(category, style: const TextStyle(color: Color(0xFF3F4C7A), fontSize: 10)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blokOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                      ),
                      child: const Text("DÉTAILS", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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