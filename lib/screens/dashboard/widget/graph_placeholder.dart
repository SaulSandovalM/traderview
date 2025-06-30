import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphPlaceholder extends StatelessWidget {
  const GraphPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Historial",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: BarChart(
                BarChartData(
                  barGroups: _buildBarGroups(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const months = [
                            'Ene',
                            'Feb',
                            'Mar',
                            'Abr',
                            'May',
                            'Jun',
                            'Jul',
                            'Ago',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dic'
                          ];
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barTouchData: BarTouchData(enabled: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final thisYear = [
      50.0,
      80.0,
      60.0,
      70.0,
      45.0,
      90.0,
      70.0,
      65.0,
      60.0,
      75.0,
      85.0,
      40.0
    ];
    final lastYear = [
      40.0,
      60.0,
      45.0,
      55.0,
      35.0,
      70.0,
      55.0,
      50.0,
      48.0,
      60.0,
      70.0,
      30.0
    ];

    return List.generate(12, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: thisYear[index],
            width: 7,
            color: const Color(0xFF7065F0),
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: lastYear[index],
            width: 7,
            color: const Color(0xFFB3AAFD),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
