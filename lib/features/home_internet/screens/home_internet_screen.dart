// <start of features/home_internet/screens/home_internet_screen.dart>
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_constants.dart';
import 'package:net_app/core/widgets/app_logo.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart';
import 'package:net_app/data/models/home_internet_package_model.dart';
import 'package:net_app/features/home/widgets/active_subscription_card.dart'; // Re-use
import 'package:net_app/features/home/widgets/ad_slider.dart'; // Re-use
import 'package:net_app/features/home_internet/widgets/home_internet_package_list.dart';
// For launching URLs, e.g., phone numbers or email
// import 'package:url_launcher/url_launcher.dart';

class HomeInternetScreen extends StatefulWidget {
  const HomeInternetScreen({super.key});

  @override
  State<HomeInternetScreen> createState() => _HomeInternetScreenState();
}

class _HomeInternetScreenState extends State<HomeInternetScreen> {
  final MockDataSource _dataSource = MockDataSource();
  late List<HomeInternetPackageModel> _packages;
  late List<String> _adImages;

  @override
  void initState() {
    super.initState();
    _packages = _dataSource.getHomeInternetPackages();
    _adImages = _dataSource.getAdImages(); // Or specific ads for home internet
  }

  void _handlePlanSelection(HomeInternetPackageModel package) {
    // This would typically navigate to a payment/confirmation screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected Plan: ${package.speedMbps} Mbps for KES ${package.price}',
        ),
        backgroundColor: AppColors.successLight,
      ),
    );
    // Example: You could push to PaymentScreen if it's generic enough,
    // or a new screen for Home Internet plan confirmation.
    // For now, we just show a message.
  }

  Widget _buildContactAndServicesSection(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.md),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CONTACT US",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            ..._dataSource.homeNetContactPhones.map(
              (phone) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.xs),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(phone, style: theme.textTheme.bodyLarge),
                    // Add InkWell for tappable phone number if url_launcher is used
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  _dataSource.homeNetContactEmail,
                  style: theme.textTheme.bodyLarge,
                ),
                // Add InkWell for tappable email if url_launcher is used
              ],
            ),
            const Divider(height: AppDimensions.lg),
            Text(
              "WE ALSO DO",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            ..._dataSource.homeNetOtherServices.map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.xs),
                child: Row(
                  children: [
                    Icon(
                      Icons.construction_outlined, // Or a more suitable icon
                      color: theme.colorScheme.secondary,
                      size: 18,
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(service, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
              tooltip: 'Back to Main Menu',
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.mainRoute,
                    (route) => false,
                  );
                }
              },
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            titleSpacing: AppDimensions.xs,
            title: const AppLogo(height: 36),
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
                  // Potentially pass args if settings differ for Home Internet
                  Navigator.of(context).pushNamed(AppRouter.settingsRoute);
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Welcome, ${_dataSource.mockHomeInternetUserName}!', // Home Internet user
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: AppDimensions.md),
                // Re-use AdSlider
                if (_adImages.isNotEmpty)
                  AdSliderWidget(adImagePaths: _adImages),
                const SizedBox(height: AppDimensions.md),
                // Re-use ActiveSubscriptionCard with Home Internet data
                ActiveSubscriptionCard(
                  subscriptionName:
                      _dataSource.getMockHomeInternetActiveSubscription(),
                  dataUsed: _dataSource.mockHomeInternetDataUsed,
                  expiryDate: _dataSource.mockHomeInternetExpiryDate,
                  onReconnect: () {
                    // "Reconnect" might mean "Check Status" or similar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Checking Home Internet status... (mock)',
                        ),
                        backgroundColor: AppColors.infoLight,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.lg),
                Text(
                  "Amazons Home Fibre Plans",
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppDimensions.sm),
              ]),
            ),
          ),
          _packages.isEmpty
              ? SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Text(
                      "No Home Fibre plans available at the moment.",
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
              : SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final package = _packages[index];
                    return HomeInternetPackageListItem(
                      package: package,
                      onSelect: () => _handlePlanSelection(package),
                    );
                  }, childCount: _packages.length),
                ),
              ),
          SliverPadding(
            // New SliverPadding for contact section and footer
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildContactAndServicesSection(context),
                const SizedBox(height: AppDimensions.md),
                Text(
                  "Customer Service",
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  AppConstants
                      .customerService1, // Or specific HomeNet service numbers
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.md),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.xl,
                  ),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text("Join our WhatsApp Group"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Opening WhatsApp... (Implement URL Launcher)',
                          ),
                          backgroundColor: AppColors.infoLight,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF25D366,
                      ), // WhatsApp Green
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
                Text(
                  "Powered by © ${DateTime.now().year} ${AppConstants.companyFullName}",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppDimensions.md),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
// <end of features/home_internet/screens/home_internet_screen.dart>