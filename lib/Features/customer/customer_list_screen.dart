import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_model.dart';
import 'customer_detail_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  Stream<List<Customer>> _getCustomersStream() {
    return FirebaseFirestore.instance
        .collection('customers')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Customer.fromFirestore(doc.data(), doc.id))
                  .toList(),
        );
  }

  Future<void> _deleteCustomer(String id) async {
    await FirebaseFirestore.instance.collection('customers').doc(id).delete();
  }

  void _confirmDelete(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xoá khách hàng'),
            content: Text('Bạn có chắc muốn xoá "${customer.name}" không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Huỷ'),
              ),
              TextButton(
                onPressed: () async {
                  await _deleteCustomer(customer.id);
                  Navigator.pop(context);
                  setState(() {}); // Refresh
                },
                child: const Text('Xoá'),
              ),
            ],
          ),
    );
  }

  void _editCustomer(Customer customer) async {
    final updatedCustomer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerDetailScreen(customer: customer),
      ),
    );

    if (updatedCustomer != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách khách hàng'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<List<Customer>>(
        stream: _getCustomersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final customers = snapshot.data ?? [];

          if (customers.isEmpty) {
            return const Center(child: Text('Chưa có khách hàng nào'));
          }

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(customer.name),
                subtitle: Text(customer.phone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editCustomer(customer),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, customer),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCustomer = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CustomerDetailScreen()),
          );
          if (newCustomer != null) {
            setState(() {});
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
