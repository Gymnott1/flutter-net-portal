
import 'package:fl_chart/fl_chart.dart'; // Added for FlSpot
import 'package:flutter/material.dart'; // Added for Color
import 'package:net_app/data/models/package_model.dart';
import 'package:net_app/core/utils/app_assets.dart';
import 'package:net_app/data/models/notification_model.dart';
import 'dart:math'; // For random data generation

class MockDataSource {
  List<PackageModel> _internalPackages = [];
  final Random _random = Random();

  MockDataSource() {
    _initializePackages();
  }

  void _initializePackages() {
    _internalPackages = [
      PackageModel( id: '1', name: '30Minutes UnlimiNET', price: 'Sh5', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 5, isFavorite: true ),
      PackageModel( id: '2', name: '1Hour UnlimiNET', price: 'Sh9', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 9, isFavorite: false ),
      PackageModel( id: '3', name: '2Hours UnlimiNET', price: 'Sh13', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 13, isFavorite: false ),
      PackageModel( id: '4', name: '4Hours UnlimiNET', price: 'Sh20', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 20, isFavorite: false ),
      PackageModel( id: '5', name: '1GB + 500MB bonus', price: 'Sh29', validity: 'valid for 24Hours', devices: '1 Device', numericPrice: 29, isFavorite: false ),
      PackageModel( id: '6', name: '10Hours UnlimiNET', price: 'Sh30', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 30, isFavorite: false ),
      PackageModel( id: '7', name: '2GB + 1GB bonus', price: 'Sh39', validity: 'valid for 24Hours', devices: '1 Device', numericPrice: 39, isFavorite: true ),
      PackageModel( id: '8', name: 'UnlimiNET till midnight', price: 'Sh40', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 40, isFavorite: false ),
      PackageModel( id: '9', name: '10Hours UnlimiNET', price: 'Sh49', validity: '', devices: '2 Devices', isUnlimiNET: true, numericPrice: 49, isFavorite: false ),
      PackageModel( id: '10', name: '24Hours UnlimiNET', price: 'Sh50', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 50, isFavorite: true ),
      PackageModel( id: '11', name: '4GB + 500MB bonus', price: 'Sh59', validity: 'valid for 48Hours', devices: '1 Device', numericPrice: 59, isFavorite: false ),
      PackageModel( id: '12', name: '5GB + 500MB bonus', price: 'Sh69', validity: 'valid for 72Hours', devices: '1 Device', numericPrice: 69, isFavorite: false ),
      PackageModel( id: '13', name: '24Hours UnlimiNET', price: 'Sh79', validity: '', devices: '2 Devices', isUnlimiNET: true, numericPrice: 79, isFavorite: false ),
      PackageModel( id: '14', name: '24Hours UnlimiNET', price: 'Sh99', validity: '', devices: '3 Devices', isUnlimiNET: true, numericPrice: 99, isFavorite: false ),
      PackageModel( id: '15', name: '3Days UnlimiNET', price: 'Sh125', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 125, isFavorite: true ),
      PackageModel( id: '16', name: '72Hours UnlimiNET', price: 'Sh249', validity: '', devices: '3 Devices', isUnlimiNET: true, numericPrice: 249, isFavorite: false ),
      PackageModel( id: '17', name: '7Days UnlimiNET', price: 'Sh250', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 250, isFavorite: false ),
      PackageModel( id: '18', name: '30Days UnlimiNET', price: 'Sh850', validity: '', devices: '1 Device', isUnlimiNET: true, numericPrice: 850, isFavorite: true ),
    ];
  }

  List<PackageModel> getPackages() {
    List<PackageModel> sortedPackages = List.from(_internalPackages);
    sortedPackages.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return a.numericPrice.compareTo(b.numericPrice);
    });
    return sortedPackages;
  }

  void toggleFavoriteStatus(String packageId) {
    final index = _internalPackages.indexWhere((p) => p.id == packageId);
    if (index != -1) {
      _internalPackages[index].isFavorite = !_internalPackages[index].isFavorite;
    }
  }

  List<String> getAdImages() {
    return [
      AppAssets.adCylinders,
      AppAssets.adPlaceholder1,
      AppAssets.adPlaceholder2,
    ];
  }

  String mockUserName = "Thereza";
  String mockUserPhoneNumber = "0794606921";
  String mockActiveSubscription = "KKWZBZVZ • Sh850= 30Days UnlimiNET";
  String mockDataUsed = "3.96 GB";
  String mockExpiryDate = "14/06/2025 17:55";

  List<NotificationModel> getNotifications() {
    return [
      NotificationModel( id: '1', title: 'New Package Alert!', message: 'Check out our new weekly UnlimiNET package for only Sh250.', timestamp: DateTime.now().subtract(const Duration(hours: 2)), isRead: false, ),
      NotificationModel( id: '2', title: 'Payment Successful', message: 'Your payment of Sh50 for 24Hours UnlimiNET was successful.', timestamp: DateTime.now().subtract(const Duration(days: 1)), isRead: true, ),
      NotificationModel( id: '3', title: 'Maintenance Scheduled', message: 'Scheduled maintenance tonight from 2 AM to 3 AM. Services might be intermittent.', timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)), isRead: false, ),
      NotificationModel( id: '4', title: 'Free Data Bonus!', message: 'Enjoy a free 500MB bonus on your next purchase of 2GB package.', timestamp: DateTime.now().subtract(const Duration(days: 3)), isRead: true, ),
    ];
  }

  // Statistics Data
  List<FlSpot> getWeeklyDataUsage() {
    // Generate 7 days of data usage (mock)
    return List.generate(7, (index) {
      // X-axis: 0 to 6 (representing Mon to Sun, or last 7 days)
      // Y-axis: Random data usage between 0.5GB and 5GB
      return FlSpot(index.toDouble(), (_random.nextDouble() * 4.5) + 0.5);
    });
  }

  Map<String, double> getPackageTypePurchaseStats() {
    // Count UnlimiNET vs GB-based packages from the mock list
    int unlimiNETCount = _internalPackages.where((p) => p.isUnlimiNET).length;
    int gbBasedCount = _internalPackages.where((p) => !p.isUnlimiNET).length;
    return {
      'UnlimiNET': unlimiNETCount.toDouble(),
      'GB Bundles': gbBasedCount.toDouble(),
    };
  }

  List<BarChartGroupData> getMonthlySpending() {
    // Mock spending for 6 months
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    return List.generate(months.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (_random.nextInt(1000) + 200).toDouble(), // Spending between 200 and 1200
            color: Colors.amber, // Example color
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            )
          ),
        ],
      );
    });
  }
}
