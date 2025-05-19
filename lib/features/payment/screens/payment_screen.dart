// <start of features/payment/screens/payment_screen.dart>
import 'package:flutter/material.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/widgets/primary_button.dart';
import 'package:net_app/data/models/package_model.dart';
import 'package:net_app/data/models/home_internet_package_model.dart'; // New import
import 'package:net_app/data/datasources/mock_data_sources.dart';

class PaymentScreen extends StatefulWidget {
  final dynamic packageItem; // Changed to dynamic to accept both types
  const PaymentScreen({super.key, required this.packageItem});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _mpesaPhoneController;
  bool _isProcessingPayment = false;
  final MockDataSource _dataSource = MockDataSource();

  // Helper properties to get details based on package type
  String get _packageName {
    if (widget.packageItem is PackageModel) {
      return (widget.packageItem as PackageModel).fullDescription;
    } else if (widget.packageItem is HomeInternetPackageModel) {
      final plan = widget.packageItem as HomeInternetPackageModel;
      return "${plan.speedMbps} Mbps ${plan.description}";
    }
    return "Unknown Package";
  }

  String get _packagePriceString {
    if (widget.packageItem is PackageModel) {
      return (widget.packageItem as PackageModel).price;
    } else if (widget.packageItem is HomeInternetPackageModel) {
      final plan = widget.packageItem as HomeInternetPackageModel;
      return "KES ${plan.price.toStringAsFixed(0)}";
    }
    return "N/A";
  }

  double get _numericPrice {
    if (widget.packageItem is PackageModel) {
      return (widget.packageItem as PackageModel).numericPrice;
    } else if (widget.packageItem is HomeInternetPackageModel) {
      return (widget.packageItem as HomeInternetPackageModel).price;
    }
    return 0.0;
  }

  String get _paymentTypeString {
     if (widget.packageItem is HomeInternetPackageModel) {
      return "HomeNet Plan";
    }
    return "Hotspot Package"; // Default or for PackageModel
  }


  @override
  void initState() {
    super.initState();
    // Use the mock user's primary phone number for M-PESA by default
    // This assumes payments are generally tied to this, even for HomeNet.
    // If HomeNet has a specific account for M-PESA payment, adjust this.
    _mpesaPhoneController = TextEditingController(
      text: _dataSource.mockUserPhoneNumber, // Or _dataSource.mockHomeInternetUserPhone if distinct Mpesa no.
    );
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessingPayment = true);
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _isProcessingPayment = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment for $_packagePriceString successful! $_paymentTypeString activated.',
          ),
          backgroundColor: AppColors.successLight,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _mpesaPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Complete ${_paymentTypeString} Subscription'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // Differentiate title based on package type
                widget.packageItem is HomeInternetPackageModel
                  ? "HomeNet Plan Selected:"
                  : "Hotspot Package Selected:",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "$_packagePriceString = $_packageName",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                "You'll pay KES ${_numericPrice.toStringAsFixed(0)} to complete the subscription.",
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: AppDimensions.xl),
              Text("M-PESA No.", style: theme.textTheme.titleMedium),
              const SizedBox(height: AppDimensions.sm),
              TextFormField(
                controller: _mpesaPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Enter M-PESA phone number",
                  prefixIcon: Icon(Icons.phone_android),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter M-PESA phone number';
                  }
                  if (value.length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.md),
              PrimaryButton(
                text: "Pay KES ${_numericPrice.toStringAsFixed(0)}",
                onPressed: _processPayment,
                isLoading: _isProcessingPayment,
                backgroundColor: AppColors.accentLight,
                textColor: Colors.white,
              ),
              const SizedBox(height: AppDimensions.lg),
              Row(
                children: [
                  Expanded(child: Divider(color: theme.dividerColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
                    child: Text("OR", style: theme.textTheme.bodyMedium),
                  ),
                  Expanded(child: Divider(color: theme.dividerColor)),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              Text(
                "Use our PAYBILL instructions",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppDimensions.md),
              _buildPaybillInstruction(context, "1. Go to M-PESA on your phone"),
              _buildPaybillInstruction(context, "2. Select Pay Bill option"),
              _buildPaybillInstruction(context, "3. Enter Business no: 4140961"),
              // Paybill Account Number:
              // For Hotspot, it's the user's phone.
              // For HomeNet, it might be the HomeNet account number or still the user's phone.
              // Let's assume user's phone for now for M-PESA user recognition.
              // If HomeNet paybill uses the HomeNet Account ID, you'd need to pass that to PaymentScreen.
              _buildPaybillInstruction(
                context,
                "4. Enter Account no: ${_dataSource.mockUserPhoneNumber}", // Or specific HomeNet Account ID if different
              ),
              _buildPaybillInstruction(
                context,
                "5. Enter the Amount: ${_numericPrice.toStringAsFixed(0)}",
              ),
              _buildPaybillInstruction(context, "6. Enter your M-PESA PIN and Send"),
              _buildPaybillInstruction(context, "7. Check back and proceed after making payment."),
              const SizedBox(height: AppDimensions.lg),
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Checking payment status... (mock)'),
                        backgroundColor: AppColors.infoLight,
                      ),
                    );
                  },
                  child: const Text("I have made the payment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaybillInstruction(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.xs),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
// <end of features/payment/screens/payment_screen.dart>