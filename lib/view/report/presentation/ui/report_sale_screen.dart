import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/view/report/presentation/controller/report_sale_controller.dart';

import '../../../../components/appbar.dart';
import '../../../../components/button.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';

class ReportSaleScreen extends GetView<ReportSaleController> {
  const ReportSaleScreen({super.key});

//   @override
//   State<ReportSaleScreen> createState() => _ReportSaleScreenState();
// }

// class _ReportSaleScreenState extends State<ReportSaleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault(
        title: "របាយការណ៍លក់ (ភ្នាក់ងារ)",
        onPressed: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ថ្ងៃកក់"),

              ///select date
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: Dimension.padding10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius:
                              BorderRadius.circular(Dimension.border6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimension.padding20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "2024-09-09",
                                style: styleNormal14,
                              ),
                              Image.asset(
                                AppIcons.IC_calender,
                                width: Dimension.iconSize24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimension.padding12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius:
                              BorderRadius.circular(Dimension.border6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimension.padding20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ថ្ងៃត្រលប់មកវិញ",
                                style: styleNormal14,
                              ),
                              Image.asset(
                                AppIcons.IC_calender,
                                width: Dimension.iconSize24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Text("ថ្ងៃធ្វើដំណើរ"),

              ///select date
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: Dimension.padding10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius:
                              BorderRadius.circular(Dimension.border6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimension.padding20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "2024-09-09",
                                style: styleNormal14,
                              ),
                              Image.asset(
                                AppIcons.IC_calender,
                                width: Dimension.iconSize24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimension.padding12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius:
                              BorderRadius.circular(Dimension.border6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimension.padding20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ថ្ងៃត្រលប់មកវិញ",
                                style: styleNormal14,
                              ),
                              Image.asset(
                                AppIcons.IC_calender,
                                width: Dimension.iconSize24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ភ្នាក់ងារ"),
                  const SizedBox(
                    height: Dimension.padding10,
                  ),
                  Obx(
                    () => InputDecorator(
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(1, 5, 10, 5),
                        border: OutlineInputBorder(),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'ជ្រើសរើស', // Default hint
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: controller.uiState.value.agencyItems
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: controller.uiState.value.agency,
                          onChanged: (String? value) {
                            controller.uiState.update((val) {
                              val?.agency = value;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: Dimension.padding40),

              ///button search
              buttonElevated("ស្វែងរក", () {})
            ],
          ),
        ),
      ),
    );
  }
}
