import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/components/appbar.dart';
import 'package:vet_internal_ticket/components/container_component.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/utils/dimension.dart';
import 'package:vet_internal_ticket/view/car_scan/presentation/controller/scan_ticket_controller.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/widget/seat_layout.dart';

import '../../../../../utils/bottom_sheets/button.dart';
import '../../../../../utils/bottom_sheets/select_bus.dart';

class ScanTicketScreen extends GetView<ScanTicketController> {
  const ScanTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault(
        title: "ស្គែនសំបុត្រឡើងឡាន",
        onPressed: () => Get.back(),
      ),
      bottomNavigationBar: _buildBottomnavigationBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Obx(() =>
              _buildSelectBus(),
              // ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.uiState.value.selectedBus.value == null) {
                  return SizedBox();
                }

                if (controller.uiState.value.isLoading.value) {
                  return const Center(
                    child: null,
                  );
                }

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildScanButton(),
                      _buildInformation(),
                      const SizedBox(height: 10),
                      Expanded(child: _buildListSeat()),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomnavigationBar() {
    return Obx(() {
      final hasSelected = controller.uiState.value.selectedSeats.isNotEmpty;
      return hasSelected
          ? BottomAppBar(
              color: Colors.white,
              child: ContainerComponent(
                child: Button(
                  onTap: () async {},
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  child: const TextMedium(
                    text: "ឡានចេញដំណើរ",
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink();
    });
  }

  _buildSelectBus() {
    return Obx(() {
      if (controller.uiState.value.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final busModel = controller.uiState.value.busList.value;
      bool hasData = false;
      List<String> buses = ["Hello", "Hi"];

      if (busModel != null &&
          busModel.header?.statusCode == 200 &&
          busModel.header?.result == true &&
          busModel.body != null &&
          busModel.body!.isNotEmpty) {
        buses = busModel.body!.map((e) => e.name ?? "Unnamed").toList();
        hasData = true;
      }

      return SelectBus(
        appBarBackgroundColorChooseScreen: AppColors.primaryColor,
        bustListData: buses,
        title: "ជ្រើសរើសឡាន",
        titleTextField: "ជ្រើសរើសឡាន",
        suffixIcon: AppIcons.IC_search,
        assetImage: const AssetImage(AppIcons.IC_search),
        hasData: hasData,
        showChooseScreen: true,
        borderRadius: BorderRadius.circular(5),
        borderColor: AppColors.borderColor,
        textStyle: const TextStyle(color: AppColors.textColor),
        text: controller.uiState.value.selectedBus.value,
        // onSelected: (index) {
        //   final selected = buses[index];
        //   controller.selectBus(selected);
        // },
        onSelected: (index) {
          final selected = buses[index];
          controller.selectBus(selected);

          final busId = busModel?.body?[index].id ?? "";
          if (busId.isNotEmpty) {
            controller.fetchSeatCheckinLayout(busId);
          }
        },
      );
    });
  }

  Widget _buildScanButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Button(
            onTap: () {
              controller.uiState.value.currentScanType = "2";
              controller.reInitScannerControllers();
              Get.toNamed(AppRoutes.qr_code_car_scan);

              final type = controller.uiState.value.currentScanType = "2";
              print("Rote to scanQR $type");
            },
            height: 55,
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppIcons.IC_ticket_scanner,
                    color: AppColors.whiteColor, height: Dimension.iconSize24),
                const SizedBox(width: Dimension.padding6),
                const Text(
                  "ស្កែន QR កូដឡើងឡាន",
                  style: TextStyle(color: AppColors.whiteColor),
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: Dimension.padding10),
        Expanded(
          child: Button(
            onTap: () {
              controller.uiState.value.currentScanType = "2";
              controller.reInitScannerControllers();
              Get.toNamed(AppRoutes.bar_code_car_scan);

              final type = controller.uiState.value.currentScanType = "2";
              print("Rote to scanQR $type");
            },
            height: 55,
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppIcons.IC_mobile_scan,
                    color: AppColors.whiteColor, height: Dimension.iconSize24),
                const SizedBox(width: Dimension.padding6),
                const Text(
                  "Mobile ស្កែនឡើងឡាន",
                  style: TextStyle(color: AppColors.whiteColor),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInformation() {
    final res = controller.uiState.value.checkinLayoutModel.value?.body;

    final totalBookedSeats = res?.seatSelected?.length ?? 0;
    final totalCheckedInSeats =
        res?.seatSelected?.where((seat) => seat.checkIn == 1).length ?? 0;
    return Padding(
      padding: const EdgeInsets.only(top: Dimension.padding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'កៅអីបានលក់ៈ ', style: TextStyle()),
                      TextSpan(
                          text: totalBookedSeats.toString(),
                          style: TextStyle()),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'កៅអីបានឡើងៈ ', style: TextStyle()),
                      TextSpan(
                          text: totalCheckedInSeats.toString(),
                          style: TextStyle()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'ម៉ោងចេញៈ ', style: TextStyle()),
                TextSpan(text: '${res?.departure}', style: TextStyle()),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'ទិសដៅៈ ', style: TextStyle()),
                TextSpan(
                  text: '${res?.destinationTo}',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 1, width: double.infinity, color: Colors.grey),
        ],
      ),
    );
  }

  // =======>>

  Widget _buildListSeat() {
    return Obx(() {
      if (controller.uiState.value.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final body = controller.uiState.value.checkinLayoutModel.value?.body;
      if (body == null || (body.layoutSeat ?? '').isEmpty) {
        return const Center(child: Text("មិនមានទិន្នន័យកៅអី"));
      }

      final layoutJson = body.layoutSeat!;

      return SeatLayoutWidget(
        layoutJson: layoutJson,
        scannedSeats: controller.scannedSeats,
        bookedSeats: controller.bookedSeats,
        selectedSeats: controller.uiState.value.selectedSeats,
        onSeatTap: (value, label) =>
            controller.toggleSeatSelection(value, label),
      );
    });
  }
}
