import 'package:flutter_blue/flutter_blue.dart';

class BlueDevice extends ChangeNotifier {
  /// Internal, private state of the Device.
  BluetoothDevice _device;
  BluetoothService _service;

  /// Device metrics
  int heartRate;

  ...

  /// Adds device to model. This is the only way to modify the device from outside.
  void add(BluetoothDevice d) async {
    _device = d;
    await _device.connect();
    _device.discoverServices();
    _device.services.listen((lista) {
      for (int iService = 0; iService < lista.length; iService++) {
        if (lista[iService].uuid.toString().startsWith("YOUR UUID")) {
          _service = lista[iService];
        }
      }
    });
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void read() async {
    List<List> values = [];
    if (_service != null) {
      for (BluetoothCharacteristic c in _service.characteristics) {
        values.add(await c.read());
      }
    }
    heartRate = values[0][0];
    notifyListeners();
  }
}