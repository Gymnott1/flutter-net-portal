// <start of features/shop/screens/shop_screen.dart>
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_assets.dart';
import 'package:net_app/core/utils/app_constants.dart';
import 'package:net_app/core/widgets/app_logo.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart';
import 'package:net_app/data/models/product_model.dart';
import 'package:net_app/data/models/cart_item_model.dart'; // New import
import 'package:net_app/features/home/widgets/ad_slider.dart';
import 'package:net_app/features/shop/widgets/product_list_item_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final MockDataSource _dataSource = MockDataSource();
  late List<ProductModel> _allProducts;
  late List<ProductModel> _displayedProducts;
  late List<String> _shopAds;

  // State for search and filter
  String _searchQuery = "";
  final Set<ProductCategory> _selectedFilters = {};
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // State for cart
  final List<CartItemModel> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _allProducts = _dataSource.getAllShopProducts(); // Get all products once
    _displayedProducts = List.from(_allProducts);
    _shopAds = _dataSource.getShopAdImages();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch() {
    List<ProductModel> tempProducts = List.from(_allProducts);

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filters
    if (_selectedFilters.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => _selectedFilters.contains(product.category))
          .toList();
    }
    setState(() {
      _displayedProducts = tempProducts;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFiltersAndSearch();
    });
  }
  
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Clears search query and triggers listener
      }
    });
  }


  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use a StatefulWidget here to manage the temporary state of checkboxes
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Products'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ProductCategory.values.map((category) {
                    if (category == ProductCategory.other && !_allProducts.any((p) => p.category == ProductCategory.other)) {
                         return const SizedBox.shrink(); // Don't show 'Other' if no products have it
                    }
                    return CheckboxListTile(
                      title: Text(productCategoryToString(category)),
                      value: _selectedFilters.contains(category),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedFilters.add(category);
                          } else {
                            _selectedFilters.remove(category);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Clear All'),
                  onPressed: () {
                    setDialogState(() {
                      _selectedFilters.clear();
                    });
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Apply'),
                  onPressed: () {
                    _applyFiltersAndSearch(); // Apply filters to the main list
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addToCart(ProductModel product) {
    setState(() {
      final existingItemIndex =
          _cartItems.indexWhere((item) => item.product.id == product.id);
      if (existingItemIndex != -1) {
        if (_cartItems[existingItemIndex].quantity < product.stock) {
          _cartItems[existingItemIndex].quantity++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Max stock reached for ${product.name}')),
          );
          return;
        }
      } else {
         if (product.stock > 0) {
            _cartItems.add(CartItemModel(product: product, quantity: 1));
         } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} is out of stock')),
            );
            return;
         }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart!'),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.successLight,
        ),
      );
    });
  }


  Widget _buildSectionTitle(BuildContext context, String title,
      {VoidCallback? onMore, Widget? trailing}) { // Added trailing
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
          left: AppDimensions.md,
          right: AppDimensions.xs,
          top: AppDimensions.lg,
          bottom: AppDimensions.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: theme.textTheme.headlineSmall),
          if (trailing != null) trailing, // Display trailing if provided
          if (onMore != null && trailing == null) // Display onMore only if no trailing
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMore,
              tooltip: 'More options',
            )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Separate featured and top products from the _displayedProducts list
    final displayedFeaturedProducts = _displayedProducts.where((p) => p.isFeatured).toList();
    final displayedTopProducts = _displayedProducts.where((p) => !p.isFeatured).toList();


    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : Colors.grey.shade200,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.iconTheme?.color),
          onPressed: () => Navigator.canPop(context) ? Navigator.pop(context) : Navigator.pushReplacementNamed(context, AppRouter.mainRoute),
        ),
        title: _isSearching 
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: theme.appBarTheme.iconTheme?.color?.withOpacity(0.7)),
                ),
                style: TextStyle(color: theme.appBarTheme.iconTheme?.color, fontSize: 16),
              )
            : const AppLogo(height: 30),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: theme.appBarTheme.iconTheme?.color),
            tooltip: _isSearching ? 'Close Search' : 'Search Products',
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Badge( // Cart Badge
                label: Text(_cartItems.length.toString()),
                isLabelVisible: _cartItems.isNotEmpty,
                child: Icon(Icons.shopping_cart_outlined, color: theme.appBarTheme.iconTheme?.color),
            ),
            tooltip: 'View Cart',
            onPressed: () {
                Navigator.of(context).pushNamed(AppRouter.cartRoute, arguments: _cartItems).then((_) {
                    // If cart screen could modify cart, re-fetch or update state here
                    // For now, our CartScreen is self-contained for modifications
                    // but if it returned the modified list, we'd update _cartItems.
                    // This is a good place for a more robust state management solution.
                    setState(() {}); // Rebuild to update badge if cart items changed on CartScreen
                });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.menu_open_rounded, color: theme.appBarTheme.iconTheme?.color),
            onSelected: (value) {
              if (value == 'hotspot') Navigator.of(context).pushNamed(AppRouter.loginRoute, arguments: {'targetRoute': AppRouter.homeRoute});
              if (value == 'homenet') Navigator.of(context).pushNamed(AppRouter.loginRoute, arguments: {'targetRoute': AppRouter.homeInternetRoute});
              if (value == 'notifications') Navigator.of(context).pushNamed(AppRouter.notificationsRoute);
              if (value == 'settings') Navigator.of(context).pushNamed(AppRouter.settingsRoute);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'hotspot', child: ListTile(leading: Icon(Icons.wifi_tethering), title: Text('Hotspot'))),
              PopupMenuItem<String>(value: 'homenet', child: ListTile(leading: Icon(Icons.wifi), title: Text('HomeNet'))),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(value: 'notifications', child: ListTile(leading: Icon(Icons.notifications_none_outlined), title: Text('Notifications'))),
              const PopupMenuItem<String>(value: 'settings', child: ListTile(leading: Icon(Icons.settings_outlined), title: Text('Settings'))),
            ],
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: theme.colorScheme.primary.withOpacity(isDark ? 0.3 : 0.15),
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm, horizontal: AppDimensions.md),
              child: Center(
                child: Text(
                  "Happy New Year ${AppConstants.copyrightYear}! Pay on delivery! Free delivery!",
                  style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (_shopAds.isNotEmpty && !_isSearching) // Hide ads when searching
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppDimensions.md, bottom: AppDimensions.xs),
                child: AdSliderWidget(adImagePaths: _shopAds),
              ),
            ),
          if (!_isSearching) // Hide delivery banner when searching
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm, horizontal: AppDimensions.md),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0,2))]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_shipping_outlined, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: AppDimensions.sm),
                    Text("Reliable, Secure & Free Deliveries", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),

          // Filter Button
           SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   if (_selectedFilters.isNotEmpty)
                    ActionChip(
                        avatar: const Icon(Icons.clear, size: 16),
                        label: Text("Clear Filters (${_selectedFilters.length})"),
                        onPressed: (){
                             setState(() {
                                _selectedFilters.clear();
                                _applyFiltersAndSearch();
                             });
                        }
                    ),
                    const SizedBox(width: AppDimensions.sm),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.filter_list_alt, size: 20),
                    label: const Text("Filter"),
                    onPressed: _showFilterDialog,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.xs),
                        textStyle: theme.textTheme.labelMedium
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (displayedFeaturedProducts.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _buildSectionTitle(context, "Featured products"),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 290, // Increased height slightly for "Add to Cart"
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md - AppDimensions.xs),
                  itemCount: displayedFeaturedProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayedFeaturedProducts[index];
                    return Container(
                      width: 180,
                      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
                      child: ProductListItemWidget(
                          product: product,
                          isFeatured: true,
                          onOrderNow: () => _addToCart(product)), // Changed to _addToCart
                    );
                  },
                ),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: _buildSectionTitle(context, _searchQuery.isEmpty && _selectedFilters.isEmpty ? "Top products" : "Search Results (${displayedTopProducts.length})"),
          ),
          if (displayedTopProducts.isEmpty)
             SliverFillRemaining( // Use SliverFillRemaining for empty state
                child: Center(
                    child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        const Icon(Icons.search_off_rounded, size: 60, color: AppColors.textTertiaryLight),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                            "No products found matching your criteria.",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge,
                        ),
                        if(_searchQuery.isNotEmpty || _selectedFilters.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.only(top: AppDimensions.sm),
                                child: TextButton(
                                    onPressed: (){
                                        setState(() {
                                            _searchController.clear(); // this will trigger listener
                                            _selectedFilters.clear();
                                            _applyFiltersAndSearch();
                                        });
                                    },
                                    child: const Text("Clear Search & Filters")
                                ),
                            )
                        ],
                    ),
                    ),
                ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppDimensions.md,
                  crossAxisSpacing: AppDimensions.md,
                  childAspectRatio: 0.62, // Adjusted for "Add to Cart" button
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = displayedTopProducts[index];
                    return ProductListItemWidget(
                        product: product,
                        onOrderNow: () => _addToCart(product)); // Changed to _addToCart
                  },
                  childCount: displayedTopProducts.length,
                ),
              ),
            ),
          if (!_isSearching) // Hide footer when searching to give more space to results
            SliverToBoxAdapter(child: ShopFooterWidget(dataSource: _dataSource)),
        ],
      ),
    );
  }
}

