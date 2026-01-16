import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/favorites_page.dart';
import 'utils/constants.dart';

void main() => runApp(const BlokApp());

class BlokApp extends StatelessWidget {
  const BlokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: blokBlue,
        colorScheme: ColorScheme.fromSeed(seedColor: blokBlue),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Les écrans correspondant à ta maquette
  final List<Widget> _screens = [
    const HomePage(), // Icône Accueil
    const Center(child: Text("Mon Panier")), // Icône Produits
    const FavoritesPage(), // Icône Favoris
    const Center(child: Text("Profil")), // Icône Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        // Cette décoration crée la bordure orange du haut comme sur la maquette
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: blokOrange, width: 2.0), // Bordure orange
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: blokBlue, // Fond bleu marine
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor:
              blokOrange, // Texte et icône sélectionnés en orange
          unselectedItemColor:
              Colors.white, // Icônes non sélectionnées en blanc
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Acceuil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_outlined),
              label: 'pannier', // Orthographe exacte de la maquette
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoris',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
