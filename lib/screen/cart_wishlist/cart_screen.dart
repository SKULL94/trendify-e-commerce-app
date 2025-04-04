import 'package:Trendify/models/wish_list.dart';
import 'package:Trendify/providers/cart_provider.dart';
import 'package:Trendify/providers/wish_list_provider.dart';
import 'package:Trendify/screen/cart_wishlist/shipping_address_screen.dart';
import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/images.dart';
import 'package:Trendify/utils/media_query.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;

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
                      onPressed: () async {
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
          body:
              cartItems.isEmpty
                  ? Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: _emptyCart(),
                  )
                  : CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(childCount: cartItems.length, (
                          ctx,
                          index,
                        ) {
                          final item = cartItems[index];
                          return SizedBox(
                            height: getHeight(context, 200),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: getWidth(context, 20),
                                vertical: getHeight(context, 10),
                              ),
                              color: Colors.white,
                              child: Consumer<WishListProvider>(
                                builder: (context, wishListProvider, child) {
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: getWidth(context, 10),
                                        ), // Add padding to prevent overflow
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: getWidth(context, 20),
                                                top: getHeight(context, 10),
                                                bottom: getHeight(context, 10),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: item.imageUrl,
                                                fit: BoxFit.cover,
                                                height: getHeight(context, 140),
                                              ),
                                            ),
                                            SizedBox(
                                              width: getWidth(context, 10),
                                            ), // Spacer between image and text
                                            Expanded(
                                              // Ensures text does not exceed available space
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: getHeight(
                                                        context,
                                                        20,
                                                      ),
                                                    ),
                                                    child: CustomText(
                                                      text: item.title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  CustomText(
                                                    text:
                                                        '\u{20B9} ${item.price.toStringAsFixed(2)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  SizedBox(
                                                    height: getHeight(
                                                      context,
                                                      10,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: getHeight(
                                                          context,
                                                          35,
                                                        ),
                                                        width: getWidth(
                                                          context,
                                                          105,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.remove,
                                                                size: 15,
                                                                color:
                                                                    Colors
                                                                        .white,
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
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.add,
                                                                size: 15,
                                                                color:
                                                                    Colors
                                                                        .white,
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
                                                          3,
                                                        ),
                                                      ),
                                                      Card(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade300,
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
                                                    ],
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
                                                          3,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        // Prevents text from overflowing
                                                        child: CustomText(
                                                          text:
                                                              'Delivery by ${cartItems[index].estimatedDeliveryDate!.day} '
                                                              '${getMonth(cartItems[index].estimatedDeliveryDate!.month)} '
                                                              '${cartItems[index].estimatedDeliveryDate!.year}',
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
                                      ),
                                      Positioned(
                                        top: -10,
                                        right:
                                            0, // Adjusted to fit inside screen
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.grey.shade400,
                                            size: 18,
                                          ),
                                          onPressed: () async {
                                            _showCartDialogOptions(
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
                                                        imageUrl: item.imageUrl,
                                                        rating: 3,
                                                      );
                                                  final status =
                                                      await wishListProvider
                                                          .addProduct(
                                                            wishlistItem,
                                                            "checkinglogin@gmail.com",
                                                          );
                                                  print(status);
                                                  cartProvider.removeProduct(
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
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: getHeight(context, 250),
                          padding: EdgeInsets.symmetric(
                            vertical: getHeight(context, 20),
                            horizontal: getWidth(context, 20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(getWidth(context, 8)),
                            child: Column(
                              children: [
                                CustomText(
                                  text:
                                      "PRICE DETAILS (${cartItems.length} items)",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                Divider(thickness: 1),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "Total",
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text:
                                          '\u{20B9} ${cartItems.fold(0, (a, b) => a + b.price)}',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                SizedBox(height: getHeight(context, 10)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "Tax",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text:
                                          '\u{20B9} ${(cartItems.fold(0, (a, b) => a + b.price) * 0.018).ceilToDouble()}',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                SizedBox(height: getHeight(context, 10)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "Shipping Charges",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text: 'Free',
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                SizedBox(height: getHeight(context, 30)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "TOTAL AMOUNT",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    CustomText(
                                      text:
                                          '\u{20B9} ${(cartItems.fold(0, (a, b) => a + b.price) * 0.018).ceilToDouble() + cartItems.fold(0, (a, b) => a + b.price)}',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }

  Widget _emptyCart() {
    return Column(
      children: [
        SizedBox(
          height: getHeight(context, 500),
          child: rive.RiveAnimation.asset(
            Images.basket,
            stateMachines: ['Adding to basket - State Machine 1'],
            onInit: (rive.Artboard artboard) {
              var controller = rive.StateMachineController.fromArtboard(
                artboard,
                'State Machine 1',
              );
              if (controller != null) {
                artboard.addController(controller);
                controller.isActive = true;
              }
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomText(
            text: 'Hmm.. your cart looks empty :(',
            fontSize: 18,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _showCartDialogOptions(
    BuildContext context,
    String imageUrl,
    Function(String) callback,
  ) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: getHeight(context, 420),
          width: getWidth(context, 300),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: getHeight(context, 50)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    width: getWidth(context, 80),
                    height: getHeight(context, 80),
                    child: Padding(
                      padding: EdgeInsets.all(getWidth(context, 8)),
                      child: Image(image: NetworkImage(imageUrl)),
                    ),
                  ),
                  SizedBox(height: getHeight(context, 10)),
                  CustomText(
                    text: "Are you sure?",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Padding(
                    padding: EdgeInsets.all(getWidth(context, 8)),
                    child: CustomText(
                      text:
                          "This item made it all the way to your cart! Having second thoughts?",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 10)),
                  Container(
                    color: Colors.black,
                    width: getWidth(context, 300),
                    height: getHeight(context, 40),
                    child: TextButton(
                      onPressed: () {
                        callback("wishlist");
                        Navigator.pop(context);
                      },
                      child: CustomText(
                        text: "Move to Wishlist",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context, 10)),
                  TextButton(
                    onPressed: () {
                      callback("delete");
                      Navigator.pop(context);
                    },
                    child: CustomText(
                      text: "Remove",
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 14,
                left: 14,
                child: IconButton(
                  icon: Icon(Icons.cancel),
                  color: Colors.grey.shade400,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String getMonth(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}
