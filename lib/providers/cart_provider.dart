import 'package:Trendify/api_service/cart_service.dart';
import 'package:Trendify/models/cart.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<CartProduct> _cartProducts = [];
  final CartService _cartService = CartService();

  List<CartProduct> get cartProducts => [..._cartProducts];

  Future<bool> addProduct(CartProduct product) async {
    final index = _cartProducts.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _cartProducts[index].quantity++;
    } else {
      _cartProducts.add(product);
    }
    notifyListeners();
    return await _cartService.addToCart(
      "checkinglogin@gmail.com",
      product.id,
      product.quantity,
    );
  }

  Future<void> increaseQuantity(String productId) async {
    final product = _cartProducts.firstWhere((item) => item.id == productId);
    product.quantity++;
    notifyListeners();
    await _cartService.addToCart(
      "checkinglogin@gmail.com",
      product.id,
      product.quantity,
    );
  }

  Future<void> decreaseQuantity(String productId) async {
    final product = _cartProducts.firstWhere((item) => item.id == productId);
    if (product.quantity > 1) {
      product.quantity--;
      notifyListeners();
      await _cartService.addToCart(
        "checkinglogin@gmail.com",
        product.id,
        product.quantity,
      );
    } else {
      await removeProduct(productId);
    }
  }

  Future<bool> removeProduct(String productId) async {
    _cartProducts.removeWhere((item) => item.id == productId);
    notifyListeners();
    return await _cartService.removeCartProduct(
      "checkinglogin@gmail.com",
      productId,
    );
  }

  bool isInCart(String productId) =>
      _cartProducts.any((item) => item.id == productId);

  int getQuantity(String productId) {
    return _cartProducts
        .firstWhere(
          (item) => item.id == productId,
          orElse:
              () => CartProduct(
                id: '',
                title: '',
                price: 0,
                imageUrl: '',
                description: '',
                rating: 0,
                quantity: 0,
              ),
        )
        .quantity;
  }

  Future<void> fetchCartProducts(String user) async {
    try {
      final products = await _cartService.fetchCartProducts(user);
      _cartProducts = products;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // TODO: Refactor with WishlistService when available
  // Future<bool> moveToWishlist(String user, String prodId) async {
  //   final response = await http.patch(
  //     Uri.parse('${ApiService.baseUrl}/wishlist/$user/$prodId'),
  //   );
  //   var jsonReponse = jsonDecode(response.body);
  //   return jsonReponse['status'];
  // }
}
