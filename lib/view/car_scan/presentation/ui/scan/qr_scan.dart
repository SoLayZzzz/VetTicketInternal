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

class QRCodeCarScan extends GetView<ScanTicketController> {
  const QRCodeCarScan({super.key});

  @override
  Widget build(BuildContext context) {
    const scanBoxSize = 300.0;
    final screenSize = MediaQuery.of(context).size;
    final scanBoxCenter = Offset(screenSize.width / 2, screenSize.height / 2.8);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.uiState.value.controllerQr.value.start();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _button(),
      appBar: appBarDefault(
        title: "ស្កែន QR កូដឡើងឡាន",
        onPressed: () {
          controller.uiState.value.controllerQr.value.stop();
          Get.back();
        },
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: controller.uiState.value.controllerQr.value,
            onDetect: controller.onDectQR,
          ),

          // Dimmed overlay with transparent hole
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

          // Scan box corner borders
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
                onPressed: controller.toggleZoom,
                icon: const Icon(
                  Icons.center_focus_strong,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Obx(() => IconButton(
                    onPressed: () {
                      controller.uiState.value.isFlashOn.toggle();
                      controller.uiState.value.controllerQr.value.toggleTorch();
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
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          visualDensity: VisualDensity.compact,
                          value:
                              controller.uiState.value.isContinuousScan.value,
                          onChanged: (v) {
                            controller.uiState.value.isContinuousScan.value =
                                v!;
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
