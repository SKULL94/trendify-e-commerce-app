import 'dart:convert';
import 'package:Trendify/api_service/base_api.dart';
import 'package:Trendify/models/cart.dart';
import 'package:http/http.dart' as http;

class CartService extends ApiService {
  Future<List<CartProduct>> fetchCartProducts(String user) async {
    final response = await handleRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/cart/$user')),
    );
    return (response['products'] as List)
        .map((product) => CartProduct.fromJson(product))
        .toList();
  }

  Future<bool> addToCart(String user, String prodId, int quantity) async {
    final response = await handleRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/cart'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": user,
          "products": [
            {"product": prodId, "quantity": quantity},
          ],
        }),
      ),
    );
    return response['status'];
  }

  Future<bool> removeCartProduct(String user, String prodId) async {
    final response = await handleRequest(
      () => http.delete(Uri.parse('${ApiService.baseUrl}/cart/$user/$prodId')),
    );
    return response['status'];
  }
}
