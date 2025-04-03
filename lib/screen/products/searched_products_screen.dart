import 'package:Trendify/models/cart.dart';
import 'package:Trendify/models/product.dart';
import 'package:Trendify/models/wish_list.dart';
import 'package:Trendify/providers/cart_provider.dart';
import 'package:Trendify/providers/product_provider.dart';
import 'package:Trendify/providers/wish_list_provider.dart';
import 'package:Trendify/screen/cart_wishlist/cart_screen.dart';
import 'package:Trendify/screen/cart_wishlist/wish_list_screen.dart';
import 'package:Trendify/screen/products/products_screen.dart';
import 'package:Trendify/screen/shared/shared.dart';
import 'package:Trendify/utilis/custom_text.dart';
import 'package:Trendify/utilis/media_query.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedProductsScreen extends StatefulWidget {
  const SearchedProductsScreen({super.key, required this.searchQuery});
  final String searchQuery;

  @override
  State<SearchedProductsScreen> createState() => _SearchedProductsScreenState();
}

class _SearchedProductsScreenState extends State<SearchedProductsScreen> {
  List<Product> sortedProducts = [];
  List<Product> _originalProducts = [];
  String? _selectedCategory;
  RangeValues _priceRange = const RangeValues(50, 30000);
  bool _showFilterPanel = false;
  int _selectedFilterIndex = 0;
  int? _selectedRating;
  bool _isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    _originalProducts = productProvider.searchProducts;
    sortedProducts = _originalProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishListScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Search for "${widget.searchQuery}"',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Consumer<WishListProvider>(
            builder: (context, wishListProvider, child) {
              return sortedProducts.isEmpty
                  ? Center(child: loadingAnimation(context))
                  : Stack(
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.only(
                          top: getHeight(context, 60),
                          bottom: getHeight(context, 60),
                          right: getWidth(context, 5),
                          left: getWidth(context, 5),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: getHeight(context, 330),
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemCount: sortedProducts.length,
                        itemBuilder: (ctx, index) {
                          final item = sortedProducts[index];
                          final isFavorite = wishListProvider.isFavorite(
                            item.id,
                          );
                          final isInCart = cartProvider.isInCart(item.id);
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(
                                        getWidth(context, 8),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: item.imageUrl,
                                        fit: BoxFit.fitWidth,
                                        width: getWidth(context, 140),
                                        height: getHeight(context, 200),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        CustomText(
                                          text: item.title,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(height: getHeight(context, 5)),
                                        CustomText(
                                          text:
                                              '\u{20B9} ${item.price.toStringAsFixed(2)}',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(height: getHeight(context, 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            if (!isInCart)
                                              TextButton(
                                                child: CustomText(
                                                  text: "ADD TO CART",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors.redAccent.shade200,
                                                ),
                                                onPressed: () async {
                                                  final cartProduct =
                                                      CartProduct(
                                                        id: item.id,
                                                        title: item.title,
                                                        price: item.price,
                                                        imageUrl: item.imageUrl,
                                                        description:
                                                            item.description,
                                                        rating: item.rating,
                                                      );

                                                  final status =
                                                      await cartProvider
                                                          .addProduct(
                                                            cartProduct,
                                                          );
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
                                                },
                                              ),
                                            if (isInCart)
                                              Container(
                                                height: getHeight(context, 35),
                                                width: getWidth(context, 105),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Colors.redAccent.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.remove,
                                                        size: 15,
                                                        color: Colors.white,
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
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.add,
                                                        size: 15,
                                                        color: Colors.white,
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                    onPressed: () async {
                                      if (isFavorite) {
                                        final status = await wishListProvider
                                            .removeProduct(
                                              item.id,
                                              "checkinglogin@gmail.com",
                                            );
                                        Future.delayed(
                                          Duration(milliseconds: 500),
                                          () {
                                            showCustomSnackBar(
                                              context,
                                              status
                                                  ? "Product removed from wishlist!"
                                                  : "Failed to remove from wishlist!",
                                            );
                                          },
                                        );
                                      } else {
                                        final wishlistProduct = WishListItems(
                                          id: item.id,
                                          title: item.title,
                                          price: item.price,
                                          imageUrl: item.imageUrl,
                                          description: item.description,
                                          rating: item.rating,
                                        );

                                        final status = await wishListProvider
                                            .addProduct(
                                              wishlistProduct,
                                              "checkinglogin@gmail.com",
                                            );
                                        Future.delayed(
                                          Duration(milliseconds: 500),
                                          () {
                                            showCustomSnackBar(
                                              context,
                                              status
                                                  ? "Product added to wishlist!"
                                                  : "Failed to add to wishlist!",
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 7,
                                  top: 7,
                                  child: Card(
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        SizedBox(width: getWidth(context, 5)),
                                        CustomText(
                                          text: item.rating.toString(),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 16,
                                        ),
                                        SizedBox(width: getWidth(context, 5)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: getWidth(context, 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => _showSortOptions(context),
                                child: Row(
                                  children: [
                                    Icon(Icons.sort, size: 18),
                                    SizedBox(width: getWidth(context, 5)),
                                    CustomText(text: "Sort", fontSize: 14),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showFilterPanel = true;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.filter_list, size: 18),
                                    SizedBox(width: getWidth(context, 5)),
                                    CustomText(text: "Filter", fontSize: 14),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showFilterPanel)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showFilterPanel = false;
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  NavigationRail(
                                    selectedIndex: _selectedFilterIndex,
                                    onDestinationSelected: (index) {
                                      setState(() {
                                        _selectedFilterIndex = index;
                                      });
                                    },
                                    labelType: NavigationRailLabelType.all,
                                    destinations: const [
                                      NavigationRailDestination(
                                        padding: EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                        ),
                                        icon: Icon(Icons.category),
                                        label: Text('Category'),
                                      ),
                                      NavigationRailDestination(
                                        padding: EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                        ),
                                        icon: Icon(Icons.attach_money),
                                        label: Text('Price'),
                                      ),
                                      NavigationRailDestination(
                                        padding: EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                        ),
                                        icon: Icon(Icons.star),
                                        label: Text('Rating'),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        getWidth(context, 16),
                                      ),
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          _buildFilterOptions(),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: getHeight(context, 50),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _applyFilters();
                                                    setState(() {
                                                      _showFilterPanel = false;
                                                    });
                                                  },
                                                  child: CustomText(
                                                    text: 'Apply',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed:
                                                      _isFilterApplied
                                                          ? () {
                                                            _resetFilters();
                                                          }
                                                          : null,
                                                  child: CustomText(
                                                    text: 'Reset filters',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
            },
          );
        },
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = null;
      _priceRange = const RangeValues(50, 3000);
      _selectedRating = null;

      sortedProducts = List.from(_originalProducts);
      _isFilterApplied = false;

      _showFilterPanel = false;
    });
  }

  Widget _buildFilterOptions() {
    switch (_selectedFilterIndex) {
      case 0:
        return _buildCategoryFilter();
      case 1:
        return _buildPriceFilter();
      case 2:
        return _buildRatingFilter();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Select Category:',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: getHeight(context, 12)),
        ...['Footwear', 'Clothes', 'Accessories', 'Electronics'].map((
          category,
        ) {
          return CheckboxListTile(
            value: _selectedCategory == category,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value! ? category : null;
              });
            },
            title: CustomText(text: category, fontSize: 16),
          );
        }),
      ],
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Set Price Range:',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        RangeSlider(
          values: _priceRange,
          min: 50,
          max: 30000,
          divisions: 59,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Select Rating:',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < (_selectedRating ?? 0) ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _selectedRating = index + 1;
                });
              },
            );
          }),
        ),
      ],
    );
  }

