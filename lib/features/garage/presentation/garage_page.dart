import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class GaragePage extends StatelessWidget {
  const GaragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Virtual Garage')),
      body: ListView(
        padding: const EdgeInsets.all(HBSpacing.md),
        children: [
          const Text('Manage your vehicles for time attacks and meets.'),
          const SizedBox(height: HBSpacing.lg),
          _VehicleCard(
            make: 'Toyota',
            model: 'GR86',
            year: '2023',
            color: HBColors.primary,
          ),
          const SizedBox(height: HBSpacing.md),
          OutlinedButton.icon(
            onPressed: () {
              // Add vehicle logic
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Add Vehicle'),
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final String make;
  final String model;
  final String year;
  final Color color;

  const _VehicleCard({
    required this.make,
    required this.model,
    required this.year,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.directions_car, color: color, size: 40),
        title: Text('$year $make $model', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('0 Time Attack Records'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // View vehicle details
        },
      ),
    );
  }
}
