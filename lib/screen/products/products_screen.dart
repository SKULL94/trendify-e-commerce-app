import 'package:Trendify/models/cart.dart';
import 'package:Trendify/models/wish_list.dart';
import 'package:Trendify/providers/cart_provider.dart';
import 'package:Trendify/providers/wish_list_provider.dart';
import 'package:Trendify/screen/login_register/profile.dart';
import 'package:Trendify/screen/products/categories_products_screen.dart';
import 'package:Trendify/screen/products/searched_products_screen.dart';
import 'package:Trendify/screen/products/single_product_screen.dart';
import 'package:Trendify/screen/shared/shared.dart';
import 'package:Trendify/utilis/custom_text.dart';
import 'package:Trendify/utilis/media_query.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import '../../providers/product_provider.dart';

class ProductsScreen extends StatefulWidget {
  final dynamic token;
  const ProductsScreen({super.key, this.token});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late String email;

  @override
  void initState() {
    super.initState();
    email = 'ZEESHAN';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Consumer<WishListProvider>(
          builder: (context, wishListProvider, child) {
            return Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final products = productProvider.newlyAddedProducts;
                return Scaffold(
                  appBar: AppBar(
                    surfaceTintColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    title: CustomText(text: "Welcome,\nZeeshan", fontSize: 20),
                    actions: [
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const ProfileScreen(email: 'email'),
                              ),
                            ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: getWidth(context, 20),
                          child: Image(
                            image: const AssetImage('assets/trend.png'),
                            width: getWidth(context, 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body:
                      productProvider.products.isEmpty
                          ? Center(child: loadingAnimation(context))
                          : CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: _searchWidget(productProvider, context),
                              ),
                              SliverToBoxAdapter(
                                child: _categoryWidget(context),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _popularProduct(
                                      productProvider,
                                      wishListProvider,
                                      cartProvider,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getWidth(context, 22),
                                      ),
                                      child: const CustomText(
                                        text: 'Newly Added',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  ctx,
                                  index,
                                ) {
                                  final product = products[index];
                                  final isFavorite = wishListProvider
                                      .isFavorite(product.id);
                                  final isInCart = cartProvider.isInCart(
                                    product.id,
                                  );
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: getHeight(context, 8),
                                      left: getWidth(context, 8),
                                      right: getWidth(context, 8),
                                    ),
                                    child: SizedBox(
                                      height: getHeight(context, 200),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap:
                                                () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            SingleProductScreen(
                                                              id: product.id,
                                                              isNew:
                                                                  product.isNew,
                                                            ),
                                                  ),
                                                ),
                                            child: Card(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      getWidth(context, 8),
                                                    ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right: getWidth(
                                                        context,
                                                        5,
                                                      ),
                                                      top: getHeight(
                                                        context,
                                                        10,
                                                      ),
                                                      bottom: getHeight(
                                                        context,
                                                        10,
                                                      ),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          product.imageUrl,
                                                      fit: BoxFit.cover,
                                                      height: getHeight(
                                                        context,
                                                        140,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getWidth(
                                                      context,
                                                      180,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                top: getHeight(
                                                                  context,
                                                                  40,
                                                                ),
                                                                bottom:
                                                                    getHeight(
                                                                      context,
                                                                      4,
                                                                    ),
                                                              ),
                                                          child: CustomText(
                                                            text: product.title,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: getHeight(
                                                            context,
                                                            4,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: List.generate(
                                                                5,
                                                                (index) => Icon(
                                                                  index <
                                                                          product
                                                                              .rating
                                                                      ? Icons
                                                                          .star
                                                                      : Icons
                                                                          .star_border,
                                                                  color:
                                                                      index <
                                                                              product.rating
                                                                          ? Colors
                                                                              .yellow
                                                                          : Colors
                                                                              .grey,
                                                                ),
                                                              ),
                                                            ),
                                                            CustomText(
                                                              text:
                                                                  '(${product.ratingCount.toString()})',
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: getHeight(
                                                            context,
                                                            4,
                                                          ),
                                                        ),
                                                        CustomText(
                                                          text:
                                                              ' \u{20B9} ${product.price.toStringAsFixed(2)}',
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
                                                          width: getWidth(
                                                            context,
                                                            115,
                                                          ),
                                                          height: getHeight(
                                                            context,
                                                            35,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  getWidth(
                                                                    context,
                                                                    5,
                                                                  ),
                                                                ),
                                                          ),
                                                          child:
                                                              isInCart
                                                                  ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      IconButton(
                                                                        icon: Icon(
                                                                          Icons
                                                                              .remove,
                                                                          size: getHeight(
                                                                            context,
                                                                            15,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        onPressed:
                                                                            () => cartProvider.decreaseQuantity(
                                                                              product.id,
                                                                            ),
                                                                      ),
                                                                      CustomText(
                                                                        text:
                                                                            '${cartProvider.getQuantity(product.id)}',
                                                                        color:
                                                                            Colors.white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                      IconButton(
                                                                        icon: Icon(
                                                                          Icons
                                                                              .add,
                                                                          size: getHeight(
                                                                            context,
                                                                            15,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        onPressed:
                                                                            () => cartProvider.increaseQuantity(
                                                                              product.id,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                  : TextButton(
                                                                    onPressed: () async {
                                                                      final cartProduct = CartProduct(
                                                                        id:
                                                                            product.id,
                                                                        title:
                                                                            product.title,
                                                                        price:
                                                                            product.price,
                                                                        imageUrl:
                                                                            product.imageUrl,
                                                                        description:
                                                                            product.description,
                                                                        rating:
                                                                            product.rating,
                                                                      );
                                                                      final status =
                                                                          await cartProvider.addProduct(
                                                                            cartProduct,
                                                                          );
                                                                      Future.delayed(
                                                                        const Duration(
                                                                          milliseconds:
                                                                              500,
                                                                        ),
                                                                        () => showCustomSnackBar(
                                                                          context,
                                                                          status
                                                                              ? "Product added to cart!"
                                                                              : "Failed to add to cart!",
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: const CustomText(
                                                                      text:
                                                                          "ADD TO CART",
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: getHeight(context, 10),
                                            left: getWidth(context, 10),
                                            child: Card(
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
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: getWidth(context, 3),
                                            child: IconButton(
                                              icon: Icon(
                                                size: getHeight(context, 23),
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color:
                                                    isFavorite
                                                        ? Colors.red
                                                        : null,
                                              ),
                                              onPressed: () async {
                                                if (isFavorite) {
                                                  final status =
                                                      await wishListProvider
                                                          .removeProduct(
                                                            product.id,
                                                            "checkinglogin@gmail.com",
                                                          );
                                                  Future.delayed(
                                                    const Duration(
                                                      milliseconds: 500,
                                                    ),
                                                    () => showCustomSnackBar(
                                                      context,
                                                      status
                                                          ? "Product removed from wishlist!"
                                                          : "Failed to remove from wishlist!",
                                                    ),
                                                  );
                                                } else {
                                                  final wishlistProduct =
                                                      WishListItems(
                                                        id: product.id,
                                                        title: product.title,
                                                        price: product.price,
                                                        imageUrl:
                                                            product.imageUrl,
                                                        description:
                                                            product.description,
                                                        rating: product.rating,
                                                      );
                                                  final status =
                                                      await wishListProvider
                                                          .addProduct(
                                                            wishlistProduct,
                                                            "checkinglogin@gmail.com",
                                                          );
                                                  Future.delayed(
                                                    const Duration(
                                                      milliseconds: 500,
                                                    ),
                                                    () => showCustomSnackBar(
                                                      context,
                                                      status
                                                          ? "Product added to wishlist!"
                                                          : "Failed to add to wishlist!",
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }, childCount: products.length),
                              ),
                            ],
                          ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _popularProduct(
    ProductProvider prodProvider,
    WishListProvider wishListProvider,
    CartProvider cartProvider,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getWidth(context, 18)),
      height: getHeight(context, 320),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Popular products',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
          SizedBox(height: getHeight(context, 10)),
          SizedBox(
            height: getHeight(context, 260),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    prodProvider.popularProducts.map((product) {
                      final isFavorite = wishListProvider.isFavorite(
                        product.id,
                      );
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        SingleProductScreen(id: product.id),
                              ),
                            ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getWidth(context, 5),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getWidth(context, 16),
                                  vertical: getHeight(context, 16),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: getWidth(context, 16),
                                        vertical: getHeight(context, 16),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: product.imageUrl,
                                        fit: BoxFit.fitWidth,
                                        height: getHeight(context, 120),
                                      ),
                                    ),
                                    CustomText(
                                      text: product.title,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: getHeight(context, 3)),
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              index < product.rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color:
                                                  index < product.rating
                                                      ? Colors.yellow
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        CustomText(
                                          text:
                                              '(${product.ratingCount.toString()})',
                                        ),
                                      ],
                                    ),
                                    CustomText(
                                      text:
                                          '\u{20B9} ${product.price.toStringAsFixed(2)}',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
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
                                            product.id,
                                            "checkinglogin@gmail.com",
                                          );
                                      Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () => showCustomSnackBar(
                                          context,
                                          status
                                              ? "Product removed from wishlist!"
                                              : "Failed to remove from wishlist!",
                                        ),
                                      );
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
                                      Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () => showCustomSnackBar(
                                          context,
                                          status
                                              ? "Product added to wishlist!"
                                              : "Failed to add to wishlist!",
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchWidget(ProductProvider productProvider, BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(getWidth(context, 16)),
      child: Form(
        child: Container(
          height: getHeight(context, 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getWidth(context, 10)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: getWidth(context, 16)),
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search for a product',
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? 'Enter something for search'
                                : null,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (controller.text.isEmpty) {
                    showCustomSnackBar(context, 'Enter something for search');
                    return;
                  }
                  productProvider.searchProduct(controller.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SearchedProductsScreen(
                            searchQuery: controller.text,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<CategoriesList> _categoriesList = [
    CategoriesList(
      categoryName: 'clothes',
      categoryImageUrl:
          'https://hhatffzhvdmybvizyvhw.supabase.co/storage/v1/object/public/flut-images/category/clothes_category.jpg',
    ),
    CategoriesList(
      categoryName: 'accessories',
      categoryImageUrl:
          'https://hhatffzhvdmybvizyvhw.supabase.co/storage/v1/object/public/flut-images/category/accessories_category.jpg',
    ),
    CategoriesList(
      categoryName: 'electronics',
      categoryImageUrl:
          'https://hhatffzhvdmybvizyvhw.supabase.co/storage/v1/object/public/flut-images/category/electronics_category.jpg',
    ),
    CategoriesList(
      categoryName: 'footwear',
      categoryImageUrl:
          'https://hhatffzhvdmybvizyvhw.supabase.co/storage/v1/object/public/flut-images/category/shoe_category.jpg',
    ),
  ];

  Widget _categoryWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20)),
      height: getHeight(context, 170),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Categories',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    _categoriesList
                        .map(
                          (category) => InkWell(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CategoryProductsScreen(
                                          categoryName: category.categoryName,
                                        ),
                                  ),
                                ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: getWidth(context, 8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: category.categoryImageUrl,
                                fit: BoxFit.cover,
                                height: getHeight(context, 110),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget loadingAnimation(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: getHeight(context, 400),
        child: rive.RiveAnimation.asset(
          'assets/earth_loading.riv',
          stateMachines: ['Loading Final - State Machine 1'],
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
      const CustomText(
        text: 'Trendify',
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      const CustomText(
        text: 'Shop Smart, Stay Trendy',
        fontSize: 18,
        color: Colors.blueGrey,
        fontWeight: FontWeight.w700,
      ),
    ],
  );
}

class CategoriesList {
  final String categoryName;
  final String categoryImageUrl;

  CategoriesList({required this.categoryName, required this.categoryImageUrl});
}
