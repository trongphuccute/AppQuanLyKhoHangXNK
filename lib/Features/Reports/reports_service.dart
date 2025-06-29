import 'package:cloud_firestore/cloud_firestore.dart';
import '../Trade/GiaoDich.dart';

class ReportService {
  // Tính tổng doanh thu theo tháng từ các giao dịch trong Firestore
  static Future<Map<String, double>> fetchMonthlyRevenue() async {
    final snapshot = await FirebaseFirestore.instance.collection('giao_dich').get();
    final data = snapshot.docs.map((doc) => GiaoDich.fromFirestore(doc.data(), doc.id)).toList();

    final Map<String, double> revenueMap = {};

    for (var gd in data) {
      final key = '${gd.ngay.month.toString().padLeft(2, '0')}/${gd.ngay.year}';
      revenueMap[key] = (revenueMap[key] ?? 0) + gd.tongTien.toDouble();
    }

    return revenueMap;
  }

  // Tính tổng sản phẩm đã bán theo mã đơn (maDon)
  static Future<List<Map<String, String>>> fetchProductSales() async {
    final snapshot = await FirebaseFirestore.instance.collection('giao_dich').get();
    final data = snapshot.docs.map((doc) => GiaoDich.fromFirestore(doc.data(), doc.id)).toList();

    final Map<String, int> sanPhamMap = {};
    final Map<String, int> tongTienMap = {};

    for (var gd in data) {
      sanPhamMap[gd.maDon] = (sanPhamMap[gd.maDon] ?? 0) + gd.soLuong;
      tongTienMap[gd.maDon] = (tongTienMap[gd.maDon] ?? 0) + gd.tongTien;
    }

    return sanPhamMap.entries.map((e) {
      final ma = e.key;
      final ten = _tenSanPham(ma); // Dịch mã sang tên
      final tong = tongTienMap[ma] ?? 0;

      return {
        'code': ma,
        'name': ten,
        'total': '${tong.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')} VNĐ',
      };
    }).toList();
  }

  // Tùy chọn: dịch mã sản phẩm thành tên để dễ hiểu
  static String _tenSanPham(String ma) {
    switch (ma) {
      case '#AT':
        return 'Áo Thun';
      case '#AK':
        return 'Áo Khoác';
      case '#QJ':
        return 'Quần Jean';
      case '#QK':
        return 'Quần Kaki';
      case '#QJN':
        return 'Quần Jean Nữ';
      default:
        return 'Sản phẩm khác';
    }
  }
}
