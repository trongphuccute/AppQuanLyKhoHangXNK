class ReportService {
  // Giả lập dữ liệu doanh thu theo tháng (có thể dùng cho biểu đồ cột)
  static Future<Map<String, double>> fetchMonthlyRevenue() async {
    await Future.delayed(const Duration(seconds: 1)); // Giả lập delay mạng
    return {
      'Jan': 1.2,
      'Feb': 2.4,
      'Mar': 3.5,
      'Apr': 2.9,
      'May': 3.8,
      'Jun': 4.5,
    };
  }

  // Giả lập dữ liệu doanh số sản phẩm
  static Future<List<Map<String, String>>> fetchProductSales() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      {'code': '#AT', 'name': 'Áo Thun', 'total': '1.150.000VNĐ'},
      {'code': '#AK', 'name': 'Áo Khoác', 'total': '2.100.000VNĐ'},
      {'code': '#QJ', 'name': 'Quần Jean', 'total': '3.250.000VNĐ'},
    ];
  }
}
