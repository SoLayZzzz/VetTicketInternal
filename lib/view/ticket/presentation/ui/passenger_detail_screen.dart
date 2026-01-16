// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/app_image.dart';
import 'package:vet_internal_ticket/components/container_component.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/boarding_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/national_model.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/passenger_detail_controller.dart';
import '../../../../components/appbar.dart';
import '../../../../utils/bottom_sheets/button.dart';
import '../../../../utils/bottom_sheets/gender_select.dart';
import '../../../../utils/bottom_sheets/selectNationality.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';

class PassengerDetailScreen extends GetView<PassengerDetailController> {
  const PassengerDetailScreen({super.key});

  /// Keyboard toolbar configuration (iOS)
  KeyboardActionsConfig _keyboardConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      actions: [
        KeyboardActionsItem(
          focusNode: controller.phoneFocus,
          displayArrows: false,
          toolbarButtons: [
            (node) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: node.unfocus,
                    child: const Text('Done'),
                  ),
                ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build your scrollable content once
    final bodyContent = SingleChildScrollView(
      child: Obx(() => controller.uiState.value.dateBack == null ||
              controller.uiState.value.dateBack!.isEmpty
          ? _buildInfoGo()
          : Column(
              children: [
                _buildInfoGo(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppPadding.small),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    color: AppColors.borderColor,
                  ),
                ),
                _buildInfoBack(),
              ],
            )),
    );

