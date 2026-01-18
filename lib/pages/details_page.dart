import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

class DetailsPage extends StatefulWidget {
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
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  Product? productDetails;
  bool isLoading = true;
  bool isFavorite = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);

    _loadProductData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadProductData() async {
    final details = await ApiService().fetchProductDetails(widget.productName);
    final allFavs = await DatabaseHelper.instance.getAllProducts();
    final checkFav = allFavs.any((p) => p.name == widget.productName);

    if (mounted) {
      setState(() {
        productDetails = details;
        isFavorite = checkFav;
        isLoading = false;
      });
    }
  }

  Future<void> toggleFavorite() async {
    final db = DatabaseHelper.instance;
    String message = "";

    if (isFavorite) {
      final allFavs = await db.getAllProducts();
      final itemToDelete = allFavs.firstWhere(
        (p) => p.name == widget.productName,
      );
      if (itemToDelete.id != null) {
        await db.delete(itemToDelete.id!);
        message = "Produit retiré des favoris";
      }
    } else {
      double cleanPrice =
          double.tryParse(
            widget.productPrice.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0.0;
      Product newFav = Product(
        name: widget.productName,
        category: widget.productCategory,
        price: cleanPrice,
        image: widget.productImage,
        description: productDetails?.description ?? "",
      );
      await db.insert(newFav);
      message = "Produit ajouté aux favoris";
    }

    setState(() => isFavorite = !isFavorite);
    _showNotification(message);
  }

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
                    _buildHeader(),
                    isLoading
                        ? _buildImageSkeleton()
                        : Center(
                            child: Image.asset(
                              widget.productImage,
                              height: 350,
                              fit: BoxFit.contain,
                            ),
                          ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: isLoading
                                    ? _buildTextSkeleton(200, 24)
                                    : Text(
                                        widget.productName.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                              ),
                              _buildFavoriteButton(isFavorite),
                            ],
                          ),
                          const SizedBox(height: 10),
                          isLoading
                              ? _buildTextSkeleton(100, 25, borderRadius: 15)
                              : _buildCategoryBadge(),
                          const SizedBox(height: 30),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                         
                          _buildDescriptionContent(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionContent() {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextSkeleton(double.infinity, 14),
          const SizedBox(height: 8),
          _buildTextSkeleton(double.infinity, 14),
          const SizedBox(height: 8),
          _buildTextSkeleton(150, 14),
        ],
      );
    }

    if (productDetails == null || productDetails!.description.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F8F8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notes_rounded,
                size: 35,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Aucune description disponible pour ce produit.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Text(
      productDetails!.description,
      style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 24,
            ),
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
                Text(
                  "Discussions",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
                SizedBox(width: 5),
                Icon(Icons.chat_bubble_outline, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(bool isFav) {
    return GestureDetector(
      onTap: toggleFavorite,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite,
          color: isFav ? blokOrange : Colors.grey.shade400,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        widget.productCategory,
        style: const TextStyle(
          color: Color(0xFF3F4C7A),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isLoading
              ? _buildTextSkeleton(100, 30)
              : Text(
                  widget.productPrice,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D264F),
                  ),
                ),
          ElevatedButton(
            onPressed: isLoading ? null : () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: blokOrange,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Ajouter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSkeleton() {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        height: 350,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget _buildTextSkeleton(
    double width,
    double height, {
    double borderRadius = 5,
  }) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
