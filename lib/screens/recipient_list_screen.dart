import 'package:flutter/material.dart';

class RecipientListScreen extends StatelessWidget {
  final String userId;

  const RecipientListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipients'),
      ),
      body: Center(
        child: Text(
          'List of Recipients for User ID: $userId',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
