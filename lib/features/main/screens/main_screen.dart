// <start of features/main/screens/main_screen.dart>
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_constants.dart';
import 'package:net_app/core/widgets/app_logo.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart';
import 'package:net_app/data/models/package_model.dart';
import 'package:net_app/data/models/home_internet_package_model.dart'; // New Import
import 'package:net_app/data/models/product_model.dart'; // New Import
import 'package:net_app/features/home/widgets/ad_slider.dart';
import 'package:net_app/features/home/widgets/package_list_item.dart';
import 'package:net_app/features/home_internet/widgets/home_internet_package_list.dart'; // New Import
import 'package:net_app/features/main/widgets/service_card.dart';
import 'package:net_app/features/shop/widgets/product_list_item_widget.dart'; // New Import

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MockDataSource _dataSource = MockDataSource();
  late List<String> _adImages;
  
  // For featured offers
  late List<PackageModel> _featuredHotspotPackages;
  late List<HomeInternetPackageModel> _featuredHomeNetPlans;
  late List<ProductModel> _featuredShopProducts;


  @override
  void initState() {
    super.initState();
    _adImages = _dataSource.getAdImages();
    _loadFeaturedOffers();
  }

  void _loadFeaturedOffers() {
    // Hotspot: take top 2-3 favorites or just top ones by price
    final allHotspot = _dataSource.getPackages();
    _featuredHotspotPackages = allHotspot.take(2).toList(); // Take first 2 sorted by favorite then price

    // HomeNet: take first 2 (or add an isFeatured flag to model)
    final allHomeNet = _dataSource.getHomeInternetPackages();
    _featuredHomeNetPlans = allHomeNet.take(2).toList();

    // Shop: use the existing featured logic
    _featuredShopProducts = _dataSource.getShopProducts(featuredOnly: true).take(4).toList(); // Take up to 4
  }

  // Dummy toggle favorite for the featured hotspot package on main screen
  void _toggleHotspotFavorite(String packageId) {
     final packageIndex = _featuredHotspotPackages.indexWhere((p) => p.id == packageId);
     if (packageIndex != -1) {
        // This is a superficial toggle for the UI on MainScreen only.
        // It doesn't persist or affect the actual data source's favorite state for HomeScreen.
        // To make it affect the global state, you'd call _dataSource.toggleFavoriteStatus(packageId)
        // and then reload data or use a more robust state management.
        setState(() {
            _featuredHotspotPackages[packageIndex].isFavorite = !_featuredHotspotPackages[packageIndex].isFavorite;
        });
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: Text(
                _featuredHotspotPackages[packageIndex].isFavorite ?
                "'${_featuredHotspotPackages[packageIndex].name}' added to favorites (preview)." :
                "'${_featuredHotspotPackages[packageIndex].name}' removed from favorites (preview)."
            ),
            duration: const Duration(seconds: 2),
            ),
        );
     }
  }

  Widget _buildOfferSectionTitle(BuildContext context, String title, VoidCallback onViewAll) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        TextButton(
          onPressed: onViewAll,
          child: Text('View All', style: TextStyle(color: theme.colorScheme.primary)),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const AppLogo(height: 36),
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        // Add Settings/Notifications here if desired globally, or keep them within sections
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to ${AppConstants.appName}!',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              AppConstants.slogan,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            const SizedBox(height: AppDimensions.md),
            if (_adImages.isNotEmpty) AdSliderWidget(adImagePaths: _adImages),
            const SizedBox(height: AppDimensions.lg),
            Text(
              'Our Services',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ServiceCard(
                  title: 'Hotspot',
                  icon: Icons.wifi_tethering,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.loginRoute,
                      arguments: {'targetRoute': AppRouter.homeRoute},
                    );
                  },
                ),
                ServiceCard(
                  title: 'HomeNet',
                  icon: Icons.wifi,
                  iconColor: Colors.green.shade600,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.loginRoute,
                      arguments: {'targetRoute': AppRouter.homeInternetRoute},
                    );
                  },
                ),
                ServiceCard(
                  title: 'Shop',
                  icon: Icons.shopping_bag_outlined,
                  iconColor: Colors.orange.shade700,
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRouter.shopRoute);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),

            // --- Today's Top Offers Section ---
            Text(
              "Today's Top Offers",
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 22), // Slightly smaller than main welcome
            ),
            const SizedBox(height: AppDimensions.md),

            // Featured Hotspot Offers
            if (_featuredHotspotPackages.isNotEmpty) ...[
              _buildOfferSectionTitle(context, 'Hotspot Deals', () {
                Navigator.of(context).pushNamed(AppRouter.loginRoute, arguments: {'targetRoute': AppRouter.homeRoute});
              }),
              const SizedBox(height: AppDimensions.xs),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _featuredHotspotPackages.length,
                itemBuilder: (context, index) {
                  final package = _featuredHotspotPackages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: PackageListItem(
                      package: package,
                      onToggleFavorite: () => _toggleHotspotFavorite(package.id),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimensions.lg),
            ],

            // Featured HomeNet Offers
            if (_featuredHomeNetPlans.isNotEmpty) ...[
              _buildOfferSectionTitle(context, 'Home Fibre Offers', () {
                 Navigator.of(context).pushNamed(AppRouter.loginRoute, arguments: {'targetRoute': AppRouter.homeInternetRoute});
              }),
              const SizedBox(height: AppDimensions.xs),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _featuredHomeNetPlans.length,
                itemBuilder: (context, index) {
                  final plan = _featuredHomeNetPlans[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: HomeInternetPackageListItem( // Using the HomeNet specific item
                      package: plan,
                      onSelect: () {
                        // Navigate to HomeNet screen and potentially highlight this plan
                        // Or directly to a simplified payment flow if applicable from main
                         Navigator.of(context).pushNamed(AppRouter.loginRoute, arguments: {'targetRoute': AppRouter.homeInternetRoute});
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected ${plan.speedMbps} Mbps plan")));
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimensions.lg),
            ],

            // Featured Shop Products - Displayed in a horizontal scroll view
            if (_featuredShopProducts.isNotEmpty) ...[
               _buildOfferSectionTitle(context, 'Shop Specials', () {
                Navigator.of(context).pushNamed(AppRouter.shopRoute);
              }),
              const SizedBox(height: AppDimensions.xs),
              SizedBox(
                height: 290, // Adjust height based on ProductListItemWidget
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _featuredShopProducts.length,
                  itemBuilder: (context, index) {
                    final product = _featuredShopProducts[index];
                    return Container(
                      width: 180, // Width of ProductListItemWidget
                      margin: EdgeInsets.only(right: AppDimensions.sm, left: index == 0 ? 0 : AppDimensions.xs),
                      child: ProductListItemWidget(
                        product: product,
                        isFeatured: true, // Assuming these are indeed featured style
                        onOrderNow: () {
                          // Add to cart logic would be complex here without full cart state access
                          // Simplest is to navigate to shop, or product detail if exists
                          Navigator.of(context).pushNamed(AppRouter.shopRoute);
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Viewing ${product.name} in shop")));
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.xl),
            ],
            
            // Footer Links
            Center(
              child: Column(
                children: [
                  Text("Customer Service", style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    "${AppConstants.customerService1} | ${AppConstants.customerService2}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                   Text(
                    "${AppConstants.copyrightYear} ${AppConstants.companyFullName}. All rights reserved.",
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),
          ],
        ),
      ),
    );
  }
}
// <end of features/main/screens/main_screen.dart>