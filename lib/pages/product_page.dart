import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import 'details_page.dart';
import 'dart:ui';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  String searchType = 'Nom';
  String selectedCategory = 'Tous';
  final List<String> searchOptions = ['Nom', 'Prix'];

  List<String> categories = ['Tous'];
  List<Product> allProducts = [];
  List<Product> displayProducts = [];
  List<Product> dbFavorites = [];

  bool isLoading = true;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);

    _fetchInitialData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- NOUVELLE MÉTHODE : TOAST PERSONNALISÉ ---
  void _showNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.7),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: 20, left: 50, right: 50),
      ),
    );
  }

  Future<void> _fetchInitialData() async {
    try {
      final api = ApiService();
      final results = await Future.wait([
        api.fetchCategories(),
        api.fetchProducts(),
        DatabaseHelper.instance.getAllProducts(),
      ]);

      if (mounted) {
        setState(() {
          categories = [
            'Tous',
            ...(results[0] as List<Map<String, String>>).map(
              (c) => c['title']!.replaceAll('\n', ' '),
            ),
          ];
          allProducts = results[1] as List<Product>;
          displayProducts = allProducts;
          dbFavorites = results[2] as List<Product>;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- LOGIQUE TOGFAVORITE MODIFIÉE ---
  Future<void> _toggleFavorite(Product p) async {
    final isAlreadyFav = dbFavorites.any((fav) => fav.name == p.name);

    if (isAlreadyFav) {
      final favToRemove = dbFavorites.firstWhere((fav) => fav.name == p.name);
      if (favToRemove.id != null) {
        await DatabaseHelper.instance.delete(favToRemove.id!);
        _showNotification("${p.name} retiré des favoris"); // Toast retrait
      }
    } else {
      await DatabaseHelper.instance.insert(p);
      _showNotification("${p.name} ajouté aux favoris"); // Toast ajout
    }

    final updatedFavs = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      dbFavorites = updatedFavs;
    });
  }

  void _runFilter(String query) {
    setState(() {
      displayProducts = allProducts.where((product) {
        final matchesCategory =
            selectedCategory == 'Tous' ||
            product.category.trim() == selectedCategory.trim();
        if (query.isEmpty) return matchesCategory;
        if (searchType == 'Nom') {
          return matchesCategory &&
              product.name.toLowerCase().contains(query.toLowerCase());
        } else {
          final queryPrice = double.tryParse(query) ?? double.infinity;
          return matchesCategory && (product.price <= queryPrice);
        }
      }).toList();
    });
  }

  // --- UI PRINCIPALE ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blokBlue,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: const Text(
          "Nos produits",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: blokBlue,
        child: const Icon(Icons.home, color: Colors.white),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(
              height: 35,
              child: isLoading
                  ? _buildCategorySkeleton()
                  : ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              selectedCategory == categories[index];
                          return _buildCategoryChip(
                            categories[index],
                            isSelected,
                          );
                        },
                      ),
                    ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                "Tous nos produits",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D264F),
                ),
              ),
            ),
            Expanded(child: _buildProductSection()),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE COMPOSANTS ---


  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: _runFilter,
              keyboardType: searchType == 'Prix'
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                hintText: searchType == 'Nom'
                    ? "Rechercher par nom..."
                    : "Budget max...",
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.tune, color: Color(0xFF1D264F)),
        onSelected: (val) => setState(() => searchType = val),
        itemBuilder: (context) => searchOptions
            .map(
              (opt) =>
                  PopupMenuItem(value: opt, child: Text("Filtrer par $opt")),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCategoryChip(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = title);
        _runFilter("");
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? blokOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection() {
    if (isLoading) return _buildProductGridSkeleton();

    if (displayProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.withOpacity(0.4),
                    Colors.grey.withOpacity(0.1),
                  ],
                ),
              ),
              child: const Icon(
                Icons.search_off,
                size: 50,
                color: Color(0xFF1D264F),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Aucun produit trouvé",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Essayez de modifier vos filtres",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.72,
      ),
      itemCount: displayProducts.length,
      itemBuilder: (context, index) =>
          _buildProductCard(context, displayProducts[index]),
    );
  }

  Widget _buildProductCard(BuildContext context, Product p) {
    bool isFav = dbFavorites.any((fav) => fav.name == p.name);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              productName: p.name,
              productPrice: "${p.price} fcfa",
              productImage: p.image,
              productCategory: p.category,
            ),
          ),
        ).then((_) => _fetchInitialData());
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.asset(
                      p.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(p),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: isFav ? blokOrange : Colors.white,
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
                        horizontal: 8,
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
                        "${p.price} fcfa",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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
                    p.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    p.category,
                    style: const TextStyle(
                      color: Color(0xFF3F4C7A),
                      fontSize: 10,
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
                      ),
                      child: const Text(
                        "AJOUTER",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildCategorySkeleton() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) => FadeTransition(
        opacity: _animation,
        child: Container(
          width: 90,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGridSkeleton() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(height: 12, width: 80, color: Colors.grey[200]),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 50, color: Colors.grey[200]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}