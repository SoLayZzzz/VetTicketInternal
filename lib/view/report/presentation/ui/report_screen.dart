import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/components/container_component.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import '../../../../components/appbar.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarDefault(
          title: "របាយការណ៍",
          onPressed: () {
            Get.back();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppPadding.bigger, horizontal: AppPadding.large),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.report_sale_screen);
                },
                child: ContainerComponent(
                  height: Get.height / 13,
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(Dimension.border6),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.large),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("របាយការណ៍លក់ (ភ្នាក់ងារ)", style: styleNormal14),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: Dimension.iconSize24,
                          color: AppColors.drawerColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //
              const SizedBox(
                height: AppPadding.bigger,
              ),

              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.report_balance_screen);
                },
                child: ContainerComponent(
                  height: Get.height / 13,
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(Dimension.border6),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.large),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("របាយការណ៍សមតុល្យ (ភ្នាក់ងារ)",
                            style: styleNormal14),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: Dimension.iconSize24,
                          color: AppColors.drawerColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
