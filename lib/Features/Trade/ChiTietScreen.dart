import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Trade/GiaoDich.dart';


class ChiTietScreen extends StatelessWidget {
  final GiaoDich giaoDich;

  const ChiTietScreen({super.key, required this.giaoDich});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết giao dịch')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên: ${giaoDich.ten}'),
            Text('SĐT: ${giaoDich.sdt}'),
            Text('Mã đơn: ${giaoDich.maDon}'),
            Text('Số lượng: ${giaoDich.soLuong}'),
            Text('Đơn giá: ${giaoDich.donGia} đ'),
            Text('Tổng tiền: ${giaoDich.tongTien} đ'),
            Text('Ngày: ${giaoDich.ngay.day}/${giaoDich.ngay.month}/${giaoDich.ngay.year}'),
          ],
        ),
      ),
    );
  }
}