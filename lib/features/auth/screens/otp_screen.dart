// <start of features/auth/screens/otp_screen.dart>
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/widgets/app_logo.dart';
import 'package:net_app/core/widgets/primary_button.dart';
import 'package:net_app/features/auth/widgets/auth_footer.dart';

class OtpScreen extends StatefulWidget {
  final String? phoneNumber; // This is the ACTUAL number OTP was sent to (for resend logic)
  final String? displayIdentifier; // This is what's SHOWN to the user (phone or account_no)
  final String targetRoute;
  const OtpScreen(
      {super.key, this.phoneNumber, this.displayIdentifier, required this.targetRoute});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  int _resendTimerSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    _resendTimerSeconds = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimerSeconds > 0) {
        if (mounted) {
          setState(() {
            _resendTimerSeconds--;
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification successful!'),
          backgroundColor: AppColors.successLight,
        ),
      );
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(widget.targetRoute, (route) => false);
    }
  }

  void _resendCode() {
    if (_resendTimerSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // Use widget.phoneNumber for the actual resend target
          content: Text(
            'New code sent to phone associated with ${widget.displayIdentifier ?? 'your account/number'}',
          ),
          backgroundColor: AppColors.infoLight,
        ),
      );
      startResendTimer();
      // Actual resend logic would use widget.phoneNumber
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Determine if the displayIdentifier looks like an account number or phone
    // This is a heuristic; adjust as needed.
    bool isAccountLogin = widget.displayIdentifier != null && !widget.displayIdentifier!.startsWith("07") && !widget.displayIdentifier!.startsWith("+254");


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
                  const SizedBox(height: AppDimensions.xl * 1.5),
                  Text(
                    "Enter verification code",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  if (widget.displayIdentifier != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppDimensions.sm),
                      child: Text(
                        // Show different message based on what displayIdentifier is
                        isAccountLogin
                          ? "Sent to phone registered with Account: ${widget.displayIdentifier}"
                          : "Sent to: ${widget.displayIdentifier}",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  const SizedBox(height: AppDimensions.lg),
                  TextFormField(
                    controller: _otpController,
                    // ... (rest of TextFormField)
                     keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                    decoration: const InputDecoration(
                      hintText: "------",
                      counterText: "",
                    ),
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      if (value.length < 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  PrimaryButton(
                    text: "Verify",
                    onPressed: _verifyOtp,
                    isLoading: _isLoading,
                    backgroundColor: AppColors.accentLight,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  TextButton(
                    onPressed: _resendTimerSeconds == 0 ? _resendCode : null,
                    child: Text(
                      _resendTimerSeconds > 0
                          ? "Resend code in: 0:${_resendTimerSeconds.toString().padLeft(2, '0')} seconds"
                          : "Resend code",
                      style: TextStyle(
                        color: _resendTimerSeconds == 0
                            ? theme.colorScheme.primary
                            : theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                   const SizedBox(height: AppDimensions.md),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Back to Sign In"),
                  ),
                  const SizedBox(height: AppDimensions.xl),
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
// <end of features/auth/screens/otp_screen.dart>