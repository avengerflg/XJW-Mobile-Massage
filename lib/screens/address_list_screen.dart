import 'package:flutter/material.dart';

class AddressListScreen extends StatelessWidget {
  final String userId;

  const AddressListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
      ),
      body: Center(
        child: Text(
          'Address List for User ID: $userId',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
