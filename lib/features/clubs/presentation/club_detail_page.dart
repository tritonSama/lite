import 'package:flutter/material.dart';

class ClubDetailPage extends StatelessWidget {
  final String clubId;

  const ClubDetailPage({required this.clubId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Club Details')),
      body: Center(child: Text('Club ID: $clubId')),
    );
  }
}
