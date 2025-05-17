class PackageModel {
  final String id;
  final String name; // e.g., "2GB + 1GB bonus" or "10Hours UnlimiNET"
  final String price; // e.g., "Sh39"
  final String validity; // e.g., "valid for 24Hours" or "till midnight"
  final String devices; // e.g., "1 Device" or "2 Devices"
  final bool isUnlimiNET;
  final double numericPrice;
  bool isFavorite; // Added field

  PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.validity,
    required this.devices,
    this.isUnlimiNET = false,
    required this.numericPrice,
    this.isFavorite = false, // Default to false
  });

  String get fullDescription {
    if (isUnlimiNET) {
      return "$name";
    }
    return "$name $validity";
  }
}
