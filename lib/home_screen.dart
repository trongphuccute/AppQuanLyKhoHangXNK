import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Features/Reports/reports_screen.dart';
import 'Features/Products/products_screen.dart';
import 'Features/customer/customer_list_screen.dart';
import 'Features/trade/GiaoDichScreen.dart';
import 'Features/Setting/CaiDat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalCustomers = 0;
  int totalProducts = 0;
  int totalTransactions = 0;
  int totalRevenue = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    final customersSnapshot =
        await FirebaseFirestore.instance.collection('customers').get();
    final productsSnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    final giaoDichSnapshot =
        await FirebaseFirestore.instance.collection('giao_dich').get();

    double revenue = 0;
    for (var doc in giaoDichSnapshot.docs) {
      final data = doc.data();
      final donGia = (data['donGia'] ?? 0).toInt();
      final soLuong = (data['soLuong'] ?? 0).toInt();
      revenue += donGia * soLuong;
    }

    setState(() {
      totalCustomers = customersSnapshot.size;
      totalProducts = productsSnapshot.size;
      totalTransactions = giaoDichSnapshot.size;
      totalRevenue = revenue.toInt();
    });
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F5),
      appBar: AppBar(
        title: const Text(
          'Trang chủ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildInfoCard(
              title: 'Tồn kho',
              value: totalProducts.toString(),
              icon: Icons.inventory_2,
              iconColor: Colors.blueAccent,
            ),
            _buildInfoCard(
              title: 'Doanh thu',
              value: '$totalRevenue VNĐ',
              icon: Icons.attach_money,
              iconColor: Colors.green,
            ),
            _buildInfoCard(
              title: 'Giao dịch',
              value: totalTransactions.toString(),
              icon: Icons.swap_horiz,
              iconColor: Colors.orange,
            ),
            _buildInfoCard(
              title: 'Khách hàng',
              value: totalCustomers.toString(),
              icon: Icons.people,
              iconColor: Colors.purple,
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CaiDatScreen()),
            );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomerListScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: const Text('Giao dịch'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GiaoDichScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Báo cáo'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportScreen()),
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
                    MaterialPageRoute(builder: (_) => const ProductsScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
