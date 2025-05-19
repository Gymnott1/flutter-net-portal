// <start of data/datasources/mock_data_sources.dart>
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:net_app/data/models/package_model.dart';
import 'package:net_app/core/utils/app_assets.dart';
import 'package:net_app/data/models/notification_model.dart';
import 'package:net_app/data/models/home_internet_package_model.dart';
import 'package:net_app/data/models/product_model.dart';
import 'dart:math';

class MockDataSource {
  List<PackageModel> _internalPackages = []; // For Hotspot
  List<HomeInternetPackageModel> _homeInternetPackages = [];
  List<ProductModel> _shopProducts = [];
  
  List<String> _generalAdImages = []; // Renamed from _adImages for clarity
  List<String> _shopAdImages = [];

  final Random _random = Random();

  MockDataSource() {
    _initializePackages();
    _initializeHomeInternetPackages();
    _initializeShopData();
    _initializeGeneralAds(); // Initialize general ads
  }

  void _initializeGeneralAds() {
     _generalAdImages = [
      AppAssets.adCylinders, // Example general ad
      AppAssets.adPlaceholder1,
      AppAssets.adPlaceholder2,
    ];
  }

  void _initializePackages() { // Hotspot Packages
    _internalPackages = [
      PackageModel( id: '1', name: '30Minutes UnlimiNET', price: 'Sh5', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 5, isFavorite: true ), PackageModel( id: '2', name: '1Hour UnlimiNET', price: 'Sh9', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 9, isFavorite: false ), PackageModel( id: '3', name: '2Hours UnlimiNET', price: 'Sh13', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 13, isFavorite: false ), PackageModel( id: '4', name: '4Hours UnlimiNET', price: 'Sh20', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 20, isFavorite: false ), PackageModel( id: '5', name: '1GB + 500MB bonus', price: 'Sh29', validity: 'valid for 24Hours', devices: '1 Device', numericPrice: 29, isFavorite: false ), PackageModel( id: '6', name: '10Hours UnlimiNET', price: 'Sh30', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 30, isFavorite: false ), PackageModel( id: '7', name: '2GB + 1GB bonus', price: 'Sh39', validity: 'valid for 24Hours', devices: '1 Device', numericPrice: 39, isFavorite: true ), PackageModel( id: '8', name: 'UnlimiNET till midnight', price: 'Sh40', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 40, isFavorite: false ), PackageModel( id: '9', name: '10Hours UnlimiNET', price: 'Sh49', validity: '', devices: '2 Devices', isUnlimiNET: true, numericPrice: 49, isFavorite: false ), PackageModel( id: '10', name: '24Hours UnlimiNET', price: 'Sh50', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 50, isFavorite: true ), PackageModel( id: '11', name: '4GB + 500MB bonus', price: 'Sh59', validity: 'valid for 48Hours', devices: '1 Device', numericPrice: 59, isFavorite: false ), PackageModel( id: '12', name: '5GB + 500MB bonus', price: 'Sh69', validity: 'valid for 72Hours', devices: '1 Device', numericPrice: 69, isFavorite: false ), PackageModel( id: '13', name: '24Hours UnlimiNET', price: 'Sh79', validity: '', devices: '2 Devices', isUnlimiNET: true, numericPrice: 79, isFavorite: false ), PackageModel( id: '14', name: '24Hours UnlimiNET', price: 'Sh99', validity: '', devices: '3 Devices', isUnlimiNET: true, numericPrice: 99, isFavorite: false ), PackageModel( id: '15', name: '3Days UnlimiNET', price: 'Sh125', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 125, isFavorite: true ), PackageModel( id: '16', name: '72Hours UnlimiNET', price: 'Sh249', validity: '', devices: '3 Devices', isUnlimiNET: true, numericPrice: 249, isFavorite: false ), PackageModel( id: '17', name: '7Days UnlimiNET', price: 'Sh250', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 250, isFavorite: false ), PackageModel( id: '18', name: '30Days UnlimiNET', price: 'Sh850', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 850, isFavorite: true ),
    ];
  }

