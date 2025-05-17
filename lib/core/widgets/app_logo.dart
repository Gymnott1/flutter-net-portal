import 'package:flutter/material.dart';
import 'package:net_app/core/utils/app_assets.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  final double? width;

  const AppLogo({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      height: height ?? 60, // Default height
      width: width,
      // Consider BoxFit.contain if your logo aspect ratio needs it
    );
  }
}
