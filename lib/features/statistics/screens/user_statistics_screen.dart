import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart';

class UserStatisticsScreen extends StatefulWidget {
  const UserStatisticsScreen({super.key});

  @override
  State<UserStatisticsScreen> createState() => _UserStatisticsScreenState();
}

class _UserStatisticsScreenState extends State<UserStatisticsScreen> {
  final MockDataSource _dataSource = MockDataSource();
  late List<FlSpot> _weeklyUsage;
  late Map<String, double> _packageStats;
  late List<BarChartGroupData> _monthlySpending;

  final List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  @override
  void initState() {
    super.initState();
    _weeklyUsage = _dataSource.getWeeklyDataUsage();
    _packageStats = _dataSource.getPackageTypePurchaseStats();
    _monthlySpending = _dataSource.getMonthlySpending();
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.lg,
        bottom: AppDimensions.md,
        left: AppDimensions.md,
      ),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Usage Statistics'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Weekly Data Usage (GB)', context),
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.sm,
                ),
                child: LineChart(_buildWeeklyUsageChartData(theme, isDarkMode)),
              ),
            ),
            _buildSectionTitle('Package Purchase Distribution', context),
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                ),
                child: PieChart(_buildPackageStatsChartData(theme, isDarkMode)),
              ),
            ),
            _buildSectionTitle('Monthly Spending (KES)', context),
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.sm,
                ),
                child: BarChart(
                  _buildMonthlySpendingChartData(theme, isDarkMode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildWeeklyUsageChartData(ThemeData theme, bool isDarkMode) {
    final primaryColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: onSurfaceColor.withOpacity(0.1), strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return FlLine(color: onSurfaceColor.withOpacity(0.1), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              final index = value.toInt();
              if (index < 0 || index >= _weekDays.length) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                space: 8,
                meta: meta,
                //axisSide: meta.axisSide,
                child: Text(
                  _weekDays[index],
                  style: TextStyle(
                    color: onSurfaceColor.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value % 1 == 0 && value >= 0) {
                return SideTitleWidget(
                  //axisSide: meta.axisSide,
                  space: 0,
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: onSurfaceColor.withOpacity(0.7),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.left,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: onSurfaceColor.withOpacity(0.2)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: _weeklyUsage,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.8),
              primaryColor.withOpacity(0.3),
            ],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.3),
                primaryColor.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          //tooltipBgColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              return LineTooltipItem(
                '${_weekDays[flSpot.x.toInt()]}\n',
                GoogleFonts.roboto(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${flSpot.y.toStringAsFixed(1)} GB',
                    style: GoogleFonts.roboto(color: onSurfaceColor),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  PieChartData _buildPackageStatsChartData(ThemeData theme, bool isDarkMode) {
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      AppColors.accentLight,
      Colors.teal,
    ];
    int colorIndex = 0;
    double totalValue = _packageStats.values.fold(0, (sum, item) => sum + item);

    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          // Handle touch events if needed for interactivity
        },
      ),
      borderData: FlBorderData(show: false),
      sectionsSpace: 2,
      centerSpaceRadius: 60,
      sections:
          _packageStats.entries.map((entry) {
            final color = colors[colorIndex % colors.length];
            colorIndex++;
            final percentage =
                totalValue > 0 ? (entry.value / totalValue * 100) : 0.0;

            return PieChartSectionData(
              color: color,
              value: entry.value,
              title: '${entry.key}\n(${percentage.toStringAsFixed(0)}%)',
              radius: 50,
              titleStyle: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color:
                    color.computeLuminance() > 0.5
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight, // Better contrast
                shadows: [const Shadow(color: Colors.black26, blurRadius: 2)],
              ),
              titlePositionPercentageOffset: 0.55,
            );
          }).toList(),
    );
  }

  BarChartData _buildMonthlySpendingChartData(
    ThemeData theme,
    bool isDarkMode,
  ) {
    final onSurfaceColor = theme.colorScheme.onSurface;
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 1500,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          //tooltipBgColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          tooltipPadding: const EdgeInsets.all(AppDimensions.sm),
          tooltipMargin: AppDimensions.sm,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${_months[group.x.toInt()]}\n',
              GoogleFonts.roboto(
                color: rod.color ?? theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'KES ${rod.toY.round()}',
                  style: GoogleFonts.roboto(
                    color: onSurfaceColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              final index = value.toInt();
              if (index < 0 || index >= _months.length) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                ///axisSide: meta.axisSide,
                space: AppDimensions.xs,
                meta: meta,
                child: Text(
                  _months[index],
                  style: TextStyle(
                    color: onSurfaceColor.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            reservedSize: 28,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 300,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value % 300 == 0 && value >= 0) {
                return SideTitleWidget(
                  //axisSide: meta.axisSide,
                  space: 0,
                  meta: meta,
                  child: Text(
                    NumberFormat.compact().format(value.toInt()),
                    style: TextStyle(
                      color: onSurfaceColor.withOpacity(0.7),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.left,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups:
          _monthlySpending
              .map(
                (data) => data.copyWith(
                  barRods:
                      data.barRods
                          .map(
                            (rod) => rod.copyWith(
                              color: theme.colorScheme.secondary.withOpacity(
                                0.8,
                              ),
                            ),
                          )
                          .toList(),
                ),
              )
              .toList(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 300,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: onSurfaceColor.withOpacity(0.1), strokeWidth: 1);
        },
      ),
    );
  }
}
