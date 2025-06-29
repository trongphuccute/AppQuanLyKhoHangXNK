import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'reports_service.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Báo Cáo')),
      body: FutureBuilder(
        future: Future.wait([
          ReportService.fetchMonthlyRevenue(),
          ReportService.fetchProductSales(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final monthlyData = snapshot.data![0] as Map<String, double>;
          final productSales = snapshot.data![1] as List<Map<String, String>>;

          final sortedMonths = monthlyData.keys.toList()..sort();
          final spots = sortedMonths.asMap().entries.map(
                (e) => FlSpot(
                  e.key.toDouble(),
                  monthlyData[e.value]!,
                ),
              ).toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Doanh thu theo tháng:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: (spots.length - 1).toDouble(),
                      minY: 0,
                      maxY: monthlyData.values.reduce((a, b) => a > b ? a : b) * 1.2,
                      clipData: FlClipData.all(),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.teal,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              int index = value.toInt();
                              if (index >= 0 && index < sortedMonths.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    sortedMonths[index],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, _) {
                              if (value >= 1000000) {
                                return Text('${(value / 1000000).toStringAsFixed(1)}M');
                              } else if (value >= 1000) {
                                return Text('${(value / 1000).toStringAsFixed(0)}K');
                              }
                              return Text('${value.toInt()}');
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tổng sản phẩm đã bán:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...productSales.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('${item['code']} - ${item['name']}     ${item['total']}'),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
