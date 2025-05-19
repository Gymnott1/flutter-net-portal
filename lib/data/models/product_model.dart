// <start of data/models/product_model.dart>
enum ProductCategory {
  gasRefill,
  gasAccessory, // e.g., regulators, pipes
  electronics,   // e.g., phones, chargers
  electronicAccessory, // e.g., cables, power banks
  other,
}

String productCategoryToString(ProductCategory category) {
  switch (category) {
    case ProductCategory.gasRefill: return "Gas Refill";
    case ProductCategory.gasAccessory: return "Gas Accessories";
    case ProductCategory.electronics: return "Electronics";
    case ProductCategory.electronicAccessory: return "Electronic Accessories";
    default: return "Other";
  }
}

class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final ProductCategory category; // Using enum for better type safety
  final String description; // Added for potential product detail view
  final bool isFeatured;
  int stock; // Added for cart management

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.category,
    this.description = "A high-quality product from Amazons Enterprise.", // Default description
    this.isFeatured = false,
    this.stock = 10, // Default stock
  });
}
// <end of data/models/product_model.dart>