  void _initializeHomeInternetPackages() {
     _homeInternetPackages = [
      HomeInternetPackageModel( id: 'hi_1', speedMbps: '5', description: 'Monthly UNLIMINET', price: 1500, ), HomeInternetPackageModel( id: 'hi_2', speedMbps: '8', description: 'Monthly UNLIMINET', price: 2000, isCurrentPlan: true, ), HomeInternetPackageModel( id: 'hi_3', speedMbps: '10', description: 'Monthly UNLIMINET', price: 2500, ), HomeInternetPackageModel( id: 'hi_4', speedMbps: '15', description: 'Monthly UNLIMINET', price: 3000, ),
    ];
  }

  void _initializeShopData() {
    _shopAdImages = [
      AppAssets.shopAdBestDeal,
      AppAssets.adCylinders,
    ];

    _shopProducts = [
      ProductModel(id: 'sp1', name: 'Pro Gas Refill 6KG', imageUrl: AppAssets.proGas, price: 1350, category: ProductCategory.gasRefill, isFeatured: true, description: "Reliable 6KG Pro Gas cylinder refill."),
      ProductModel(id: 'sp2', name: 'Men Gas Refill 6KG', imageUrl: AppAssets.menGas, price: 1250, originalPrice: 1300, category: ProductCategory.gasRefill, isFeatured: true),
      ProductModel(id: 'sp3', name: 'Oilibya (Mpishi) Refill 6KG', imageUrl: AppAssets.oilibyaGas, price: 1250, originalPrice: 1300, category: ProductCategory.gasRefill),
      ProductModel(id: 'sp4', name: 'Total Gas Refill 13KG', imageUrl: AppAssets.totalGas, price: 2500, originalPrice: 2650, category: ProductCategory.gasRefill),
      ProductModel(id: 'sp5', name: 'Hashi Gas Refill 6KG', imageUrl: AppAssets.hashiGas, price: 1250, originalPrice: 1300, category: ProductCategory.gasRefill),
      ProductModel(id: 'sp6', name: 'Gas Regulator', imageUrl: AppAssets.adPlaceholder1, price: 750, category: ProductCategory.gasAccessory, description: "High-quality gas regulator with safety lock."), // Placeholder image
      ProductModel(id: 'sp7', name: 'K-Gas Refill 6KG', imageUrl: AppAssets.kGas, price: 1300, originalPrice: 1400, category: ProductCategory.gasRefill),
      ProductModel(id: 'sp8', name: 'USB-C Charger 20W', imageUrl: AppAssets.adPlaceholder2, price: 1200, category: ProductCategory.electronics, description: "Fast charging 20W USB-C power adapter."), // Placeholder image
      ProductModel(id: 'sp9', name: 'Braided USB-C Cable', imageUrl: AppAssets.adPlaceholder1, price: 500, category: ProductCategory.electronicAccessory, description: "Durable 1.5m braided USB-C to USB-A cable."), // Placeholder image
      ProductModel(id: 'sp10', name: 'Wireless Mouse', imageUrl: AppAssets.adPlaceholder2, price: 900, category: ProductCategory.electronicAccessory, isFeatured: true), // Placeholder
    ];
  }

