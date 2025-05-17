import 'package:flutter/material.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/widgets/primary_button.dart';
import 'package:net_app/data/models/package_model.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart'; // For mock phone number

class PaymentScreen extends StatefulWidget {
  final PackageModel package;
  const PaymentScreen({super.key, required this.package});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _mpesaPhoneController;
  bool _isProcessingPayment = false;
  final MockDataSource _dataSource = MockDataSource();

  @override
  void initState() {
    super.initState();
    _mpesaPhoneController = TextEditingController(
      text: _dataSource.mockUserPhoneNumber,
    );
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessingPayment = true);
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _isProcessingPayment = false);

      // Mock success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment for ${widget.package.price} successful! Package activated.',
          ),
          backgroundColor: AppColors.successLight,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.of(context).pop(); // Go back to home or previous screen
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
      appBar: AppBar(title: const Text('Complete Subscription'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Plan selected: ${widget.package.price} = ${widget.package.fullDescription}",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                "You'll pay KES ${widget.package.numericPrice.toStringAsFixed(0)} to complete the subscription",
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
                text:
                    "Pay KES ${widget.package.numericPrice.toStringAsFixed(0)}",
                onPressed: _processPayment,
                isLoading: _isProcessingPayment,
                backgroundColor: AppColors.accentLight, // Blue for pay button
                textColor: Colors.white,
              ),
              const SizedBox(height: AppDimensions.lg),
              Row(
                children: [
                  Expanded(child: Divider(color: theme.dividerColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                    ),
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
              _buildPaybillInstruction(
                context,
                "1. Go to M-PESA on your phone",
              ),
              _buildPaybillInstruction(context, "2. Select Pay Bill option"),
              _buildPaybillInstruction(
                context,
                "3. Enter Business no: 4140961",
              ),
              _buildPaybillInstruction(
                context,
                "4. Enter Account no: ${_dataSource.mockUserPhoneNumber}",
              ), // Use user's phone as account
              _buildPaybillInstruction(
                context,
                "5. Enter the Amount: ${widget.package.numericPrice.toStringAsFixed(0)}",
              ),
              _buildPaybillInstruction(
                context,
                "6. Enter your M-PESA PIN and Send",
              ),
              _buildPaybillInstruction(
                context,
                "7. Check back and proceed after making payment.",
              ),
              const SizedBox(height: AppDimensions.lg),
              Center(
                child: TextButton(
                  onPressed: () {
                    // This button would typically refresh or check payment status
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
