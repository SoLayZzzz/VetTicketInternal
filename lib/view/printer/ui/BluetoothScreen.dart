import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/Textstyle.dart';
import '../../../utils/style_color.dart';
import '../controller/printer_settingVewModel.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrinterSettingController());

    return Scaffold(
      backgroundColor: StyleColor.background,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        backgroundColor: StyleColor.secondColor,
        elevation: 2,
        title: Text('Choose Printer', style: StyleText.titleAppbar),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isScanning.value) {
                return _buildLoadingState();
              } else if (controller.devicesList.isEmpty) {
                return Center(
                  child: Text('No devices found', style: StyleText.label9),
                );
              } else {
                return _buildDeviceList(controller);
              }
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: controller.isScanning.value ? null : controller.startScan,
          backgroundColor: controller.isScanning.value
              ? Colors.grey
              : StyleColor.secondColor,
          child: const Icon(Icons.search, color: Colors.white),
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
              color: StyleColor.secondColor, strokeWidth: 3),
          const SizedBox(height: 16),
          Text('Scanning for printers...', style: StyleText.label9),
        ],
      ),
    );
  }

  Widget _buildDeviceList(PrinterSettingController controller) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: controller.devicesList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Obx(() {
          final deviceInfo = controller.devicesList[index].split(' - ');
          final deviceName = deviceInfo[0];
          final deviceAddress = deviceInfo[1];
          final deviceType = deviceInfo[2];
          final isConnecting = controller.connectingDevices[deviceAddress] ?? false;

          return ListTile(
            leading: Icon(Icons.bluetooth, color: StyleColor.orange),
            title: Text(deviceName, style: StyleText.titleList),
            subtitle: Text(deviceAddress, style: StyleText.label7),
            trailing: isConnecting
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : ElevatedButton(
              onPressed: () async {

                controller.connectingDevices[deviceAddress] = true;
                await controller.connectToDevice(deviceAddress,deviceName,deviceType);
                controller.connectingDevices[deviceAddress] = false;

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: StyleColor.secondColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Connect', style: StyleText.titleButton),
            ),
          );
        });
      },
    );
  }
}
