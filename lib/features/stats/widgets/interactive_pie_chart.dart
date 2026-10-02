import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../providers/stats_provider.dart';

class InteractivePieChart extends StatelessWidget {
  final List<CategoryStatItem> items;
  final double totalAmount;
  final int touchedIndex;
  final ValueChanged<int> onTouch;
  final String centerTitle;

  const InteractivePieChart({
    super.key,
    required this.items,
    required this.totalAmount,
    required this.touchedIndex,
    required this.onTouch,
    required this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty || totalAmount <= 0) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        child: const Text(
          'No data available for this period',
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    onTouch(-1);
                    return;
                  }
                  onTouch(pieTouchResponse.touchedSection!.touchedSectionIndex);
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 3,
              centerSpaceRadius: 65,
              sections: List.generate(items.length, (i) {
                final isTouched = i == touchedIndex;
                final item = items[i];
                final radius = isTouched ? 42.0 : 34.0;
                final fontSize = isTouched ? 12.0 : 10.0;

                return PieChartSectionData(
                  color: item.color,
                  value: item.amount,
                  title: '${item.percentage.toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: const [
                      Shadow(color: Colors.black45, blurRadius: 4),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Center Summary Info
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                touchedIndex >= 0 && touchedIndex < items.length
                    ? items[touchedIndex].categoryName
                    : centerTitle,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                CurrencyFormatter.format(
                  touchedIndex >= 0 && touchedIndex < items.length
                      ? items[touchedIndex].amount
                      : totalAmount,
                ),
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Sora',
                ),
              ),
              if (touchedIndex >= 0 && touchedIndex < items.length)
                Text(
                  '${items[touchedIndex].percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: items[touchedIndex].color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
