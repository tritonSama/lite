import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hblite/features/obd/domain/obd_service.dart';

class ObdScreen extends ConsumerStatefulWidget {
  const ObdScreen({super.key});

  @override
  ConsumerState<ObdScreen> createState() => _ObdScreenState();
}

class _ObdScreenState extends ConsumerState<ObdScreen> {
  final TextEditingController _macAddressController = TextEditingController();

  @override
  void dispose() {
    _macAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obdState = ref.watch(obdStateProvider);
    final obdNotifier = ref.read(obdStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('OBD2 Telemetry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!obdState.isConnected) ...[
              TextField(
                controller: _macAddressController,
                decoration: const InputDecoration(
                  labelText: 'OBD2 Mac Address (e.g., 00:1D:A5:00:11:22)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final address = _macAddressController.text.trim();
                  if (address.isNotEmpty) {
                    obdNotifier.connect(address);
                  }
                },
                child: const Text('Connect'),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Connected',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'RPM: ${obdState.rpm}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Speed: ${obdState.speed} km/h',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          obdNotifier.disconnect();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Disconnect',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
