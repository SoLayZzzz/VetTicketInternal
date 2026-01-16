/// Represents the current state of the Bluetooth adapter.
enum BluetoothState {
  /// Bluetooth is not available on this device
  UNKNOWN,
  
  /// Bluetooth is not available on this device
  UNAVAILABLE,
  
  /// Bluetooth is not enabled and needs to be turned on
  TURNING_ON,
  
  /// Bluetooth is on and ready for use
  ON,
  
  /// Bluetooth is currently turning off
  TURNING_OFF,
  
  /// Bluetooth is currently turning on
  OFF,
  
  /// The device is not connected to any Bluetooth devices
  DISCONNECTED,
  
  /// The device is in the process of connecting to a Bluetooth device
  CONNECTING,
  
  /// The device is connected to a Bluetooth device
  CONNECTED,
  
  /// The device is disconnecting from a Bluetooth device
  DISCONNECTING,
  
  /// An error occurred during a Bluetooth operation
  ERROR,
}

extension BluetoothStateExtension on BluetoothState {
  /// Returns a user-friendly string representation of the state
  String get displayName {
    switch (this) {
      case BluetoothState.UNKNOWN:
        return 'Unknown';
      case BluetoothState.UNAVAILABLE:
        return 'Unavailable';
      case BluetoothState.TURNING_ON:
        return 'Turning On...';
      case BluetoothState.ON:
        return 'On';
      case BluetoothState.TURNING_OFF:
        return 'Turning Off...';
      case BluetoothState.OFF:
        return 'Off';
      case BluetoothState.DISCONNECTED:
        return 'Disconnected';
      case BluetoothState.CONNECTING:
        return 'Connecting...';
      case BluetoothState.CONNECTED:
        return 'Connected';
      case BluetoothState.DISCONNECTING:
        return 'Disconnecting...';
      case BluetoothState.ERROR:
        return 'Error';
    }
  }
  
  /// Returns true if the state indicates an active connection
  bool get isConnected => this == BluetoothState.CONNECTED;
  
  /// Returns true if the state indicates a connection in progress
  bool get isConnecting => this == BluetoothState.CONNECTING;
  
  /// Returns true if the state indicates a disconnection in progress
  bool get isDisconnecting => this == BluetoothState.DISCONNECTING;
  
  /// Returns true if the state indicates not connected
  bool get isDisconnected => this == BluetoothState.DISCONNECTED || 
                           this == BluetoothState.OFF ||
                           this == BluetoothState.UNAVAILABLE;
}
