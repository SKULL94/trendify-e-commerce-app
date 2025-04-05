import 'package:Trendify/custom_widgets/cart_screen_widgets.dart';
import 'package:Trendify/models/wish_list.dart';
import 'package:Trendify/providers/cart_provider.dart';
import 'package:Trendify/providers/wish_list_provider.dart';
import 'package:Trendify/screen/cart_wishlist/shipping_address_screen.dart';
import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/helper_functions.dart';
import 'package:Trendify/utils/media_query.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.cartProducts;
        final subtotal = cartItems.fold(0.0, (a, b) => a + b.price);
        final tax = (subtotal * 0.018).ceilToDouble();
        final total = subtotal + tax;

        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar:
              cartItems.isEmpty
                  ? null
                  : BottomAppBar(
                    color: Colors.white,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShippingAddressScreen(),
                          ),
                        );
                      },
                      child: CustomText(
                        text: "PLACE ORDER",
                        color: Colors.white,
                      ),
                    ),
                  ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(context, 16),
                vertical: getHeight(context, 16),
              ),
              child: CustomText(
                text: "SHOPPING BAG",
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          body: SafeArea(
            child:
                cartItems.isEmpty
                    ? emptyCart(context)
                    : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(childCount: cartItems.length, (
                            ctx,
                            index,
                          ) {
                            final item = cartItems[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getWidth(context, 16),
                                vertical: getHeight(context, 8),
                              ),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    getWidth(context, 10),
                                  ),
                                  child: Consumer<WishListProvider>(
                                    builder: (
                                      context,
                                      wishListProvider,
                                      child,
                                    ) {
                                      return Stack(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: item.imageUrl,
                                                fit: BoxFit.cover,
                                                height: getHeight(context, 130),
                                                width: getWidth(context, 120),
                                              ),
                                              SizedBox(
                                                width: getWidth(context, 12),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomText(
                                                      text: item.title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                    CustomText(
                                                      text:
                                                          '\u{20B9} ${item.price.toStringAsFixed(2)}',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(
                                                      height: getHeight(
                                                        context,
                                                        8,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: getHeight(
                                                        context,
                                                        35,
                                                      ),
                                                      width: getWidth(
                                                        context,
                                                        120,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.remove,
                                                              size: 15,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed:
                                                                () => cartProvider
                                                                    .decreaseQuantity(
                                                                      item.id,
                                                                    ),
                                                          ),
                                                          CustomText(
                                                            text:
                                                                '${cartProvider.getQuantity(item.id)}',
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.add,
                                                              size: 15,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed:
                                                                () => cartProvider
                                                                    .increaseQuantity(
                                                                      item.id,
                                                                    ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: getHeight(
                                                        context,
                                                        6,
                                                      ),
                                                    ),
                                                    Card(
                                                      color:
                                                          Colors.grey.shade300,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: CustomText(
                                                        text: "  Size:  S  ",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: getHeight(
                                                        context,
                                                        6,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .delivery_dining_sharp,
                                                          color: Colors.green,
                                                        ),
                                                        SizedBox(
                                                          width: getWidth(
                                                            context,
                                                            5,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: CustomText(
                                                            text:
                                                                'Delivery by ${item.estimatedDeliveryDate!.day} '
                                                                '${getMonth(item.estimatedDeliveryDate!.month)} '
                                                                '${item.estimatedDeliveryDate!.year}',
                                                            fontSize: 12.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            top: -10,
                                            right: -15,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Colors.grey.shade400,
                                                size: 18,
                                              ),
                                              onPressed: () async {
                                                showCartDialogOptions(
                                                  context,
                                                  item.imageUrl,
                                                  (option) async {
                                                    if (option == 'wishlist') {
                                                      final wishlistItem =
                                                          WishListItems(
                                                            id: item.id,
                                                            title: item.title,
                                                            description:
                                                                item.description,
                                                            price: item.price,
                                                            imageUrl:
                                                                item.imageUrl,
                                                            rating: 3,
                                                          );
                                                      final status =
                                                          await wishListProvider
                                                              .addProduct(
                                                                wishlistItem,
                                                                "checkinglogin@gmail.com",
                                                              );
                                                      print(status);
                                                      cartProvider
                                                          .removeProduct(
                                                            item.id,
                                                          );
                                                    }
                                                    if (option == 'delete') {
                                                      final status =
                                                          await cartProvider
                                                              .removeProduct(
                                                                item.id,
                                                              );
                                                      print(status);
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(getWidth(context, 16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:
                                      "PRICE DETAILS (${cartItems.length} items)",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                Divider(thickness: 1),
                                SizedBox(height: getHeight(context, 8)),
                                priceRow(
                                  "Total",
                                  '₹${subtotal.toStringAsFixed(2)}',
                                ),
                                priceRow("Tax", '₹${tax.toStringAsFixed(2)}'),
                                priceRow(
                                  "Shipping Charges",
                                  'Free',
                                  color: Colors.green,
                                ),
                                Divider(thickness: 1),
                                SizedBox(height: getHeight(context, 12)),
                                priceRow(
                                  "TOTAL AMOUNT",
                                  '₹${total.toStringAsFixed(2)}',
                                  isBold: true,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }
}
