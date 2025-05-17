import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_constants.dart';
import 'package:net_app/core/widgets/app_logo.dart';
import 'package:net_app/core/widgets/primary_button.dart';
import 'package:net_app/features/auth/widgets/auth_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _connect() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      // Mock success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code sent to ${_phoneController.text}'),
          backgroundColor: AppColors.successLight,
        ),
      );
      Navigator.of(
        context,
      ).pushNamed(AppRouter.otpRoute, arguments: _phoneController.text);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppLogo(height: 80),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    AppConstants.slogan,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xl * 1.5),
                  Text(
                    "Sign in here",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Enter your phone number",
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length < 10) {
                        // Basic validation
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  PrimaryButton(
                    text: "Connect",
                    onPressed: _connect,
                    isLoading: _isLoading,
                    // Use blue color for connect button as per screenshot
                    backgroundColor: AppColors.accentLight,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: AppDimensions.xl * 1.5),
                  const AuthFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
