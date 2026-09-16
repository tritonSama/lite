import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class OfferDetailPage extends StatelessWidget {
  final String offerId;
  const OfferDetailPage({required this.offerId, super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Offer Details')),
        body: Center(child: Text('Offer: $offerId — Sprint 4')),
      );
}