  void _applyFilters() {
    setState(() {
      sortedProducts =
          _originalProducts.where((product) {
            if (_selectedCategory != null &&
                product.category != _selectedCategory!.toLowerCase()) {
              return false;
            }
            if (product.price < _priceRange.start ||
                product.price > _priceRange.end) {
              return false;
            }
            if (_selectedRating != null && product.rating < _selectedRating!) {
              return false;
            }
            return true;
          }).toList();

      _isFilterApplied =
          _selectedCategory != null ||
          _priceRange != const RangeValues(50, 3000) ||
          _selectedRating != null;

      _showFilterPanel = false;
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: BeveledRectangleBorder(),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: getHeight(context, 40)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(getWidth(context, 8)),
                child: CustomText(text: 'SORT BY', fontSize: 16),
              ),
              Divider(thickness: 1),
              ListTile(
                title: CustomText(text: 'Price: Low to High', fontSize: 16),
                onTap: () {
                  setState(() {
                    sortedProducts.sort((a, b) => a.price.compareTo(b.price));
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: CustomText(text: 'Price: High to Low', fontSize: 16),
                onTap: () {
                  setState(() {
                    sortedProducts.sort((a, b) => b.price.compareTo(a.price));
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: CustomText(text: 'Rating: High to Low', fontSize: 16),
                onTap: () {
                  setState(() {
                    sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: CustomText(text: 'Most Popular', fontSize: 16),
                onTap: () {
                  setState(() {
                    sortedProducts.sort(
                      (a, b) => b.ratingCount.compareTo(a.ratingCount),
                    );
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: CustomText(text: 'Alphabetical (A to Z)', fontSize: 16),
                onTap: () {
                  setState(() {
                    sortedProducts.sort((a, b) => a.title.compareTo(b.title));
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: CustomText(text: 'Alphabetical (Z to A)', fontSize: 16),
                onTap: () {
                  setState(() {
                    sortedProducts.sort((a, b) => b.title.compareTo(a.title));
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
