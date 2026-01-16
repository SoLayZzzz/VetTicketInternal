// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/app_image.dart';
import 'package:vet_internal_ticket/components/appbar.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/utils/dimension.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_to_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/destination_model.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/ticket_controller.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/widget/container_button.dart';
import '../../../../utils/bottom_sheets/button.dart';
import '../../../../utils/bottom_sheets/select_date.dart';
import '../../../../utils/bottom_sheets/select_location.dart';
import '../../../../utils/colors.dart';

class TicketMenuScreen extends GetView<TicketMenuController> {
  const TicketMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault(
        title: "កក់សំបុត្រ",
        onPressed: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.medium, vertical: AppPadding.extraMedium),
        child: Column(
          children: [
            _buildSelectTab(),
            Obx(
              () => _buildSelectDestinationFrom(),
            ),
            _buildSelectDestinationTo(),
            _buildSelectDate(),

            // button search
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectTab() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ContainerButton(
              assetImage: const AssetImage(AppImages.IM_VET_EXPRESS),
              onclick: () {
                controller.setTransportType(1);
              },
              color: controller.uiState.value.selectedType == 1
                  ? AppColors.primaryColor
                  : AppColors.whiteColor,
            ),
            ContainerButton(
              assetImage: const AssetImage(AppImages.IM_buva_sea),
              onclick: () {
                controller.setTransportType(2);
              },
              color: controller.uiState.value.selectedType == 2
                  ? AppColors.primaryColor
                  : AppColors.whiteColor,
            ),
          ],
        ));
  }

  Widget _buildSelectDestinationFrom() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimension.padding20),
      child: FutureBuilder<DestinationFromModel>(
        future: controller.uiState.value.futureSelect,
        builder: (context, selectData) {
          List<String> locationList = [];
          bool hasData = false;

          if (selectData.connectionState == ConnectionState.done &&
              selectData.hasData) {
            final model = selectData.data!;
            if (model.header?.statusCode == 200 &&
                model.header?.result == true &&
                model.body != null &&
                model.body!.isNotEmpty) {
              locationList =
                  model.body!.map((e) => e.name ?? 'Unnamed').toList();
              hasData = true;
            }
          }

          return SelectLocation(
            key: ValueKey('from_${controller.uiState.value.fromWidgetKeyId}'),
            appBarBackgroundColorChooseScreen: AppColors.primaryColor,
            suffixIcon: AppIcons.IC_search,
            title: "ជ្រើសរើសទិសដៅពី",
            titleTextField: "ទិសដៅពី",
            text: controller.uiState.value.selectedFromName,
            locationList: locationList,
            assetImage: const AssetImage(AppIcons.IC_navigation),
            showChooseScreen: true,
            borderRadius: BorderRadius.circular(5),
            borderColor: AppColors.borderColor,
            textStyle: const TextStyle(color: AppColors.textColor),
            // Error if don't inut data
            hasError: controller.uiState.value.showFromError,
            errorText: controller.uiState.value.showFromError
                ? "* ជ្រើសរើសទិសដៅពី"
                : null,

            //
            hasData: hasData,
            onSelected: (index) async {
              if (hasData) {
                final selectedItem = selectData.data!.body![index];
                controller.setSelectedFrom(selectedItem.id, selectedItem.name);

                if (selectedItem.id != null) {
                  final body = DestinationToBody(
                    fromId: selectedItem.id!,
                    lang: "kh",
                    searchText: "",
                    type: controller.uiState.value.selectedType.toString(),
                  );
                  await controller.loadDestinationTo(body);
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectDestinationTo() {
    return Obx(() {
      return FutureBuilder<DestinationFromModel>(
        future: controller.uiState.value.futuretoSelect.value,
        builder: (context, selectData) {
          List<String> locationList = [];
          bool hasData = false;

          if (controller.uiState.value.selectedFromId != null &&
              selectData.connectionState == ConnectionState.done &&
              selectData.hasData) {
            final model = selectData.data!;
            if (model.header?.statusCode == 200 &&
                model.header?.result == true &&
                model.body != null &&
                model.body!.isNotEmpty) {
              locationList =
                  model.body!.map((e) => e.name ?? 'Unnamed').toList();
              hasData = true;
            }
          }

          return SelectLocation(
            key: ValueKey('to_${controller.uiState.value.toWidgetKeyId}'),
            appBarBackgroundColorChooseScreen: AppColors.primaryColor,
            suffixIcon: AppIcons.IC_search,
            title: "ជ្រើសរើសទិសដៅទៅ",
            titleTextField: "ទិសដៅទៅ",
            text: controller.uiState.value.selectedToName,
            locationList: locationList,
            assetImage: const AssetImage(AppIcons.IC_location),
            showChooseScreen: true,
            borderRadius: BorderRadius.circular(5),
            borderColor: AppColors.borderColor,
            textStyle: TextStyle(
              color: hasData ? AppColors.textColor : Colors.grey,
            ),
            // Error if don't inut data
            hasError: controller.uiState.value.showToError,
            errorText: controller.uiState.value.showToError
                ? "* ជ្រើសរើសទិសដៅទៅ"
                : null,
            hasData: hasData,
            isEnabled: hasData,
            onSelected: (index) {
              if (selectData.hasData) {
                final selectedItem = selectData.data!.body![index];
                controller.setSelectedTo(selectedItem.id, selectedItem.name);
              }
            },
          );
        },
      );
    });
  }

  Widget _buildSelectDate() => Padding(
        padding: EdgeInsets.symmetric(vertical: Dimension.padding20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Go Date Picker
            DatePicker(
              width: Get.width / 2.2,
              assetImage: AssetImage(AppIcons.IC_calender),
              clearable: false,
              showCurrentDateAuto: true,
              allowPastDates: false,
              backgroundColor: AppColors.whiteColor,
              selectedDateColor: AppColors.primaryColor,
              fontSize: 13,
              onSeclectDate: (formattedDate) {
                controller.updateSelectedDate(formattedDate);
              },
            ),

            // Return Date Picker
            Obx(() {
              DateTime? goDate;
              try {
                final parts = controller.uiState.value.selectDate.split('-');
                if (parts.length == 3) {
                  goDate = DateTime.parse(controller.uiState.value.selectDate);
                }
              } catch (_) {}

              return DatePicker(
                width: Get.width / 2.2,
                assetImage: AssetImage(AppIcons.IC_calender),
                fontSize: 13,
                showCurrentDateAuto: false,
                allowPastDates: false,
                text: "ថ្ងៃមកវិញ",
                minDate: goDate,
                backgroundColor: AppColors.whiteColor,
                selectedDateColor: AppColors.primaryColor,
                onSeclectDate: (formattedDate) {
                  controller.updateSelectedReturnDate(formattedDate);
                },
              );
            })
          ],
        ),
      );

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Button(
          height: 55,
          borderRadius: BorderRadius.circular(5),
          color: AppColors.primaryColor,
          onTap: () {
            controller.navigateToScheduleList();
          },
          child: Text(
            "ស្វែងរក",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
    );
  }
}
