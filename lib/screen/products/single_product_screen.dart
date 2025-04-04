import 'package:Trendify/models/cart.dart';
import 'package:Trendify/models/wish_list.dart';
import 'package:Trendify/providers/cart_provider.dart';
import 'package:Trendify/providers/product_provider.dart';
import 'package:Trendify/providers/wish_list_provider.dart';
import 'package:Trendify/screen/cart_wishlist/cart_screen.dart';
import 'package:Trendify/screen/shared/shared.dart';
import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/media_query.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../models/ratings.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({super.key, required this.id, this.isNew = false});
  final String id;
  final bool isNew;

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  bool isInCart = false;
  Color _cartButtonColor = const Color.fromARGB(255, 14, 64, 122);
  String _selectedSize = '';
  final _sizeTextColor = const Color.fromARGB(255, 241, 164, 164);
  final _textBgColor = Colors.white;
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final _reviewTextController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Consumer<WishListProvider>(
          builder: (context, wishListProvider, child) {
            return Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final products = productProvider.products;
                final product = products.singleWhere(
                  (id) => id.id == widget.id,
                );
                final isFavorite = wishListProvider.isFavorite(product.id);

                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    title: CustomText(
                      text: 'Product Details',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  bottomNavigationBar: BottomAppBar(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          color: Colors.grey.shade200,
                          width: getWidth(context, 160),
                          height: getHeight(context, 45),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                  size: 25,
                                ),
                                SizedBox(width: getWidth(context, 5)),
                                CustomText(
                                  text: 'wishlist',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              if (isFavorite) {
                                final status = await wishListProvider
                                    .removeProduct(
                                      product.id,
                                      "checkinglogin@gmail.com",
                                    );
                                Future.delayed(Duration(milliseconds: 500), () {
                                  showCustomSnackBar(
                                    context,
                                    status
                                        ? "Product removed from wishlist!"
                                        : "Failed to remove from wishlist!",
                                  );
                                });
                              } else {
                                final wishlistProduct = WishListItems(
                                  id: product.id,
                                  title: product.title,
                                  price: product.price,
                                  imageUrl: product.imageUrl,
                                  description: product.description,
                                  rating: product.rating,
                                );

                                final status = await wishListProvider
                                    .addProduct(
                                      wishlistProduct,
                                      "checkinglogin@gmail.com",
                                    );
                                Future.delayed(Duration(milliseconds: 500), () {
                                  showCustomSnackBar(
                                    context,
                                    status
                                        ? "Product added to wishlist!"
                                        : "Failed to add to wishlist!",
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          width: getWidth(context, 160),
                          height: getHeight(context, 45),
                          decoration: BoxDecoration(
                            color: _cartButtonColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed:
                                !isInCart
                                    ? () async {
                                      final cartProduct = CartProduct(
                                        id: product.id,
                                        title: product.title,
                                        price: product.price,
                                        imageUrl: product.imageUrl,
                                        description: product.description,
                                        rating: product.rating,
                                      );

                                      final status = await cartProvider
                                          .addProduct(cartProduct);
                                      Future.delayed(
                                        Duration(milliseconds: 500),
                                        () {
                                          showCustomSnackBar(
                                            context,
                                            status
                                                ? "Product added to cart!"
                                                : "Failed to add to cart!",
                                          );
                                        },
                                      );
                                      setState(() {
                                        isInCart = true;
                                        _cartButtonColor = Colors.grey.shade200;
                                      });
                                    }
                                    : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CartScreen(),
                                        ),
                                      );
                                    },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  color: isInCart ? Colors.black : Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: getWidth(context, 10)),
                                CustomText(
                                  text: isInCart ? "View Cart" : "Add to Cart",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isInCart ? Colors.black : Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getWidth(context, 16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: getHeight(context, 300),
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: getHeight(context, 16),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrl,
                                  ),
                                ),
                              ),
                              if (widget.isNew)
                                Positioned(
                                  top: getHeight(context, 10),
                                  left: getWidth(context, 10),
                                  child: Card(
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        getWidth(context, 2),
                                      ),
                                      child: CustomText(
                                        text: "  New  ",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: getHeight(context, 20)),
                          CustomText(
                            text: product.title,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              CustomText(
                                text: product.rating.toString(),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                              CustomText(
                                text:
                                    ' (${product.ratingCount.toString()} reviews)',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                              Spacer(),
                              CustomText(
                                text:
                                    ' \u{20B9} ${product.price.toStringAsFixed(2)}',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          SizedBox(height: getHeight(context, 30)),
                          Container(
                            padding: EdgeInsets.all(getWidth(context, 8)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: const Color.fromARGB(255, 241, 164, 164),
                            ),
                            child: CustomText(
                              text: '  DESCRIPTION  ',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: getHeight(context, 10)),
                          ReadMoreText(
                            product.description,
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            trimLines: 2,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'See more',
                            trimExpandedText: 'See less',
                            moreStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            lessStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          (product.category == 'clothes' ||
                                  product.category == 'footwear')
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: getHeight(context, 15)),
                                  CustomText(
                                    text: 'SELECT SIZE',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: getHeight(context, 8)),
                                  Row(
                                    children:
                                        _sizes.map((category) {
                                          bool isSelected =
                                              _selectedSize == category;
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: getWidth(context, 16),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _selectedSize = category;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                  getWidth(context, 15),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                    color: _sizeTextColor,
                                                  ),
                                                  color:
                                                      isSelected
                                                          ? _sizeTextColor
                                                          : _textBgColor,
                                                ),
                                                child: CustomText(
                                                  text: category,
                                                  color:
                                                      isSelected
                                                          ? _textBgColor
                                                          : _sizeTextColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ],
                              )
                              : Container(),
                          SizedBox(height: getHeight(context, 20)),
                          CustomText(
                            text: 'Reviews',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          SizedBox(height: getHeight(context, 10)),
                          Column(
                            children:
                                reviews.map((review) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: getHeight(context, 16),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: getWidth(context, 20),
                                          backgroundImage: NetworkImage(
                                            review.userImageUrl,
                                          ),
                                        ),
                                        SizedBox(width: getWidth(context, 10)),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: review.userName,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.75,
                                              child: CustomText(
                                                text: review.reviewText,
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                CustomText(
                                                  text:
                                                      review.rating.toString(),
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                          CustomText(
                            text: 'Add Review',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          SizedBox(height: getHeight(context, 10)),
                          Padding(
                            padding: EdgeInsets.all(getWidth(context, 16)),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Share us your review..',
                                    border: OutlineInputBorder(),
                                    alignLabelWithHint: true,
                                  ),
                                  maxLines: 5,
                                  controller: _reviewTextController,
                                ),
                                SizedBox(height: getHeight(context, 10)),
                                RatingBar(
                                  initialRating: 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(
                                    horizontal: getWidth(context, 4.0),
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _rating = rating;
                                    });
                                  },
                                  ratingWidget: RatingWidget(
                                    full: Icon(Icons.star, color: Colors.amber),
                                    half: Icon(
                                      Icons.star,
                                      color: Colors.grey.shade400,
                                    ),
                                    empty: Icon(
                                      Icons.star,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                                SizedBox(height: getHeight(context, 10)),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_reviewTextController.text.isNotEmpty &&
                                        _rating != 0) {
                                      setState(() {
                                        reviews.add(
                                          Review(
                                            id: reviews.length + 1,
                                            userId: 1,
                                            userName: 'You',
                                            userImageUrl:
                                                'https://randomuser.me/api/portraits/men/1.jpg',
                                            reviewText:
                                                _reviewTextController.text,
                                            rating: _rating,
                                          ),
                                        );
                                        _reviewTextController.clear();
                                        _rating = 0;
                                      });
                                    }
                                  },
                                  child: CustomText(
                                    text: 'Post Review',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
