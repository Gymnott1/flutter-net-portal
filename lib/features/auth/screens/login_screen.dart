// <start of features/auth/screens/login_screen.dart>
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_constants.dart';
import 'package:net_app/core/widgets/app_logo.dart';
import 'package:net_app/core/widgets/primary_button.dart';
import 'package:net_app/features/auth/widgets/auth_footer.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart';
import 'package:net_app/data/models/home_internet_package_model.dart';
import 'package:net_app/features/home_internet/widgets/home_internet_package_list.dart';

class LoginScreen extends StatefulWidget {
  final Map<String, dynamic>? targetRouteArgs;
  const LoginScreen({super.key, this.targetRouteArgs});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginInputController = TextEditingController();
  bool _isLoading = false;

  final _installationFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  HomeInternetPackageModel? _selectedInstallationPackage;
  bool _isRequestingInstallation = false;

  final MockDataSource _dataSource = MockDataSource();

  bool get _isHomeNetLogin =>
      widget.targetRouteArgs?['targetRoute'] == AppRouter.homeInternetRoute;

  String get _loginLabelText =>
      _isHomeNetLogin ? "Enter your Account Number" : "Enter your phone number";

  String get _loginHintText =>
      _isHomeNetLogin ? "e.g., HN123456" : "e.g., 07XXXXXXXX";

  TextInputType get _keyboardType =>
      _isHomeNetLogin ? TextInputType.text : TextInputType.phone;

  Future<void> _connect() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      String otpRecipient;
      String displayIdentifier;

      if (_isHomeNetLogin) {
        otpRecipient = _dataSource.mockHomeInternetUserPhone;
        displayIdentifier = _loginInputController.text;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification code sent to phone registered with account ${_loginInputController.text}',
            ),
            backgroundColor: AppColors.successLight,
          ),
        );
      } else {
        otpRecipient = _loginInputController.text;
        displayIdentifier = _loginInputController.text;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification code sent to ${_loginInputController.text}',
            ),
            backgroundColor: AppColors.successLight,
          ),
        );
      }

      final otpArgs = {
        'phoneNumber': otpRecipient,
        'displayIdentifier': displayIdentifier,
        'targetRoute':
            widget.targetRouteArgs?['targetRoute'] ?? AppRouter.homeRoute,
      };
      Navigator.of(context).pushNamed(AppRouter.otpRoute, arguments: otpArgs);
    }
  }

  Future<void> _requestInstallation() async {
    if (_installationFormKey.currentState!.validate()) {
      if (_selectedInstallationPackage == null) {
        // Added check
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a HomeNet plan for installation.'),
            backgroundColor: AppColors.warningLight,
          ),
        );
        return;
      }
      setState(() => _isRequestingInstallation = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isRequestingInstallation = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Installation request for ${_nameController.text} (Plan: ${_selectedInstallationPackage!.speedMbps} Mbps) received! We will contact you on ${_phoneController.text}.',
          ),
          backgroundColor: AppColors.successLight,
          duration: const Duration(seconds: 4),
        ),
      );
      _installationFormKey.currentState?.reset();
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      setState(() {
        _selectedInstallationPackage = null;
      });
    }
  }

  @override
  void dispose() {
    _loginInputController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeNetPackagesForOffer =
        _dataSource.getHomeInternetPackages().take(2).toList();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (AppLogo, Slogan, Login Form as before) ...
                const AppLogo(height: 70),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  AppConstants.slogan,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
                Text(
                  _isHomeNetLogin
                      ? "HomeNet Portal Sign In"
                      : "Hotspot Sign In",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: AppDimensions.md),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _loginInputController,
                        keyboardType: _keyboardType,
                        decoration: InputDecoration(
                          labelText: _loginLabelText,
                          hintText: _loginHintText,
                          prefixIcon: Icon(
                            _isHomeNetLogin
                                ? Icons.account_box_outlined
                                : Icons.phone_outlined,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your ${_isHomeNetLogin ? "account number" : "phone number"}';
                          }
                          if (!_isHomeNetLogin && value.length < 10) {
                            return 'Enter a valid phone number';
                          }
                          if (_isHomeNetLogin && value.length < 5) {
                            return 'Enter a valid account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      PrimaryButton(
                        text: "Connect",
                        onPressed: _connect,
                        isLoading: _isLoading,
                        backgroundColor: AppColors.accentLight,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouter.mainRoute,
                      );
                    }
                  },
                  child: const Text("Cancel & Go Back"),
                ),

                if (_isHomeNetLogin) ...[
                  const SizedBox(height: AppDimensions.xl * 1.5),
                  const Divider(),
                  const SizedBox(height: AppDimensions.lg),
                  Text(
                    "New to Amazons HomeNet?",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  Text(
                    "Get connected with our reliable Home Fibre.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  if (homeNetPackagesForOffer.isNotEmpty)
                    ...homeNetPackagesForOffer.map(
                      (plan) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.sm,
                        ),
                        child: HomeInternetPackageListItem(
                          package: plan,
                          // *** THIS IS THE CRUCIAL CHANGE ***
                          onSelect: () {
                            setState(() {
                              _selectedInstallationPackage = plan;
                              // Optionally, scroll to the form or highlight it
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${plan.speedMbps} Mbps plan selected for installation request.",
                                ),
                                backgroundColor:
                                    AppColors.infoLight, // Use info color
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: AppDimensions.md),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      child: Form(
                        key: _installationFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Request Installation",
                              style: theme.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDimensions.md),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: "Full Name",
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator:
                                  (v) => v!.isEmpty ? "Name is required" : null,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: "Phone Number (for contact)",
                                prefixIcon: Icon(Icons.phone_android_outlined),
                              ),
                              validator:
                                  (v) =>
                                      v!.isEmpty
                                          ? "Phone is required"
                                          : (v.length < 10
                                              ? "Invalid phone"
                                              : null),
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "Email Address (Optional)",
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(
                              height: AppDimensions.md,
                            ), // Increased spacing
                            // Display the selected package clearly
                            AnimatedSwitcher(
                              // Added AnimatedSwitcher for better visual feedback
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child:
                                  _selectedInstallationPackage != null
                                      ? Container(
                                        // Wrap in container for key and better layout
                                        key: ValueKey<String>(
                                          _selectedInstallationPackage!.id,
                                        ), // Key for switcher
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppDimensions.sm,
                                          horizontal: AppDimensions.xs,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.sm,
                                          ),
                                        ),
                                        child: Text(
                                          "Selected Plan: ${_selectedInstallationPackage!.speedMbps} Mbps - KES ${_selectedInstallationPackage!.price.toStringAsFixed(0)}/month",
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                      : const SizedBox.shrink(
                                        key: ValueKey<String>("no_plan"),
                                      ), // Empty but with a key
                            ),
                            const SizedBox(height: AppDimensions.md),
                            PrimaryButton(
                              text: "Submit Installation Request",
                              onPressed: _requestInstallation,
                              isLoading: _isRequestingInstallation,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppDimensions.xl),
                const AuthFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// <end of features/auth/screens/login_screen.dart>