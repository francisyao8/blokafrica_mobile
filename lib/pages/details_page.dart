import 'package:flutter/material.dart';
import '../utils/constants.dart';

class DetailsPage extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productCategory;

  const DetailsPage({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER : BOUTON RETOUR ET DISCUSSIONS ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Text("Discussions", style: TextStyle(fontWeight: FontWeight.w500)),
                                SizedBox(width: 5),
                                Icon(Icons.chat_bubble_outline, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- IMAGE PRODUIT ---
                    Center(
                      child: Image.asset(
                        productImage,
                        height: 350,
                        fit: BoxFit.contain, // Pour voir tout le sac comme sur la maquette
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- INFOS PRODUIT ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  productName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                              // BOUTON FAVORIS CIRCULAIRE
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.favorite, color: blokOrange, size: 22),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // BADGE CATÉGORIE
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EAF0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              productCategory,
                              style: const TextStyle(color: Color(0xFF3F4C7A), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // DESCRIPTION PLACEHOLDER
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.menu, color: Colors.grey.shade300, size: 40),
                                const SizedBox(height: 10),
                                Text(
                                  "Aucune description disponible pour ce produit.",
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- BOTTOM BAR : PRIX ET BOUTON AJOUTER ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, spreadRadius: 5),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productPrice,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D264F), // Bleu très foncé de la maquette
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blokOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          "Ajouter",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
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