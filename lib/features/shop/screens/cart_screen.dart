// <start of features/shop/screens/cart_screen.dart>
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart'; // <<< ADD THIS IMPORT
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/widgets/primary_button.dart';
import 'package:net_app/data/models/cart_item_model.dart';

class CartScreen extends StatefulWidget {
  final List<CartItemModel> initialCartItems;
  const CartScreen({super.key, required this.initialCartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItemModel> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.initialCartItems);
  }

  void _updateQuantity(CartItemModel item, int change) {
    setState(() {
      final index = _cartItems.indexOf(item);
      if (index != -1) {
        _cartItems[index].quantity += change;
        if (_cartItems[index].quantity <= 0) {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  void _removeItem(CartItemModel item) {
    setState(() {
      _cartItems.remove(item);
    });
  }

  double get _totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        elevation: 1,
        // Pass back the updated cart items when navigating back
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(_cartItems), // Pop with result
        ),
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textTertiaryLight),
                  const SizedBox(height: AppDimensions.md),
                  Text('Your cart is empty.', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppDimensions.sm),
                  Text('Add some products to get started!', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppDimensions.lg),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(_cartItems), // Go back to shop, also pop with result
                      child: const Text('Continue Shopping'))
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.sm),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
                        child: ListTile(
                          leading: Image.asset(
                            item.product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, st) => const Icon(Icons.image_not_supported),
                          ),
                          title: Text(item.product.name, style: theme.textTheme.titleMedium),
                          subtitle: Text('KSh ${item.product.price.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium),
                          trailing: SizedBox(
                            width: 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                                  onPressed: () => _updateQuantity(item, -1),
                                  color: theme.colorScheme.error,
                                ),
                                Text('${item.quantity}', style: theme.textTheme.titleMedium),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 20),
                                  onPressed: () => _updateQuantity(item, 1),
                                  color: theme.colorScheme.primary,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20),
                                  onPressed: () => _removeItem(item),
                                  color: AppColors.errorDark.withOpacity(0.7),
                                  tooltip: "Remove item",
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:', style: theme.textTheme.headlineSmall),
                          Text('KSh ${_totalAmount.toStringAsFixed(2)}', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      PrimaryButton(
                        text: 'Proceed to Checkout',
                        onPressed: _cartItems.isEmpty ? null : () {
                          // Navigate to CheckoutScreen
                          // No need to wait for result here, checkout will clear stack or go to confirmation
                          Navigator.of(context).pushNamed(AppRouter.checkoutRoute, arguments: _cartItems);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
// <end of features/shop/screens/cart_screen.dart>