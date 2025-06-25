class GiaoDich {
  String ten;
  String sdt;
  String maDon;
  int soLuong;
  DateTime ngay;
  int donGia;

  GiaoDich({
    required this.ten,
    required this.sdt,
    required this.maDon,
    required this.soLuong,
    required this.ngay,
    required this.donGia,
  });

  int get tongTien => donGia * soLuong;
}