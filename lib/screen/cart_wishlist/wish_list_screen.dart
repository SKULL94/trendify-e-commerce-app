import 'package:Trendify/custom_widgets/wishlist_screen_widget.dart';
import 'package:Trendify/models/cart.dart';
import 'package:Trendify/providers/cart_provider.dart';
import 'package:Trendify/providers/wish_list_provider.dart';
import 'package:Trendify/screen/shared/shared.dart';
import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/media_query.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            top: getHeight(context, 16),
            bottom: getHeight(context, 16),
          ),
          child: Center(child: CustomText(text: 'My wish list')),
        ),
      ),
      body: Consumer<WishListProvider>(
        builder: (context, wishListProvider, child) {
          final wishListItems = wishListProvider.wishListItems;
          return wishListItems.isEmpty
              ? Center(child: emptyWishlist(context))
              : Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: getHeight(context, 20.0),
                      left: getWidth(context, 5),
                      right: getWidth(context, 5),
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: getHeight(context, 340),
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                      ),
                      itemCount: wishListProvider.wishListItems.length,
                      itemBuilder: (ctx, index) {
                        final item = wishListProvider.wishListItems[index];
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: getWidth(context, 25),
                                          left: getWidth(context, 25),

                                          top: getHeight(context, 25),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: item.imageUrl,
                                          fit: BoxFit.fitWidth,
                                          width: getWidth(context, 140),
                                          height: getHeight(context, 180),
                                        ),
                                      ),
                                      Positioned(
                                        left: getWidth(context, 16),
                                        bottom: getHeight(context, 11),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: getHeight(context, 8),
                                          ),
                                          child: Card(
                                            color: Colors.white70,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: getWidth(
                                                  context,
                                                  3,
                                                ),
                                                vertical: getHeight(context, 3),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: getWidth(context, 3),
                                                  ),
                                                  CustomText(
                                                    text:
                                                        item.rating.toString(),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: getWidth(context, 12),
                                                  ),
                                                  SizedBox(
                                                    width: getWidth(
                                                      context,
                                                      10,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: getHeight(
                                                      context,
                                                      16,
                                                    ),
                                                    width: getWidth(context, 1),
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: getWidth(
                                                      context,
                                                      15,
                                                    ),
                                                  ),
                                                  CustomText(
                                                    text:
                                                        item.ratingCount
                                                            .toString(),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  SizedBox(
                                                    width: getWidth(context, 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: getWidth(context, 20),
                                      top: getHeight(context, 5),
                                    ),
                                    child: CustomText(text: item.title),
                                  ),
                                  SizedBox(height: getHeight(context, 3)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: getWidth(context, 20),
                                    ),
                                    child: CustomText(
                                      text:
                                          '\u{20B9} ${item.price.toStringAsFixed(2)}',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Divider(height: getHeight(context, 1)),
                                  TextButton(
                                    child: Center(
                                      child: CustomText(
                                        text: "MOVE TO CART",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final currentContext = context;
                                      final cartProduct = CartProduct(
                                        id: item.id,
                                        title: item.title,
                                        price: item.price,
                                        imageUrl: item.imageUrl,
                                        description: item.description,
                                        rating: item.rating,
                                      );
                                      final status = await cartProvider
                                          .addProduct(cartProduct);
                                      Future.delayed(
                                        Duration(milliseconds: 500),
                                        () {
                                          if (currentContext.mounted) {
                                            showCustomSnackBar(
                                              currentContext,
                                              status
                                                  ? "Product added to cart!"
                                                  : "Failed to add to cart!",
                                            );
                                          }
                                        },
                                      );
                                      wishListProvider.removeProduct(
                                        "checkinglogin@gmail.com",
                                        item.id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: -getWidth(context, 5),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.grey.shade400,
                                  ),
                                  onPressed: () async {
                                    final currentContext = context;
                                    final status = await wishListProvider
                                        .removeProduct(
                                          item.id,
                                          "checkinglogin@gmail.com",
                                        );
                                    Future.delayed(Duration(milliseconds: 500), () {
                                      if (currentContext.mounted) {
                                        showCustomSnackBar(
                                          currentContext,
                                          status
                                              ? "Product removed from wishlist!"
                                              : "Failed to remove from wishlist!",
                                        );
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
        },
      ),
    );
  }
}