  // --- Getters for Packages ---
  List<PackageModel> getPackages() { // For Hotspot
    List<PackageModel> sortedPackages = List.from(_internalPackages);
    sortedPackages.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return a.numericPrice.compareTo(b.numericPrice);
    });
    return sortedPackages;
  }

  List<HomeInternetPackageModel> getHomeInternetPackages() {
    return List.from(_homeInternetPackages);
  }

  // --- Method to toggle favorite status for Hotspot packages ---
  void toggleFavoriteStatus(String packageId) {
    final index = _internalPackages.indexWhere((p) => p.id == packageId);
    if (index != -1) {
      _internalPackages[index].isFavorite = !_internalPackages[index].isFavorite;
    }
  }

  // --- Getters for Shop Products ---
  List<ProductModel> getShopProducts({bool featuredOnly = false}) {
    if (featuredOnly) {
      return _shopProducts.where((p) => p.isFeatured).toList();
    }
    // For "Top Products", return non-featured or a specific curated list
    return _shopProducts.where((p) => !p.isFeatured).toList();
  }
   List<ProductModel> getAllShopProducts() {
    return List.from(_shopProducts);
  }

  // --- Getters for Ad Images ---
  List<String> getAdImages() { // General Ads (used by Hotspot, HomeInternet, MainScreen)
    return _generalAdImages;
  }

  List<String> getShopAdImages() { // Specific Ads for Shop
    return _shopAdImages;
  }


  // --- Hotspot User Mock Data ---
  String mockUserName = "Thereza";
  String mockUserPhoneNumber = "0794606921";
  String mockActiveSubscription = "KKWZBZVZ • Sh850= 30Days UnlimiNET";
  String mockDataUsed = "3.96 GB";
  String mockExpiryDate = "14/06/2025 17:55";

  // --- Home Internet User Mock Data ---
  String mockHomeInternetUserName = "Jane Fibre";
  String mockHomeInternetUserPhone = "0722123456";
  String getMockHomeInternetActiveSubscription() {
    final current = _homeInternetPackages.firstWhere(
        (p) => p.isCurrentPlan, orElse: () => _homeInternetPackages.first);
    return "${current.speedMbps} Mbps ${current.description}";
  }
  String mockHomeInternetExpiryDate = "30/07/2025";
  String mockHomeInternetDataUsed = "Unlimited";

  // --- Contact Info from image for Home Internet Section ---
  final List<String> homeNetContactPhones = ["0769 045 689", "0769 045 694"];
  final String homeNetContactEmail = "amazonsnetwork@gmail.com";
  final List<String> homeNetOtherServices = [
    "CCTV Installation",
    "Cloud Storage Connection"
  ];

  // --- Notifications ---
  List<NotificationModel> getNotifications() {
    return [
      NotificationModel( id: '1', title: 'New Package Alert!', message: 'Check out our new weekly UnlimiNET package for only Sh250.', timestamp: DateTime.now().subtract(const Duration(hours: 2)), isRead: false, ), NotificationModel( id: '2', title: 'Payment Successful', message: 'Your payment of Sh50 for 24Hours UnlimiNET was successful.', timestamp: DateTime.now().subtract(const Duration(days: 1)), isRead: true, ), NotificationModel( id: '3', title: 'Maintenance Scheduled', message: 'Scheduled maintenance tonight from 2 AM to 3 AM. Services might be intermittent.', timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)), isRead: false, ), NotificationModel( id: '4', title: 'Free Data Bonus!', message: 'Enjoy a free 500MB bonus on your next purchase of 2GB package.', timestamp: DateTime.now().subtract(const Duration(days: 3)), isRead: true, ),
    ];
  }

  // --- Statistics Data ---
  List<FlSpot> getWeeklyDataUsage() {
    return List.generate(7, (index) {
      return FlSpot(index.toDouble(), (_random.nextDouble() * 4.5) + 0.5);
    });
  }

  Map<String, double> getPackageTypePurchaseStats() {
    int unlimiNETCount = _internalPackages.where((p) => p.isUnlimiNET).length;
    int gbBasedCount = _internalPackages.where((p) => !p.isUnlimiNET).length;
    return { 'UnlimiNET': unlimiNETCount.toDouble(), 'GB Bundles': gbBasedCount.toDouble(), };
  }

  List<BarChartGroupData> getMonthlySpending() {
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    return List.generate(months.length, (index) {
      return BarChartGroupData( x: index, barRods: [ BarChartRodData( toY: (_random.nextInt(1000) + 200).toDouble(), color: Colors.amber, width: 16, borderRadius: const BorderRadius.only( topLeft: Radius.circular(4), topRight: Radius.circular(4), ) ), ], );
    });
  }

  // --- Shop Footer Content ---
  final String shopPurposeStatement = "Our purpose is to Sustain, Make the Pleasure and Benefits of Goods Accessible to Many";
  final String shopContactPhone1 = "0715 080 432";
  final String shopContactPhone2 = "0702 026 544";
  final String shopContactEmail = "sales@amazons.co.ke";
  final String shopAddress = "Bidii House - New Sunrise, Maseno - Kenya.";
  final String shopCopyright = "© 2025 Lence Amazons Ltd. All Rights Reserved.";
}
// <end of data/datasources/mock_data_sources.dart>