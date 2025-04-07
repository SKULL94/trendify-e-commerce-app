import 'package:Trendify/core/utils/media_query.dart';
import 'package:Trendify/presentations/providers/cart_provider.dart';
import 'package:Trendify/presentations/providers/product_provider.dart';
import 'package:Trendify/presentations/providers/wish_list_provider.dart';
import 'package:Trendify/presentations/screens/cart_wishlist/cart_screen.dart';
import 'package:Trendify/presentations/screens/cart_wishlist/wish_list_screen.dart';
import 'package:Trendify/presentations/screens/orders_payment/orders_screen.dart';
import 'package:Trendify/presentations/screens/products/products_screen.dart';
import 'package:Trendify/presentations/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key, this.token});

  final dynamic token;

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    Provider.of<WishListProvider>(
      context,
      listen: false,
    ).fetchWishlistProducts("checkinglogin@gmail.com");
    Provider.of<CartProvider>(
      context,
      listen: false,
    ).fetchCartProducts("checkinglogin@gmail.com");
  }

  int currentPageIndex = 0;
  CartProvider cartProvider = CartProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blueGrey.shade300,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(label: 'Home', icon: Icon(Icons.home_outlined)),
          NavigationDestination(label: 'wishlist', icon: Icon(Icons.favorite)),
          NavigationDestination(
            label: 'cart',
            icon: Badge(
              label: Text('${cartProvider.cartProducts.length}'),
              //backgroundColor: Colors.blueGrey,
              child: Icon(Icons.shopping_cart),
            ),
          ),
          NavigationDestination(label: 'Orders', icon: Icon(Icons.receipt)),
        ],
      ),
      body:
          <Widget>[
            ProductsScreen(),
            WishListScreen(),
            CartScreen(),
            OrdersPage(),
          ][currentPageIndex],
    );
  }
}

void showCustomSnackBar(BuildContext context, String message, {Color? color}) {
  final snackBar = SnackBar(
    content: CustomText(text: message, color: Colors.white, fontSize: 16),
    backgroundColor: color ?? Colors.black87,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: EdgeInsets.symmetric(
      horizontal: getWidth(context, 16),
      vertical: getHeight(context, 16),
    ),
    elevation: 6,
    duration: Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget buildStep(String label, bool coloredIndex, BuildContext context) {
  return Row(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: getWidth(context, 12),
            height: getHeight(context, 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: coloredIndex ? Colors.green : Colors.white,
              border: Border.all(color: Colors.green, width: 1),
            ),
          ),
          if (coloredIndex)
            Icon(Icons.check, size: 6, color: Colors.white)
          else
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
        ],
      ),
      CustomText(
        text: label,

        color: coloredIndex ? Colors.green : Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    ],
  );
}

Container buildLine(double width, bool coloredIndex, BuildContext context) {
  return Container(
    height: getHeight(context, 2),
    width: width,
    color: coloredIndex ? Colors.green : Colors.grey,
  );
}
