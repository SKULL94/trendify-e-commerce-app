import 'package:Trendify/api_service/wishlist_service.dart';
import 'package:Trendify/models/wish_list.dart';
import 'package:flutter/material.dart';

class WishListProvider with ChangeNotifier {
  final WishListService wishListService = WishListService();
  List<WishListItems> _wishListItems = [];

  List<WishListItems> get wishListItems => [..._wishListItems];

  Future<bool> addProduct(WishListItems wishListItem, String userId) async {
    try {
      final success = await wishListService.addToWishlist(
        userId,
        wishListItem.id,
      );
      if (success) {
        _wishListItems.add(wishListItem);
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  Future<bool> removeProduct(String productId, String email) async {
    try {
      final success = await wishListService.removeFromWishlist(
        email,
        productId,
      );
      if (success) {
        _wishListItems.removeWhere((product) => product.id == productId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }

  bool isFavorite(String productId) {
    return _wishListItems.any((item) => item.id == productId);
  }

  Future<void> fetchWishlistProducts(String user) async {
    try {
      final items = await wishListService.fetchWishlist(user);
      _wishListItems = items;
      notifyListeners();
    } catch (e) {
      print('Error fetching wishlist: $e');
      // Consider adding error state handling here
    }
  }
}
