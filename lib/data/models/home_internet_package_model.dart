// <start of data/models/home_internet_package_model.dart>
class HomeInternetPackageModel {
  final String id;
  final String speedMbps; // e.g., "5", "8", "10", "15"
  final String description; // e.g., "Monthly UNLIMINET"
  final double price; // e.g., 1500.00
  final bool isCurrentPlan; // To highlight the user's active plan

  HomeInternetPackageModel({
    required this.id,
    required this.speedMbps,
    required this.description,
    required this.price,
    this.isCurrentPlan = false,
  });
}
// <end of data/models/home_internet_package_model.dart>