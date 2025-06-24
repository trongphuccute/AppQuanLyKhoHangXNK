import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ReportChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Text(data[index]['month']);
                }
                return const Text('');
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots:
                data
                    .asMap()
                    .entries
                    .map(
                      (e) =>
                          FlSpot(e.key.toDouble(), e.value['sales'].toDouble()),
                    )
                    .toList(),
            isCurved: true,
            color: Colors.teal,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
