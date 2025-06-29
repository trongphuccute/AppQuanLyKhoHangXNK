class Customer {
  final String id;
  final String name;
  final String phone;

  Customer({required this.id, required this.name, required this.phone});

  factory Customer.fromFirestore(Map<String, dynamic> data, String docId) {
    return Customer(
      id: docId,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'phone': phone};
  }
}
