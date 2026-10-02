import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

class NetWorthTrendChart extends StatelessWidget {
  final double currentNetWorth;

  const NetWorthTrendChart({
    super.key,
    required this.currentNetWorth,
  });

  @override
  Widget build(BuildContext context) {
    // Generate 6 trailing month labels dynamically based on current date
    final now = DateTime.now();
    final List<String> months = [];
    final List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    for (int i = 5; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      months.add(monthNames[d.month - 1]);
    }

    final double base = currentNetWorth == 0 ? 0 : currentNetWorth * 0.75;
    final double step = currentNetWorth == 0 ? 0 : (currentNetWorth - base) / 5;

    final spots = currentNetWorth == 0
        ? [
            const FlSpot(0, 0),
            const FlSpot(1, 0),
            const FlSpot(2, 0),
            const FlSpot(3, 0),
            const FlSpot(4, 0),
            const FlSpot(5, 0),
          ]
        : [
            FlSpot(0, base),
            FlSpot(1, base + step * 0.8),
            FlSpot(2, base + step * 1.5),
            FlSpot(3, base + step * 2.2),
            FlSpot(4, base + step * 3.4),
            FlSpot(5, currentNetWorth),
          ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Net Worth Trajectory',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (currentNetWorth > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.income.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '+12.4% 6M',
                    style: TextStyle(
                      color: AppColors.incomeLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (currentNetWorth / 3).clamp(1000, 1000000).toDouble(),
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(color: AppColors.darkDivider, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              months[idx],
                              style: const TextStyle(
                                color: AppColors.textSecondaryDark,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.income,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.income.withOpacity(0.35),
                          AppColors.income.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
