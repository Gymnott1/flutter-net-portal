// <start of features/shop/widgets/product_list_item_widget.dart>
import 'package:flutter/material.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/data/models/product_model.dart';

class ProductListItemWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onOrderNow;
  final bool isFeatured; // To adjust layout slightly if needed

  const ProductListItemWidget({
    super.key,
    required this.product,
    required this.onOrderNow,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasOriginalPrice = product.originalPrice != null && product.originalPrice! > product.price;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias, // Ensures image corners are rounded with card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.sm),
      ),
      color: theme.cardColor, // Or a specific light grey as in image: Colors.grey.shade100
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: isFeatured ? 3 : 2, // Give more space to image if featured
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.xs),
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.contain, // Or BoxFit.cover if images are uniform
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 40, color: AppColors.textTertiaryLight),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: AppDimensions.xs),
            child: Text(
              product.name,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
            child: Column(
              children: [
                if (hasOriginalPrice)
                  Text(
                    "Was KSh ${product.originalPrice!.toStringAsFixed(2)}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textTertiaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                Text(
                  "${hasOriginalPrice ? 'Now ' : ''}KSh ${product.price.toStringAsFixed(2)}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.sm),
            child: OutlinedButton(
              onPressed: onOrderNow,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.7)),
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
                textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              child: const Text("Order Now"),
            ),
          ),
        ],
      ),
    );
  }
}
// <end of features/shop/widgets/product_list_item_widget.dart>