import 'package:Trendify/data/datasources/datasources/product_service.dart';
import 'package:flutter/material.dart';
import 'package:Trendify/data/models/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductService productService;
  List<Product> _products = [];
  List<Product> _populuarProducts = [];
  List<Product> _newlyAddedProducts = [];
  List<Product> _searchProducts = [];
  List<Product> _categoryProducts = [];

  ProductProvider({required this.productService});

  List<Product> get products => [..._products];
  List<Product> get popularProducts => [..._populuarProducts];
  List<Product> get newlyAddedProducts => [..._newlyAddedProducts];
  List<Product> get searchProducts => [..._searchProducts];
  List<Product> get categoryProducts => [..._categoryProducts];

  Future<void> fetchProducts() async {
    try {
      final products = await productService.fetchProducts();
      _products = products;
      // Filter popular products (every other product starting from index 1)
      _populuarProducts =
          products
              .asMap()
              .entries
              .where((entry) => entry.key % 2 != 0)
              .map((entry) => entry.value)
              .toList();
      // Filter newly added products (every other product starting from index 0)
      _newlyAddedProducts =
          products
              .asMap()
              .entries
              .where((entry) => entry.key % 2 == 0)
              .map((entry) => entry.value)
              .toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> searchProduct(String searchQuery) async {
    try {
      final products = await productService.searchProducts(searchQuery);
      _searchProducts = products;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  Future<void> categoryProduct(String categoryName) async {
    try {
      final products = await productService.fetchCategoryProducts(categoryName);
      _categoryProducts = products;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch category products: $e');
    }
  }
}
