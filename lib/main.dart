import 'package:Trendify/data/datasources/datasources/product_service.dart';
import 'package:Trendify/presentations/providers/wish_list_provider.dart';
import 'package:Trendify/presentations/screens/shared/shared.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentations/providers/product_provider.dart';
import 'presentations/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (context) => ProductProvider(productService: ProductService()),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => WishListProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Provider Demo',
        home: NavigationExample(),
      ),
    );
  }
}
