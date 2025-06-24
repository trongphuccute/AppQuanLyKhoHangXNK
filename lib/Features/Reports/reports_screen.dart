import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final revenueData = {
      'Jan': 1.2,
      'Feb': 2.4,
      'Mar': 3.5,
      'Apr': 2.9,
      'May': 3.8,
      'Jun': 4.5,
    };

    final productSales = [
      {'code': '#AT', 'name': 'Áo Thun', 'total': '1.150.000VNĐ'},
      {'code': '#AK', 'name': 'Áo Khoác', 'total': '2.100.000VNĐ'},
      {'code': '#QJ', 'name': 'Quần Jean', 'total': '3.250.000VNĐ'},
      {'code': '#QK', 'name': 'Quần Kaki', 'total': '1.220.000VNĐ'},
      {'code': '#QJN', 'name': 'Quần Jean Nữ', 'total': '7.150.000VNĐ'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Báo Cáo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Doanh thu theo tháng:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.teal,
                      spots: revenueData.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                          .toList(),
                      barWidth: 4,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < revenueData.keys.length) {
                            return Text(revenueData.keys.elementAt(index), style: const TextStyle(fontSize: 12));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Tổng sản phẩm đã bán được:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...productSales.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${item['code']} - ${item['name']}     ${item['total']}'),
                )),
          ],
        ),
      ),
    );
  }
}
