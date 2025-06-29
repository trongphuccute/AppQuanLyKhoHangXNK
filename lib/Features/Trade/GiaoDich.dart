import 'package:cloud_firestore/cloud_firestore.dart';

class GiaoDich {
  final String id;
  final String ten;
  final String sdt;
  final String maDon;
  final int soLuong;
  final DateTime ngay;
  final int donGia;

  GiaoDich({
    required this.id,
    required this.ten,
    required this.sdt,
    required this.maDon,
    required this.soLuong,
    required this.ngay,
    required this.donGia,
  });

  int get tongTien => donGia * soLuong;

  factory GiaoDich.fromFirestore(Map<String, dynamic> data, String docId) {
    return GiaoDich(
      id: docId,
      ten: data['ten'] ?? '',
      sdt: data['sdt'] ?? '',
      maDon: data['maDon'] ?? '',
      soLuong: data['soLuong'] ?? 0,
      ngay: (data['ngay'] as Timestamp).toDate(),
      donGia: data['donGia'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ten': ten,
      'sdt': sdt,
      'maDon': maDon,
      'soLuong': soLuong,
      'ngay': ngay,
      'donGia': donGia,
    };
  }
}
