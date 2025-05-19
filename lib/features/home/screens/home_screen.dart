// <start of features/home/screens/home_screen.dart>
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart'; // Added for navigation
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_constants.dart';
import 'package:net_app/core/widgets/app_logo.dart';
// import 'package:net_app/core/widgets/primary_button.dart'; // Not used directly here for voucher
import 'package:net_app/data/datasources/mock_data_sources.dart';
import 'package:net_app/data/models/package_model.dart';
import 'package:net_app/features/home/widgets/account_details_card.dart';
import 'package:net_app/features/home/widgets/active_subscription_card.dart';
import 'package:net_app/features/home/widgets/ad_slider.dart';
import 'package:net_app/features/home/widgets/package_list_item.dart';
// import 'package:url_launcher/url_launcher.dart'; // For WhatsApp link, add to pubspec.yaml if you use it

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockDataSource _dataSource = MockDataSource(); // Single instance
  late List<PackageModel> _packages;
  late List<String> _adImages;
  final _voucherController = TextEditingController();
  bool _isConnectingVoucher = false;

  @override
  void initState() {
    super.initState();
    _loadPackages(); // Load and sort packages
    _adImages = _dataSource.getAdImages();
  }

  void _loadPackages() {
    // Get packages from data source (which now sorts them)
    setState(() {
      _packages = _dataSource.getPackages();
    });
  }

  void _toggleFavorite(String packageId) {
    _dataSource.toggleFavoriteStatus(packageId);
    _loadPackages(); // Reload and re-sort to reflect the change
    // Optional: Show a SnackBar
    final package = _packages.firstWhere((p) => p.id == packageId,
        orElse: () => _dataSource
            .getPackages()
            .firstWhere((p) => p.id == packageId)); // Ensure we find the package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          package.isFavorite
              ? "'${package.name}' added to favorites."
              : "'${package.name}' removed from favorites.",
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: package.isFavorite
            ? AppColors.successLight
            : AppColors.infoLight,
      ),
    );
  }

  void _refreshAccount() {
    // Simulate fetching new data
    setState(() {
      // Potentially re-fetch other user data if needed
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account details refreshed!'),
        backgroundColor: AppColors.infoLight,
      ),
    );
  }

  Future<void> _connectWithVoucher() async {
    // Made async
    if (_voucherController.text.isNotEmpty) {
      setState(() {
        _isConnectingVoucher = true;
      });
      // Simulate API call or processing
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        // Check if widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Connecting with voucher: ${_voucherController.text} - Success!'),
            backgroundColor: AppColors.successLight,
          ),
        );
        _voucherController.clear();
        setState(() {
          _isConnectingVoucher = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a voucher code'),
          backgroundColor: AppColors.errorLight,
        ),
      );
    }
  }

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false, // Set to true if you want it to stick
            floating: true,
            // automaticallyImplyLeading: true, // Let Flutter handle the back button if appropriate
            leading: IconButton( // Explicit back button
              icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
              tooltip: 'Back to Main Menu',
              onPressed: () {
                // Navigate back to MainScreen, removing all routes until MainScreen
                // Or simply pop if MainScreen is directly below.
                // If login flow clears stack, this might need specific navigation.
                // Assuming MainScreen is on the stack. If not, use pushNamedAndRemoveUntil.
                if (Navigator.canPop(context)) {
                     Navigator.pop(context);
                } else {
                    // Fallback if somehow it can't pop (e.g., deep linked here directly)
                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.mainRoute, (route) => false);
                }
              },
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            titleSpacing: AppDimensions.xs, // Adjust if needed with leading button
            title: const AppLogo(height: 36), // Keep logo concise
            actions: [
              IconButton(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: theme.iconTheme.color,
                ),
                tooltip: 'Shop',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.shopRoute);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: theme.iconTheme.color,
                ),
                tooltip: 'Notifications',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.notificationsRoute);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: theme.iconTheme.color,
                ),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.settingsRoute);
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Good Morning, ${_dataSource.mockUserName} 👋',
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: AppDimensions.md),
                AccountDetailsCard(
                  userName: _dataSource.mockUserName,
                  phoneNumber: _dataSource.mockUserPhoneNumber,
                  credit: 0,
                  netPoints: 0,
                  onRefresh: _refreshAccount,
                ),
                if (_adImages.isNotEmpty) AdSliderWidget(adImagePaths: _adImages),
                const SizedBox(height: AppDimensions.md),
                ActiveSubscriptionCard(
                  subscriptionName: _dataSource.mockActiveSubscription,
                  dataUsed: _dataSource.mockDataUsed,
                  expiryDate: _dataSource.mockExpiryDate,
                  onReconnect: () {
                    // This callback in ActiveSubscriptionCard handles its own SnackBar
                  },
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _voucherController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Voucher Code',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.md,
                                  vertical: AppDimensions.sm),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primaryLight, width: 1.5),
                              ),
                            ),
                            enabled: !_isConnectingVoucher,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        ElevatedButton(
                          onPressed: _isConnectingVoucher
                              ? null
                              : _connectWithVoucher,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.onPrimaryLight,
                            backgroundColor: AppColors.accentLight,
                            disabledBackgroundColor:
                                AppColors.accentLight.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.md, vertical: 14),
                            textStyle: theme.textTheme.labelMedium,
                            minimumSize: const Size(100, 48),
                          ),
                          child: _isConnectingVoucher
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('CONNECT'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.cardRadius),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Offers", style: theme.textTheme.headlineSmall),
                          const SizedBox(width: AppDimensions.sm),
                          Chip(
                            label: Text(
                              "New!",
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.white),
                            ),
                            backgroundColor: AppColors.errorLight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.xs, vertical: 0),
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.xs),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        "Daily FREE 20 Minutes UnlimiNET",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "FREE (Available from 6AM to 8AM daily)",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                Text(
                  "Available Packages",
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppDimensions.sm),
              ]),
            ),
          ),
          // Updated Package List
          _packages.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      child: Text(
                        "No packages available at the moment.",
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final package = _packages[index];
                        return PackageListItem(
                          package: package,
                          onToggleFavorite: () =>
                              _toggleFavorite(package.id),
                        );
                      },
                      childCount: _packages.length,
                    ),
                  ),
                ),
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.md),
                Text(
                  "Customer Service",
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  AppConstants.customerService1,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.md),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                    ),
                    label: const Text("Join our WhatsApp Group"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Opening WhatsApp... (Implement URL Launcher)'),
                          backgroundColor: AppColors.infoLight,
                        ),
                      );
                      // Example: launchUrl(Uri.parse(AppConstants.whatsappGroupLink));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
                Text(
                  "Powered by © ${DateTime.now().year} Netic ISP",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(
                  height: AppDimensions.md,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
// <end of features/home/screens/home_screen.dart>