// services/product_service.dart
import 'package:Trendify/data/datasources/base_api.dart';
import 'package:Trendify/data/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService extends ApiService {
  Future<List<Product>> fetchProducts() async {
    final response = await handleRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/products')),
    );
    return (response['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await handleRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/search/$query')),
    );
    return (response['searchResults'] as List)
        .map((product) => Product.searchProduct(product))
        .toList();
  }

  Future<List<Product>> fetchCategoryProducts(String category) async {
    final response = await handleRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/category/$category')),
    );
    return (response['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }
}
