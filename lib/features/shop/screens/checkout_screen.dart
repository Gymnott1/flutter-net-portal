// <start of features/shop/screens/checkout_screen.dart>
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/widgets/primary_button.dart';
import 'package:net_app/data/models/cart_item_model.dart';
import 'package:net_app/data/models/order_model.dart'; // New import
import 'dart:math'; // For random order ID

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.stkPush;
  bool _isPlacingOrder = false;

  double get _totalAmount =>
      widget.cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isPlacingOrder = true);

    // Simulate STK Push if selected
    bool paymentSuccessful = true;
    String? transactionId;
    OrderStatus initialStatus = OrderStatus.pending;


    if (_selectedPaymentMethod == PaymentMethod.stkPush) {
      // Simulate STK Push
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('STK Push initiated to ${_phoneController.text}... Please confirm on your phone.'),
          backgroundColor: AppColors.infoLight,
          duration: const Duration(seconds: 5), // Give user time to "confirm"
        ),
      );
      await Future.delayed(const Duration(seconds: 7)); // Simulate wait for STK push

      // Mock STK Push result (randomly success or fail for demo)
      // In a real app, you'd poll your backend or listen for a callback.
      paymentSuccessful = Random().nextBool(); 
      if (paymentSuccessful) {
        transactionId = "MPESASTK_${Random().nextInt(999999)}";
        initialStatus = OrderStatus.paid;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('M-PESA Payment Successful! Transaction ID: $transactionId'), backgroundColor: AppColors.successLight),
        );
      } else {
        initialStatus = OrderStatus.failed;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('M-PESA Payment Failed or Timed Out.'), backgroundColor: AppColors.errorLight),
        );
      }
    } else { // Pay on Delivery
        initialStatus = OrderStatus.processing; // Or awaiting confirmation
    }

    setState(() => _isPlacingOrder = false);

    if (!paymentSuccessful && _selectedPaymentMethod == PaymentMethod.stkPush) {
        // Optionally offer retry or change payment method
        return; 
    }

    // Create OrderModel
    final order = OrderModel(
      id: "AMZORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}",
      items: widget.cartItems,
      totalAmount: _totalAmount,
      orderDate: DateTime.now(),
      customerName: _nameController.text,
      customerPhone: _phoneController.text,
      deliveryAddress: _addressController.text,
      paymentMethod: _selectedPaymentMethod,
      status: initialStatus,
      transactionId: transactionId,
    );

    // TODO: Here you would typically send the order to your backend.
    // For now, we navigate directly to confirmation.

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.orderConfirmationRoute,
      ModalRoute.withName(AppRouter.shopRoute), // Remove until shop screen
      arguments: order,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Summary', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppDimensions.sm),
              Card(
                elevation: 1,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    return ListTile(
                      leading: Image.asset(item.product.imageUrl, width: 40, fit: BoxFit.contain),
                      title: Text(item.product.name),
                      subtitle: Text('${item.quantity} x KSh ${item.product.price.toStringAsFixed(2)}'),
                      trailing: Text('KSh ${item.totalPrice.toStringAsFixed(2)}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Total: ', style: theme.textTheme.titleLarge),
                    Text('KSh ${_totalAmount.toStringAsFixed(2)}', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(height: AppDimensions.lg),

              Text('Delivery Details', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppDimensions.md),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: AppDimensions.sm),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number (for M-PESA & delivery)', prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Phone is required' : (v.length < 10 ? 'Invalid phone' : null),
              ),
              const SizedBox(height: AppDimensions.sm),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Delivery Address (e.g., Street, Town)', prefixIcon: Icon(Icons.location_on_outlined)),
                maxLines: 2,
                validator: (v) => v!.isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: AppDimensions.lg),
              const Divider(height: AppDimensions.lg),

              Text('Payment Method', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppDimensions.sm),
              RadioListTile<PaymentMethod>(
                title: Text(paymentMethodToString(PaymentMethod.stkPush)),
                value: PaymentMethod.stkPush,
                groupValue: _selectedPaymentMethod,
                onChanged: (PaymentMethod? value) {
                  if (value != null) setState(() => _selectedPaymentMethod = value);
                },
                secondary: const Icon(Icons.phone_android_outlined),
                activeColor: theme.colorScheme.primary,
              ),
              RadioListTile<PaymentMethod>(
                title: Text(paymentMethodToString(PaymentMethod.payOnDelivery)),
                value: PaymentMethod.payOnDelivery,
                groupValue: _selectedPaymentMethod,
                onChanged: (PaymentMethod? value) {
                  if (value != null) setState(() => _selectedPaymentMethod = value);
                },
                secondary: const Icon(Icons.delivery_dining_outlined),
                activeColor: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppDimensions.xl),

              PrimaryButton(
                text: _isPlacingOrder ? 'Processing...' : 'Place Order (KSh ${_totalAmount.toStringAsFixed(2)})',
                onPressed: _isPlacingOrder ? null : _placeOrder,
                isLoading: _isPlacingOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// <end of features/shop/screens/checkout_screen.dart>