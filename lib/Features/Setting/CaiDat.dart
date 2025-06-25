import 'package:flutter/material.dart';
import '../Products/products_screen.dart';
import '../Reports/reports_screen.dart';
import '/Features/Products/product_service.dart';
import '/Features/Trade/GiaoDichScreen.dart';
import '/Features/customer/customer_screen.dart';
// Import các màn hình khác của bạn ở đây:

class CaiDatScreen extends StatelessWidget {
  const CaiDatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFF9ECEB);
    final Color cardColor = const Color(0xFFF0E6E5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Cài Đặt',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            _buildSettingItem(context, Icons.person, 'user@gmail.com', cardColor),
            _buildSettingItem(context, Icons.bar_chart, 'Báo Cáo', cardColor),
            _buildSettingItem(context, Icons.shopping_cart_outlined, 'Giao Dịch', cardColor),
            _buildSettingItem(context, Icons.people, 'Khách Hàng', cardColor),
            _buildSettingItem(context, Icons.store, 'Kho Hàng', cardColor),
            _buildSettingItem(context, Icons.location_city, 'Cửa Hàng', cardColor),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: (index) {
          // Xử lý chuyển trang nếu cần ở đây
        },
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, Color bgColor) {
    return GestureDetector(
      onTap: () {
        if (title == 'Báo Cáo') {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportScreen()));
        } else if (title == 'Giao Dịch') {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GiaoDichScreen()));
        } else if (title == 'Khách Hàng') {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomerScreen()));
        } else if (title == 'Kho Hàng') {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductsScreen()));
      }},
    
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      )
    );
  }
}
