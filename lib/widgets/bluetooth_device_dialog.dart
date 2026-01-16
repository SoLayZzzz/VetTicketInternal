import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vet_internal_ticket/services/bluetooth_service.dart';

class BluetoothDeviceDialog extends StatefulWidget {
  const BluetoothDeviceDialog({Key? key}) : super(key: key);

  @override
  _BluetoothDeviceDialogState createState() => _BluetoothDeviceDialogState();
}

class _BluetoothDeviceDialogState extends State<BluetoothDeviceDialog> {
  final List<Map<String, dynamic>> _devices = [];
  bool _isScanning = false;
  StreamSubscription<Map<String, dynamic>>? _scanSubscription;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _stopScan();
    _scanSubscription?.cancel();
    _scanSubscription = null;
    super.dispose();
  }

  void _startScan() async {
    if (_isScanning) {
      _stopScan();
      return;
    }

    if (_isDisposed) return;

    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    try {
      _scanSubscription?.cancel();
      _scanSubscription = BluetoothService.startScan().listen(
        (device) {
          if (_isDisposed) return;
          
          if (!_devices.any((d) => d['address'] == device['address'])) {
            if (mounted) {
              setState(() {
                _devices.add(device);
              });
            }
          }
        },
        onError: (error) {
          debugPrint('Bluetooth scan error: $error');
          if (mounted && !_isDisposed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error scanning: $error')),
            );
          }
          _handleScanComplete();
        },
        onDone: _handleScanComplete,
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('Error starting scan: $e');
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start scan: $e')),
        );
      }
      _handleScanComplete();
    }
  }

  void _handleScanComplete() {
    if (_isDisposed) return;
    
    if (mounted) {
      setState(() => _isScanning = false);
    }
  }

  void _stopScan() {
    try {
      _scanSubscription?.cancel();
      _scanSubscription = null;
      BluetoothService.stopScan();
    } catch (e) {
      debugPrint('Error stopping scan: $e');
    } finally {
      _handleScanComplete();
    }
  }

  Future<void> _connectToDevice(String address) async {
    try {
      final connected = await BluetoothService.connect(address);
      if (connected && mounted) {
        Navigator.of(context).pop(true);
      } else {
        throw Exception('Failed to connect to device');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'ជ្រើសរើសម៉ាសុីនព្រីន',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isScanning) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ] else if (_devices.isEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                    'No devices found. Make sure your printer is turned on and in pairing mode.'),
              ),
            ],
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  final name = device['name']?.toString() ?? 'Unknown Device';
                  final address = device['address']?.toString() ?? '';

                  return ListTile(
                    leading: const Icon(Icons.print),
                    title: Text(name),
                    subtitle: Text(address),
                    onTap: () => _connectToDevice(address),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('បោះបង់'),
        ),
        TextButton(
          onPressed: _startScan,
          child: Text(_isScanning ? 'ឈប់ស្កេន' : 'ស្កេនម្តងទៀត'),
        ),
      ],
    );
  }
}