    return Scaffold(
      appBar: appBarDefault(
        title: "ព័ត៌មានអ្នកដំណើរ",
        onPressed: () => controller.goBackToSeatSelection(),
      ),
      bottomNavigationBar: _buildBottomnavigation(),
      body: Platform.isIOS
          ? KeyboardActions(config: _keyboardConfig(), child: bodyContent)
          : bodyContent,
    );
  }

  Widget _buildInfoGo() {
    final uiState = controller.uiState.value;
    return _buildTripInfoSection(
      title: "ព័ត៌មានអតិថិជនទៅ",
      from: uiState.fromName ?? "",
      to: uiState.toName ?? "",
      date: uiState.date ?? "",
      boardingStation: uiState.goBoardingStation.value,
      downStation: uiState.goDropStation.value,
      seats: uiState.selectedSeats,
      isFirstSection: true,
      boardingList: uiState.goBoardingStationList,
      dropList: uiState.goDropStationList,
    );
  }

  Widget _buildInfoBack() {
    final uiState = controller.uiState.value;
    return _buildTripInfoSection(
      title: "ព័ត៌មានអតិថិជនត្រឡប់",
      from: uiState.toName ?? "",
      to: uiState.fromName ?? "",
      date: uiState.dateBack ?? "",
      boardingStation: uiState.returnBoardingStation.value,
      downStation: uiState.returnDropStation.value,
      seats: uiState.selectedSeatback,
      isFirstSection: true,
      boardingList: uiState.returnBoardingStationList,
      dropList: uiState.returnDropStationList,
    );
  }

  Widget _buildTripInfoSection({
    required String from,
    required String to,
    required String date,
    required BoardingResponse? boardingStation,
    required BoardingResponse? downStation,
    required List<Map<String, String>> seats,
    required bool isFirstSection,
    required String title,
    required List<BoardingResponse> boardingList,
    required List<BoardingResponse> dropList,
  }) {
    final uistate = controller.uiState.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactInfo(from, to, date),

        // Boarding Station
        Obx(() => _buildStationDropdown(
              title: "ចំណតឡើងជិះ",
              options: boardingList,
              selectedStation: boardingStation,
              onSelected: (value) {
                if (isFirstSection) {
                  uistate.goBoardingStation.value = value;
                } else {
                  uistate.returnBoardingStation.value = value;
                }
              },
            )),

        const SizedBox(
          height: AppPadding.medium,
        ),

        // Drop Station
        Obx(() => _buildStationDropdown(
              title: "ចំណតចុះ",
              options: dropList,
              selectedStation: downStation,
              onSelected: (value) {
                if (isFirstSection) {
                  uistate.goDropStation.value = value;
                } else {
                  uistate.returnDropStation.value = value;
                }
              },
            )),

        const SizedBox(
          height: AppPadding.medium,
        ),
        if (isFirstSection) ...[
          Obx(() =>
              _buildCustomerContactInfo(uistate.showPhoneError.value, title)),
          _buildNationalitySelector(),
        ],
        _buildDataListCustomer(seats),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildContactInfo(String from, String to, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppPadding.large, horizontal: AppPadding.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextSmall(
            text: "ព័ត៍មានធ្វើដំណើរ",
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.small),
            child: Row(
              children: [
                TextSmall(text: from),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.bigger),
                  child: Image.asset(
                    AppIcons.IC_arrow_forward,
                    height: Dimension.iconSize24,
                  ),
                ),
                TextSmall(text: to),
              ],
            ),
          ),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "ថ្ងៃចេញដំណើរ:\t"),
            TextSpan(text: date)
          ]))
        ],
      ),
    );
  }

  Widget _buildStationDropdown({
    required String title,
    required List<BoardingResponse> options,
    required BoardingResponse? selectedStation,
    required Function(BoardingResponse) onSelected,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppPadding.large, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSmall(text: title),
          const SizedBox(height: 5),
          Container(
            constraints: const BoxConstraints(minHeight: 64),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButtonFormField<BoardingResponse>(
                isExpanded: true,
                dropdownColor: AppColors.whiteColor,
                value: selectedStation,
                borderRadius: BorderRadius.circular(6),
                selectedItemBuilder: (context) {
                  return options.map((station) {
                    final text = "${station.name}";
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: TextSmalll(
                        text: text,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  }).toList();
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.arrow_drop_down,
                    size: 30, color: Colors.grey),
                items: options.map((station) {
                  final text = "${station.name}";
                  return DropdownMenuItem<BoardingResponse>(
                    value: station,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: TextSmalll(
                        text: text,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) onSelected(value);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCustomerContactInfo(bool showPhoneError, String title) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppPadding.large, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSmall(text: title),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppPadding.medium),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: 'លេខទូរស័ព្ទ ', style: TextStyle(fontSize: 15)),
                  TextSpan(
                      text: '*', style: TextStyle(color: AppColors.redColor)),
                ],
              ),
            ),
          ),
          Obx(() {
            final state = controller.uiState.value;
            final hasError =
                state.hasSubmitted.value && state.showPhoneError.value;

            return TextFormField(
              controller: state.phoneController,
              focusNode: controller.phoneFocus, // attach the focus
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => FocusScope.of(Get.context!).unfocus(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                isDense: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(11),
                  child: Image(
                    image: AssetImage(AppIcons.IC_phone),
                    width: 5,
                  ),
                ),
                hintText: 'លេខទូរស័ព្ទ',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: hasError ? Colors.red : AppColors.borderColor,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: hasError ? Colors.red : AppColors.primaryColor,
                    width: 1.0,
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: hasError ? Colors.red : AppColors.borderColor,
                    width: 1.0,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNationalitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.large,
        vertical: AppPadding.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'សញ្ជាតិ ', style: TextStyle(fontSize: 15)),
                TextSpan(
                    text: '*', style: TextStyle(color: AppColors.redColor)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final state = controller.uiState.value;
            final nationalList = state.national.value?.body?.data ?? [];
            final selectedId = state.selectedNationalityId.value;

            final bool hasError = state.hasSubmitted.value &&
                (state.showNationalityError.value || nationalList.isEmpty);

            final selected = nationalList.firstWhere(
              (item) => item.id == selectedId,
              orElse: () => Data(id: 0, name: null),
            );

            return SelectNationality(
              key: ValueKey("nationality_$selectedId"),
              height: Get.height / 16,
              nationalityList: nationalList.map((e) => e.name ?? '').toList(),
              text: selected.name,
              showChooseScreen: true,
              title: "ជ្រើសរើស",
              titleTextField: "ជ្រើសរើសសញ្ជាតិ",
              hintText: "ជ្រើសរើសសញ្ជាតិ",
              suffixIcon: AppIcons.IC_search,
              assetImage: const AssetImage(AppIcons.IC_flag),
              borderRadius: BorderRadius.circular(5),
              borderColor: AppColors.borderColor,
              hasError: hasError,
              errorText: hasError ? "* សូមជ្រើសរើសសញ្ជាតិ" : null,
              isEnabled: nationalList.isNotEmpty,
              isLoading: false,
              onSelected: (index) {
                final selectedItem = nationalList[index];
                state.selectedNationalityId.value = selectedItem.id ?? 0;
                state.showNationalityError.value = false;
              },
            );
          }),
        ],
      ),
    );
  }

  /// Reusable list of passengers (gender selection per seat).
  Widget _buildDataListCustomer(List<Map<String, String>> seats) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.large),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seats.length,
            itemBuilder: (context, index) {
              final seatNumber = seats[index];
              final seatLabel = seatNumber['label'] ?? seatNumber['value'];
              final seatId = seatNumber['value'] ?? index.toString();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'លេខកៅអី '),
                          TextSpan(
                              text: seatLabel,
                              style:
                                  const TextStyle(color: AppColors.redColor)),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'ភេទ '),
                            TextSpan(
                                text: '*',
                                style: TextStyle(color: AppColors.redColor)),
                          ],
                        ),
                      ),
                      Obx(() {
                        final hasEmpty =
                            controller.uiState.value.showGenderError.value &&
                                (controller.uiState.value
                                            .passengerGenders[seatId] ==
                                        null ||
                                    controller.uiState.value
                                            .passengerGenders[seatId] ==
                                        0);
                        return Row(
                          children: [
                            GenderSelectOption(
                              borderColor:
                                  hasEmpty ? Colors.red : Colors.black26,
                              assetImage: const AssetImage(AppIcons.IC_female),
                              value: controller.uiState.value.female.value,
                              groupValue: controller
                                      .uiState.value.passengerGenders[seatId] ??
                                  0,
                              label: "ស្រី",
                              onTap: () => controller.onTapGender(seatId,
                                  controller.uiState.value.female.value),
                            ),
                            const SizedBox(width: 20),
                            GenderSelectOption(
                              borderColor:
                                  hasEmpty ? Colors.red : Colors.black26,
                              assetImage: const AssetImage(AppIcons.IC_male),
                              value: controller.uiState.value.male.value,
                              groupValue: controller
                                      .uiState.value.passengerGenders[seatId] ??
                                  0,
                              label: "ប្រុស",
                              onTap: () => controller.onTapGender(
                                  seatId, controller.uiState.value.male.value),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  if (seats.length > 1 && index != seats.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: ContainerComponent(
                        height: 2,
                        width: double.infinity,
                        color: Colors.white,
                        assetImage: AssetImage(AppImages.IM_line),
                      ),
                    ),
                ],
              );
            }),
      );

  /// --- BOTTOM NAVIGATION --- ///
  ///
  Widget _buildBottomnavigation() {
    final con = controller.uiState.value;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppColors.drawerColor,
              offset: Offset(2, 2),
              spreadRadius: 2,
              blurRadius: 2),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const TextSmall(
                    text: "តម្លៃសរុប",
                    fontWeight: FontWeight.w500,
                  ),
                  const Spacer(),
                  TextSmall(
                    text: "${con.totalPrice.toString()} \$",
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Button(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.primaryColor,
                  onTap: () => controller.validateAndSubmit(),
                  child: Obx(() => TextExtraMedium(
                        text: controller.uiState.value.buttonText.value,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
