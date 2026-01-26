import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/utils/bottom_sheets/select_date.dart';

import '../../../../components/appbar.dart';
import '../../../../components/button.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/dimension.dart';

class ReportBalanceScreen extends StatefulWidget {
  const ReportBalanceScreen({super.key});

  @override
  State<ReportBalanceScreen> createState() => _ReportBalanceScreenState();
}

class _ReportBalanceScreenState extends State<ReportBalanceScreen> {
  String? agency;
  final agencyItems = ['ប្រុស', 'ស្រី'];

  String bookingDateFrom = '';
  String bookingDateTo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault(
        title: "របាយការណ៍សមតុល្យ (ភ្នាក់ងារ)",
        onPressed: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: DatePicker(
                          width: double.infinity,
                          height: Get.height / 13,
                          fontSize: 14,
                          assetImage: const AssetImage(AppIcons.IC_calender),
                          clearable: false,
                          allowPastDates: true,
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          selectedDateColor: AppColors.primaryColor,
                          onSeclectDate: (v) {
                            setState(() {
                              bookingDateFrom = v;
                              if (bookingDateTo.isNotEmpty) {
                                final fromDt =
                                    DateTime.tryParse(bookingDateFrom);
                                final toDt = DateTime.tryParse(bookingDateTo);
                                if (fromDt != null &&
                                    toDt != null &&
                                    toDt.isBefore(fromDt)) {
                                  bookingDateTo = bookingDateFrom;
                                }
                              }
                            });
                          },
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
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: DatePicker(
                          width: double.infinity,
                          height: Get.height / 13,
                          fontSize: 14,
                          assetImage: AssetImage(AppIcons.IC_calender),
                          clearable: false,
                          allowPastDates: true,
                          showCurrentDateAuto: false,
                          text: 'ថ្ងៃត្រលប់មកវិញ',
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          selectedDateColor: AppColors.primaryColor,
                          onSeclectDate: (v) {
                            setState(() {
                              bookingDateTo = v;
                            });
                          },
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
                  InputDecorator(
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
                        items: agencyItems
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: agency,
                        onChanged: (String? value) {
                          setState(() {
                            agency = value;
                          });
                        },
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
