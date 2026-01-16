import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/schedule_controller.dart';
import '../../../../utils/bottom_sheets/schedule_list.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';

class ScheduleListScreen extends GetView<ScheduleController> {
  const ScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppColors.whiteColor, size: Dimension.iconSize20),
            // onPressed: () => Get.back(),
            onPressed: () {
              if (controller.uiState.value.isReturnTrip.value) {
                Get.back();
              } else {
                Get.back();
              }
            }),
        centerTitle: true,
        title: Obx(() => Text(
              controller.uiState.value.isReturnTrip.value
                  ? controller.uiState.value.selectDateBack.value
                  : controller.uiState.value.selectDate.value,
              style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: Dimension.fontSize18,
                  fontWeight: FontWeight.w600),
            )),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Image.asset(
              AppIcons.IC_slider_calender,
              height: Dimension.iconSize30,
            ),
            onPressed: () {
              controller.selectDate(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Obx(() => _buildLocationTitle()),
          ),
          _markUP(),
          Obx(() => _buildListData())
        ],
      ),
    );
  }

  Widget _buildLocationTitle() {
    final isReturn = controller.uiState.value.isReturnTrip.value;
    final from = isReturn
        ? controller.uiState.value.toName
        : controller.uiState.value.fromName;
    final to = isReturn
        ? controller.uiState.value.fromName
        : controller.uiState.value.toName;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.medium,
      ),
      child: Row(
        children: [
          Image.asset(AppIcons.IC_location, height: Dimension.iconSize24),
          const SizedBox(width: Dimension.padding10),
          Text(
            '$from - $to',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _markUP() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.medium,
        vertical: AppPadding.large,
      ),
      child: Container(
        height: Get.height / 15,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Text(
                'តម្លៃ Markup',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: Get.height / 20,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() => Text(
                              '${controller.uiState.value.markup.value} \$',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: controller.incrementMarkup,
                            child: const Icon(
                              Icons.keyboard_control_key,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.decrementMarkup,
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListData() {
    if (controller.uiState.value.isLoading.value) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.uiState.value.errorMessage.value.isNotEmpty) {
      return Expanded(
        child: Center(
          child: Text(controller.uiState.value.errorMessage.value),
        ),
      );
    }

    final res = controller.uiState.value.scheduleData.value?.body ?? [];
    if (res.isEmpty) {
      return const Expanded(
        child: Center(child: Text("No schedules available")),
      );
    }

    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    return Expanded(
      child: ListView.builder(
        itemCount: res.length,
        itemBuilder: (context, index) {
          final data = res[index];
          final scheduleDate = controller.parseSelectedDate();

          final departureParts = data.formattedDeparture.toString().split(':');
          final departureTime = TimeOfDay(
            hour: int.parse(departureParts[0]),
            minute: int.parse(departureParts[1]),
          );

          final isToday = _isSameDay(scheduleDate, currentDate);
          final isFutureDay = scheduleDate.isAfter(currentDate);

          bool isUnavailable;
          if (isFutureDay) {
            isUnavailable = false;
          } else if (isToday) {
            isUnavailable = _isTimePastOrCurrent(departureTime, currentTime);
          } else {
            isUnavailable = true;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.large,
              vertical: AppPadding.medium,
            ),
            child: ScheduleList(
              textColor: AppColors.primaryColor,
              startTime: data.formattedDeparture.toString(),
              middleTime: data.formattedduration.toString(),
              endTime: data.formattedarrival.toString(),
              seatAvailable: data.seatAvailable ?? 0,
              totalSeat: data.totalSeat ?? 0,
              price: data.price?.toDouble(),
              agencyPrice: data.agencyPrice?.toDouble(),
              buttonBackgroundColor:
                  isUnavailable ? Colors.grey : AppColors.primaryColor,
              buttonText: isUnavailable ? 'បានចាកចេញ' : 'កក់សំបុត្រ',
              isButtonEnabled: !isUnavailable,
              onTap: isUnavailable
                  ? null
                  : () => controller.navigateToSeat(
                      data.id.toString(),
                      data.journeyId.toString(),
                      data.price.toString(),
                      data.totalSeat.toString()),
              assetImage: const AssetImage(AppIcons.IC_arrow),
            ),
          );
        },
      ),
    );
  }

  bool _isTimePastOrCurrent(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) return true;
    if (time1.hour == time2.hour && time1.minute <= time2.minute) return true;
    return false;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
