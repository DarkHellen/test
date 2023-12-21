import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Screen2 extends StatefulWidget {
  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  FlutterBluePlus _flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> _deviceList = [];
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;
  String _dataReceived = '';

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    _device?.disconnect();
    super.dispose();
  }

  void _startScan() {
    _deviceList = [];
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    // Use a delay to stop the scan after a specific duration
    Future.delayed(Duration(seconds: 4), () {
      FlutterBluePlus.stopScan();
    });

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        setState(() {
          _deviceList.add(result.device);
        });
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    // Disconnect if already connected
    if (_device != null && _device!.state == BluetoothDeviceState.connected) {
      await _device!.disconnect();
      setState(() {
        _isConnected = false;
      });
    }

    try {
      await device.connect().then((_) {
        if (device.state == BluetoothDeviceState.connected) {
          setState(() {
            _isConnected = true;
            _device = device;
          });
          _discoverServices();
          _listenForData();
        }
      });
    } catch (error) {
      print("Error connecting to the device: $error");
    }
  }

  Future<void> _discoverServices() async {
    try {
      List<BluetoothService> services = await _device!.discoverServices();
      services.forEach((service) {
        print('Service: ${service.uuid}');
        service.characteristics.forEach((characteristic) {
          setState(() {
            _characteristic = characteristic;
          });
          print('Characteristic: ${characteristic.uuid}');
        });
      });
    } catch (error) {
      print("Error discovering services: $error");
    }
  }

  void _sendData(String data) async {
    if (_characteristic == null) return;
    List<int> bytes = utf8.encode(data);
    await _characteristic!.write(bytes);
  }

  void _listenForData() {
    if (_characteristic == null) return;
    _characteristic!.setNotifyValue(true);
    _characteristic!.value.listen((value) {
      setState(() {
        _dataReceived = utf8.decode(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              child: TextField(
                onChanged: (text) {
                  _sendData(text);
                },
                decoration: InputDecoration(
                  hintText: 'Type custom text',
                ),
              ),
            ),
            Text('Data received: $_dataReceived'),
            ElevatedButton(
              onPressed: () {
                _startScan();
              },
              child: Text('Start Scan'),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _deviceList.length,
              itemBuilder: (BuildContext context, int index) {
                BluetoothDevice device = _deviceList[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown'),
                  subtitle: Text(device.id.toString()),
                  onTap: () {
                    _connectToDevice(device);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
