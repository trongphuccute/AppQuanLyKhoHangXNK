import 'package:flutter/material.dart';
import 'Features/Reports/reports_screen.dart';
import 'Features/Products/products_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildInfoCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildRevenueChartWithAxis(
    List<Map<String, dynamic>> data,
    double maxY,
  ) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${maxY.toInt()}'),
                Text('${(maxY / 2).toInt()}'),
                const Text('0'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  data.map((item) {
                    double percentage = (item['value'] as double) / maxY;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 30,
                          height: 150 * percentage,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Khách hàng'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Chuyển trang Khách hàng
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: const Text('Giao dịch'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Chuyển trang Giao dịch
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Báo cáo'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.warehouse),
                title: const Text('Kho hàng'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Cửa hàng'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Chuyển trang Cửa hàng
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final revenueData = [
      {'label': 'T2', 'value': 45.0},
      {'label': 'T4', 'value': 60.0},
      {'label': 'T7', 'value': 30.0},
      {'label': 'CN', 'value': 90.0},
    ];
    final maxY = 100.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trang chủ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildInfoCard('Tồn kho', '120'),
                _buildInfoCard('Doanh thu', '#5.000.000'),
                _buildInfoCard('Giao dịch', '20'),
                _buildInfoCard('Khách hàng', '7'),
              ],
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Doanh Thu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            _buildRevenueChartWithAxis(revenueData, maxY),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tồn kho',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'sản phẩm',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'số lượng',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text('Áo Thun'), Text('20 Cái')],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text('Quần Jean'), Text('40 Cái')],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text('Áo Khoác Dù'), Text('60 Cái')],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            _showMenuBottomSheet(context);
          } else if (index == 2) {
            // TODO: Chuyển đến Hồ sơ
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang Chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ Sơ'),
        ],
      ),
    );
  }
}