// ShopFooterWidget (Keep the mobile-friendly version from the previous response)
class ShopFooterWidget extends StatelessWidget { /* ... as previously defined ... */ 
  final MockDataSource dataSource;
  const ShopFooterWidget({super.key, required this.dataSource});

  Widget _buildFooterLink(BuildContext context,
      {IconData? icon, required String text, VoidCallback? onTap, bool isBold = false}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs / 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              FaIcon(icon, color: Colors.white70, size: 16),
              const SizedBox(width: AppDimensions.sm),
            ],
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppStoreBadges(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: AppDimensions.xs),
            child: Image.asset(AppAssets.googlePlayBadge, height: 40, fit: BoxFit.contain),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: AppDimensions.xs),
            child: Image.asset(AppAssets.appStoreBadge, height: 40, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white70), onPressed: () {/*TODO*/}),
        IconButton(icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.white70), onPressed: () {/*TODO*/}),
        IconButton(icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white70), onPressed: () {/*TODO*/}),
        IconButton(icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white70), onPressed: () {/*TODO*/}),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: const Color(0xFF2A2A2A),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.lg, horizontal: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppLogo(height: 40),
          const SizedBox(height: AppDimensions.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Text(
              dataSource.shopPurposeStatement,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text( "CONTACT US", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold), ),
          const SizedBox(height: AppDimensions.xs),
          _buildFooterLink(context, icon: FontAwesomeIcons.phone, text: "${dataSource.shopContactPhone1} / ${dataSource.shopContactPhone2}", onTap: () {}),
          _buildFooterLink(context, icon: FontAwesomeIcons.envelope, text: dataSource.shopContactEmail, onTap: () {}),
          _buildFooterLink(context, icon: FontAwesomeIcons.mapMarkerAlt, text: dataSource.shopAddress),
          const SizedBox(height: AppDimensions.lg),
          Text( "DOWNLOAD OUR APPS", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold), ),
          const SizedBox(height: AppDimensions.xs),
           Padding( padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg), child: _buildAppStoreBadges(context), ),
          const SizedBox(height: AppDimensions.lg),
           _buildSocialMediaIcons(context),
          const SizedBox(height: AppDimensions.md),
          const Divider(color: Colors.white24, height: AppDimensions.lg),
          Text( dataSource.shopCopyright, textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60), ),
        ],
      ),
    );
  }
}

// <end of features/shop/screens/shop_screen.dart>