import 'package:Trendify/models/payment.dart';
import 'package:Trendify/providers/cart_provider.dart';
import 'package:Trendify/screen/cart_wishlist/cart_screen.dart';
import 'package:Trendify/screen/orders_payment/orders_screen.dart';
import 'package:Trendify/screen/orders_payment/splash_screen.dart';
import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/media_query.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.cartProducts;
        return Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: "ADDRESS",
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () async {
                final currentContext = context;
                double totalQuantity = cartItems.fold(0, (a, b) => a + b.price);
                final status = await initPaymentSheet(totalQuantity);
                print(status);
                if (status == "success") {
                  if (currentContext.mounted) {
                    Navigator.push(
                      currentContext,
                      MaterialPageRoute(
                        builder:
                            (currentContext) =>
                                OrderStatusSplashScreen(status: 'success'),
                      ),
                    );
                  }

                  Future.delayed(const Duration(milliseconds: 2000), () {
                    if (currentContext.mounted) {
                      Navigator.pushReplacement(
                        currentContext,
                        MaterialPageRoute(
                          builder: (currentContext) => const OrdersPage(),
                        ),
                      );
                    }
                  });
                } else {
                  if (currentContext.mounted) {
                    Navigator.push(
                      currentContext,
                      MaterialPageRoute(
                        builder:
                            (_) => OrderStatusSplashScreen(status: 'failed'),
                      ),
                    );
                  }
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    if (currentContext.mounted) {
                      Navigator.pushReplacement(
                        currentContext,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    }
                  });
                }
              },
              child: CustomText(
                text: "CONTINUE",
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: getWidth(context, 10),
                        bottom: getHeight(context, 10),
                        top: getHeight(context, 10),
                      ),
                      child: CustomText(
                        text: "DEFAULT",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: getHeight(context, 8),
                        bottom: getHeight(context, 50),
                      ),
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.only(
                          left: getWidth(context, 16),
                          bottom: getHeight(context, 60),
                          top: getHeight(context, 16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Zeeshan",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            SizedBox(height: getHeight(context, 5)),
                            CustomText(
                              text: "Sector 76, Gurugram",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            SizedBox(height: getHeight(context, 5)),
                            CustomText(
                              text: "Mobile: 7250497748",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: getWidth(context, 15),
                        bottom: getHeight(context, 15),
                      ),
                      child: CustomText(
                        text: "DELIVERY ESTIMATES",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((ctx, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: cartItems[index].imageUrl,
                            width: getWidth(context, 70),
                            height: getHeight(context, 70),
                          ),
                          CustomText(
                            text:
                                'Estimated delivery by ${cartItems[index].estimatedDeliveryDate!.day.toString()} ${getMonth(cartItems[index].estimatedDeliveryDate!.month)} ${cartItems[index].estimatedDeliveryDate!.year.toString()}',
                            fontSize: 12.5,
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: cartItems.length),
              ),
            ],
          ),
        );
      },
    );
  }
}
