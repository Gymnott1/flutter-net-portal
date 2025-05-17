import 'package:flutter/material.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart'; // For mock data

class AccountDetailsCard extends StatelessWidget {
  final String userName;
  final String phoneNumber;
  final double credit;
  final int netPoints;
  final VoidCallback onRefresh; // For the refresh icon

  const AccountDetailsCard({
    super.key,
    required this.userName,
    required this.phoneNumber,
    required this.credit,
    required this.netPoints,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mockData =
        MockDataSource(); // Access mock data directly for simplicity here

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prepaid - $phoneNumber',
                  style: theme.textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
                  onPressed: onRefresh,
                  tooltip: 'Refresh Account',
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAccountStat(
                  context,
                  'Credit (Ksh)',
                  credit.toStringAsFixed(0),
                ),
                _buildAccountStat(context, 'Net Points', netPoints.toString()),
              ],
            ),
            // If you want to add a graph later, this is where it could go
            // const SizedBox(height: AppDimensions.md),
            // Text("Data Usage Graph (Placeholder)", style: theme.textTheme.bodySmall),
            // Container(height: 50, color: Colors.grey[300]), // Placeholder for graph
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStat(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
