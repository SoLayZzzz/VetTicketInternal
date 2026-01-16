import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart'; // For translations
import '../../../utils/Textstyle.dart';
import '../../../utils/style_color.dart';
import '../controller/printer_settingVewModel.dart';

class PrinterSetting extends StatelessWidget {
  const PrinterSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrinterSettingController>();

    return Scaffold(
      appBar: AppBar(

        backgroundColor: StyleColor.secondColor,
        title: Text(
          tr('printer_settings'), // Translation key
          style: StyleText.label12,
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(

        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: ListView.builder(
            itemCount: controller.printerOptions.length,
            itemBuilder: (context, index) {

              final printer = controller.printerOptions[index];

              return Obx(() {

                final isSelected = controller.selectedIndex.value == index;

                return GestureDetector(
                  onTap: () => controller.selectOption(index),
                  child: AnimatedContainer(
                    key: ValueKey(index), // Added key for better state management
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: isSelected ? StyleColor.primaryColor : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? StyleColor.primaryColor
                            : Colors.grey.shade300,
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(
                        color: StyleColor.primaryColor.withOpacity(0.4),
                        blurRadius: 6.0,
                        offset: const Offset(0, 3),
                      )]
                          : [BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6.0,
                        offset: const Offset(0, 3),
                      )],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(printer["icon"], fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                printer["title"],
                                style: isSelected
                                    ? StyleText.category
                                    : StyleText.label9,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                tr(printer["subtitle"]??""), // Translation key
                                style: isSelected
                                    ? StyleText.label5.copyWith(
                                  fontSize: 12,
                                  color: StyleColor.secondColor,
                                )
                                    : StyleText.label7,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: isSelected ? Colors.black : Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
