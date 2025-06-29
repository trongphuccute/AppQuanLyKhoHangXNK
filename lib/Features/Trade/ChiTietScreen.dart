import 'package:flutter/material.dart';
import 'GiaoDich.dart';

class ChiTietScreen extends StatelessWidget {
  final GiaoDich giaoDich;

  const ChiTietScreen({super.key, required this.giaoDich});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết giao dịch')),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      '🧾 HÓA ĐƠN GIAO DỊCH',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(thickness: 2),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildLine('Khách hàng:', giaoDich.ten),
              _buildLine('SĐT:', giaoDich.sdt),
              _buildLine('Mã đơn:', giaoDich.maDon),
              _buildLine('Số lượng:', giaoDich.soLuong.toString()),
              _buildLine('Đơn giá:', '${giaoDich.donGia} đ'),
              const Divider(),
              _buildLine('Tổng tiền:', '${giaoDich.tongTien} đ', isBold: true),
              _buildLine(
                'Ngày:',
                '${giaoDich.ngay.day}/${giaoDich.ngay.month}/${giaoDich.ngay.year}',
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Cảm ơn bạn đã mua hàng!',
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }

  Widget _buildLine(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
