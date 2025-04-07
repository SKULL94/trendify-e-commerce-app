import 'dart:convert';
import 'package:Trendify/data/datasources/base_api.dart';
import 'package:Trendify/data/models/wish_list.dart';
import 'package:http/http.dart' as http;

class WishListService extends ApiService {
  Future<List<WishListItems>> fetchWishlist(String user) async {
    final response = await handleRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/wishlist/$user')),
    );
    return (response['products'] as List)
        .map((product) => WishListItems.fromJson(product))
        .toList();
  }

  Future<bool> addToWishlist(String user, String prodId) async {
    final response = await handleRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/wishlist'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": user,
          "products": [prodId],
        }),
      ),
    );
    return response['status'];
  }

  Future<bool> removeFromWishlist(String user, String prodId) async {
    final response = await handleRequest(
      () => http.delete(
        Uri.parse('${ApiService.baseUrl}/wishlist/$user/$prodId'),
      ),
    );
    return response['status'];
  }
}
