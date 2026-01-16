// ignore_for_file: unnecessary_null_comparison


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vet_internal_ticket/components/appbar.dart';
import 'package:vet_internal_ticket/components/container_component.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/controller/scan_ticket_controller.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/ui/other/custom_painters.dart';

import '../../../../../utils/bottom_sheets/button.dart';

class BarCodeCarScan extends GetView<ScanTicketController> {
  const BarCodeCarScan({super.key});

  @override
  Widget build(BuildContext context) {
    const scanBoxSize = 300.0;
    final screenSize = MediaQuery.of(context).size;
    final scanBoxCenter = Offset(screenSize.width / 2, screenSize.height / 2.8);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.uiState.value.controllerBarCode.value.start();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _button(),
      appBar: appBarDefault(
        title: "Mobile ស្កេនឡើងឡាន",
        onPressed: () {
          controller.uiState.value.controllerBarCode.value.stop();
          Get.back();
        },
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.uiState.value.controllerBarCode.value,
            onDetect: controller.onDetecBarCode,
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: DimmedOverlayWithHole(
                hole: Rect.fromCenter(
                  center: scanBoxCenter,
                  width: scanBoxSize,
                  height: scanBoxSize,
                ),
              ),
            ),
          ),
          Positioned(
            left: scanBoxCenter.dx - scanBoxSize / 2,
            top: scanBoxCenter.dy - scanBoxSize / 2,
            child: SizedBox(
              width: scanBoxSize,
              height: scanBoxSize,
              child: CustomPaint(
                painter: ScanBoxPainter(),
              ),
            ),
          ),
          _buildTitle(),
        ],
      ),
    );
  }

  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.small, vertical: AppPadding.medium),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.center_focus_strong,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Obx(() => IconButton(
                    onPressed: () {
                      controller.uiState.value.isFlashOn.toggle();
                      controller.uiState.value.controllerBarCode.value
                          .toggleTorch();
                    },
                    icon: Icon(
                      controller.uiState.value.isFlashOn.value
                          ? Icons.flash_on
                          : Icons.flash_off,
                      color: Colors.white,
                      size: 28,
                    ),
                  )),
            ],
          ),
          Obx(() => Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.large),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          visualDensity: VisualDensity.compact,
                          value: controller.uiState.value.isZoomEnabled.value,
                          onChanged: (v) {
                            controller.uiState.value.isZoomEnabled.value = v!;
                            controller.uiState.value.controllerBarCode.value
                                .setZoomScale(v ? 0.5 : 0.0);
                          },
                        ),
                        const Text("ស្កេនបន្ត"),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _button() {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.drawerColor,
                offset: Offset(2, 2),
                spreadRadius: 2,
                blurRadius: 2),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          child: ContainerComponent(
            color: Colors.white,
            child: Button(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.primaryColor,
              onTap: () {
                Get.back();
              },
              child: const TextMedium(
                text: "បោះបង់",
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
