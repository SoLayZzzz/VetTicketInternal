import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

// Add this to track the stream controller
class _BluetoothServiceController {
  final StreamController<Map<String, dynamic>> _controller;
  final StreamSubscription<dynamic> _subscription;

  _BluetoothServiceController(this._controller, this._subscription);

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}

class BluetoothService {
  static const MethodChannel _channel = MethodChannel('bluetooth_service');
  static const EventChannel _scanResultsChannel =
      EventChannel('bluetooth_scan_results');

  // Track the active scan controller
  static _BluetoothServiceController? _scanController;

  // Check if Bluetooth is available
  static Future<bool> get isAvailable async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('isBluetoothAvailable');
    }
    return false;
  }

  // Check if Bluetooth is enabled
  static Future<bool> get isEnabled async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('isBluetoothEnabled');
    }
    return false;
  }

  // Request to enable Bluetooth
  static Future<bool> requestEnable() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('requestEnableBluetooth');
    }
    return false;
  }

  // Start scanning for Bluetooth devices
  static Stream<Map<String, dynamic>> startScan() {
    if (Platform.isAndroid) {
      // Cancel any existing scan
      _scanController?.dispose();

      final controller = StreamController<Map<String, dynamic>>.broadcast();

      try {
        _channel.invokeMethod('startScan');

        final subscription = _scanResultsChannel
            .receiveBroadcastStream()
            .map((event) => Map<String, dynamic>.from(jsonDecode(event)))
            .listen(
          controller.add,
          onError: (error) {
            if (kDebugMode) {
              print('Bluetooth scan error: $error');
            }
            controller.addError(error);
          },
          onDone: controller.close,
          cancelOnError: false,
        );

        _scanController = _BluetoothServiceController(controller, subscription);
        return controller.stream;
      } catch (e) {
        controller.addError(e);
        return controller.stream;
      }
    }
    return const Stream.empty();
  }

  // Stop scanning for Bluetooth devices
  static Future<void> stopScan() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('stopScan');
      } catch (e) {
        if (kDebugMode) {
          print('Error stopping scan: $e');
        }
      } finally {
        _scanController?.dispose();
        _scanController = null;
      }
    }
  }

  // Connect to a Bluetooth device
  static Future<bool> connect(String address) async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('connect', {'address': address});
    }
    return false;
  }

  // Disconnect from the current device
  static Future<void> disconnect() async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('disconnect');
    }
  }

  // Send data to the connected device
  static Future<bool> sendData(List<int> data) async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('sendData', {'data': data});
    }
    return false;
  }

  // Check if device is connected
  static Future<bool> get isConnected async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('isConnected');
    }
    return false;
  }
}
