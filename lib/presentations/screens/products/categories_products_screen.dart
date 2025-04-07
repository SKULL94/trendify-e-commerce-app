import 'package:Trendify/core/utils/media_query.dart';
import 'package:Trendify/data/models/cart.dart';
import 'package:Trendify/data/models/product.dart';
import 'package:Trendify/data/models/wish_list.dart';
import 'package:Trendify/presentations/providers/cart_provider.dart';
import 'package:Trendify/presentations/providers/product_provider.dart';
import 'package:Trendify/presentations/providers/wish_list_provider.dart';
import 'package:Trendify/presentations/screens/cart_wishlist/cart_screen.dart';
import 'package:Trendify/presentations/screens/cart_wishlist/wish_list_screen.dart';
import 'package:Trendify/presentations/screens/products/single_product_screen.dart';
import 'package:Trendify/presentations/screens/shared/shared.dart';
import 'package:Trendify/presentations/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.categoryName});
  final String categoryName;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> sortedProducts = [];
  List<Product> _originalProducts = [];
  bool _newArrivals = false;
  RangeValues _priceRange = const RangeValues(50, 5000);
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
    _originalProducts =
        productProvider.products
            .where((product) => product.category == widget.categoryName)
            .toList();
    sortedProducts = _originalProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WishListScreen(),
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                ),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Search for "${widget.categoryName}"',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Consumer<WishListProvider>(
            builder: (context, wishListProvider, child) {
              return Stack(
                children: [
                  sortedProducts.isEmpty
                      ? Center(
                        child: const CustomText(
                          text: 'Can not find products for your search!',
                          fontSize: 16,
                        ),
                      )
                      : GridView.builder(
                        padding: EdgeInsets.only(
                          top: getHeight(context, 60),
                          bottom: getHeight(context, 60),
                          right: getWidth(context, 5),
                          left: getWidth(context, 5),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: getHeight(context, 320),
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
                          return GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SingleProductScreen(
                                          id: item.id,
                                          isNew: item.isNew,
                                        ),
                                  ),
                                ),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  getWidth(context, 8),
                                ),
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
                                          SizedBox(
                                            width: getWidth(context, 10),
                                          ),
                                          CustomText(
                                            text:
                                                '\u{20B9} ${item.price.toStringAsFixed(2)}',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              if (!isInCart)
                                                TextButton(
                                                  child: CustomText(
                                                    text: "ADD TO CART",
                                                    color:
                                                        Colors
                                                            .redAccent
                                                            .shade200,
                                                    fontWeight: FontWeight.bold,

                                                    fontSize: 12,
                                                  ),
                                                  onPressed: () async {
                                                    final currentContext =
                                                        context;
                                                    final cartProduct =
                                                        CartProduct(
                                                          id: item.id,
                                                          title: item.title,
                                                          price: item.price,
                                                          imageUrl:
                                                              item.imageUrl,
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
                                                      Duration(
                                                        milliseconds: 500,
                                                      ),
                                                      () {
                                                        if (currentContext
                                                            .mounted) {
                                                          showCustomSnackBar(
                                                            currentContext,
                                                            status
                                                                ? "Product added to cart!"
                                                                : "Failed to add to cart!",
                                                          );
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                              if (isInCart)
                                                Container(
                                                  height: getHeight(
                                                    context,
                                                    35,
                                                  ),
                                                  width: getWidth(context, 105),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors
                                                            .redAccent
                                                            .shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          getWidth(context, 5),
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
                                                          size: getHeight(
                                                            context,
                                                            15,
                                                          ),
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
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.add,
                                                          size: getHeight(
                                                            context,
                                                            15,
                                                          ),
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
                                        final currentContext = context;
                                        if (isFavorite) {
                                          final status = await wishListProvider
                                              .removeProduct(
                                                item.id,
                                                "checkinglogin@gmail.com",
                                              );
                                          Future.delayed(
                                            Duration(milliseconds: 500),
                                            () {
                                              if (currentContext.mounted) {
                                                showCustomSnackBar(
                                                  currentContext,
                                                  status
                                                      ? "Product removed from wishlist!"
                                                      : "Failed to remove from wishlist!",
                                                );
                                              }
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
                                              if (currentContext.mounted) {
                                                showCustomSnackBar(
                                                  currentContext,
                                                  status
                                                      ? "Product added to wishlist!"
                                                      : "Failed to add to wishlist!",
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: getWidth(context, 7),
                                    top: getHeight(context, 7),
                                    child:
                                        item.isNew
                                            ? Card(
                                              color: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      getWidth(context, 16),
                                                    ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  getWidth(context, 2),
                                                ),
                                                child: const CustomText(
                                                  text: "  New  ",
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                            : Card(
                                              color: Colors.white,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: getWidth(context, 5),
                                                  ),
                                                  CustomText(
                                                    text:
                                                        item.rating.toString(),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: getHeight(
                                                      context,
                                                      16,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getWidth(context, 5),
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
                                Icon(Icons.sort, size: getHeight(context, 18)),
                                SizedBox(width: getWidth(context, 5)),
                                const CustomText(text: "Sort"),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed:
                                () => setState(() => _showFilterPanel = true),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  size: getHeight(context, 18),
                                ),
                                SizedBox(width: getWidth(context, 5)),
                                const CustomText(text: "Filter"),
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
                        onTap: () => setState(() => _showFilterPanel = false),
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              NavigationRail(
                                selectedIndex: _selectedFilterIndex,
                                onDestinationSelected:
                                    (index) => setState(
                                      () => _selectedFilterIndex = index,
                                    ),
                                labelType: NavigationRailLabelType.all,
                                destinations: [
                                  NavigationRailDestination(
                                    padding: EdgeInsets.only(
                                      left: getWidth(context, 25),
                                      right: getWidth(context, 25),
                                    ),
                                    icon: const Badge(
                                      child: Icon(Icons.attach_money),
                                    ),
                                    label: const CustomText(text: 'Price'),
                                  ),
                                  NavigationRailDestination(
                                    padding: EdgeInsets.only(
                                      left: getWidth(context, 25),
                                      right: getWidth(context, 25),
                                    ),
                                    icon: const Badge(child: Icon(Icons.star)),
                                    label: const CustomText(text: 'Rating'),
                                  ),
                                  NavigationRailDestination(
                                    padding: EdgeInsets.only(
                                      left: getWidth(context, 25),
                                      right: getWidth(context, 25),
                                    ),
                                    icon: const Badge(
                                      child: Icon(Icons.fiber_new),
                                    ),
                                    label: const CustomText(
                                      text: 'New Arrivals',
                                    ),
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
                                      const Spacer(),
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
                                                setState(
                                                  () =>
                                                      _showFilterPanel = false,
                                                );
                                              },
                                              child: const CustomText(
                                                text: 'Apply',
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed:
                                                  _isFilterApplied
                                                      ? _resetFilters
                                                      : null,
                                              child: const CustomText(
                                                text: 'Reset filters',
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
      _newArrivals = false;
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
        return _buildPriceFilter();
      case 1:
        return _buildRatingFilter();
      case 2:
        return _buildNewArrivals();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Set Price Range:',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        RangeSlider(
          values: _priceRange,
          min: 50,
          max: 5000,
          divisions: 59,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) => setState(() => _priceRange = values),
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Select Rating:',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < (_selectedRating ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => _selectedRating = index + 1),
                ),
              ),
            ),
            const CustomText(
              text:
                  'Note: Products containing rating greater than or equal to the selected rating will be shown.',
              fontSize: 14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewArrivals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Show only New Arrivals:',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        CheckboxListTile(
          value: _newArrivals,
          onChanged: (value) => setState(() => _newArrivals = value!),
          title: const CustomText(text: 'New Arrivals'),
        ),
      ],
    );
  }

  void _applyFilters() {
    setState(() {
      sortedProducts =
          _originalProducts.where((product) {
            if (_newArrivals && !product.isNew) return false;
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
          _newArrivals ||
          _priceRange != const RangeValues(50, 3000) ||
          _selectedRating != null;
      _showFilterPanel = false;
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const BeveledRectangleBorder(),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(bottom: getHeight(context, 40)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(getWidth(context, 8)),
                  child: const CustomText(text: 'SORT BY', fontSize: 16),
                ),
                const Divider(thickness: 1),
                ..._buildSortOptionsList(),
              ],
            ),
          ),
    );
  }

  List<Widget> _buildSortOptionsList() {
    return [
      _buildSortTile(
        'Price: Low to High',
        (a, b) => a.price.compareTo(b.price),
      ),
      _buildSortTile(
        'Price: High to Low',
        (a, b) => b.price.compareTo(a.price),
      ),
      _buildSortTile(
        'Rating: High to Low',
        (a, b) => b.rating.compareTo(a.rating),
      ),
      _buildSortTile(
        'Most Popular',
        (a, b) => b.ratingCount.compareTo(a.ratingCount),
      ),
      _buildSortTile(
        'Alphabetical (A to Z)',
        (a, b) => a.title.compareTo(b.title),
      ),
      _buildSortTile(
        'Alphabetical (Z to A)',
        (a, b) => b.title.compareTo(a.title),
      ),
    ];
  }

  ListTile _buildSortTile(
    String title,
    int Function(Product, Product) compareFn,
  ) {
    return ListTile(
      title: CustomText(text: title, fontSize: 16),
      onTap: () {
        setState(() => sortedProducts.sort(compareFn));
        Navigator.pop(context);
      },
    );
  }
}
