import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/components/container_component.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/seat_controller.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/widget/seat_layout.dart';
import '../../../../components/appbar.dart';
import '../../../../theme/app_padding.dart';
import '../../../../utils/bottom_sheets/button.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';

class SelectSeatScreen extends GetView<SeatController> {
  const SelectSeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      appBar: appBarDefault(
        title: "ជ្រើសរើសកៅអីធ្វើដំណើរ",
        onPressed: () => controller.goBackToSchedule(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
        child: Column(
          children: [
            _buildChooseChair(),
            Obx(() {
              final state = controller.uiState.value;
              if (state.isLoading.value) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }

              final seatModel = state.seatModel.value;
              if (seatModel == null || seatModel.body!.isEmpty) {
                return const Expanded(
                    child: Center(child: Text("No seat data available")));
              }

              final layoutData = seatModel.body!.first.layout;
              if (layoutData == null || layoutData.isEmpty) {
                return const Expanded(
                    child: Center(child: Text("No layout data available")));
              }

              final occupiedSeats = controller.uiState.value.occupiedSeats;
              final selectedSeats = controller.uiState.value.selectedSeats;
              final seatType = seatModel.body!.last.seatType ?? 1;

              return Expanded(
                child: SeatLayoutSceduleWidget(
                  layoutJson: layoutData,
                  occupiedSeats: occupiedSeats,
                  selectedSeats: selectedSeats,
                  onSeatTap: (value, label) =>
                      controller.selectSeat(value, label),
                  seatType: seatType,
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomnavigationBar(),
    );
  }

  Widget _buildBottomnavigationBar() {
    return Obx(() {
      final hasSelectedSeats =
          controller.uiState.value.selectedSeats.isNotEmpty;

      return hasSelectedSeats
          ? Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: AppColors.drawerColor,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 2)
                ],
              ),
              child: BottomAppBar(
                color: Colors.white,
                child: ContainerComponent(
                  color: Colors.white,
                  child: Button(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor,
                    onTap: () => controller.navigateToPassengerDetail(
                        controller.uiState.value.journey),
                    child:
                        const TextMedium(text: "បន្ទាប់", color: Colors.white),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink();
    });
  }

  Widget _buildChooseChair() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.large, vertical: AppPadding.large),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _legendItem(AppIcons.IC_seat_free, "កៅអីទំនេរ"),
          _legendItem(AppIcons.IC_seat_select, "កៅអីជ្រើសរើស"),
          _legendItem(AppIcons.IC_seat_not_free, "កៅអីមិនទំនេរ"),
        ],
      ),
    );
  }

  Widget _legendItem(String icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(icon, height: Dimension.iconSize24),
        const SizedBox(height: Dimension.padding6),
        TextExtraMedium(text: text, fontWeight: FontWeight.w600),
      ],
    );
  }
}
