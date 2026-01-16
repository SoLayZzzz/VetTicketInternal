import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/view/auth/presentation/controller/auth_controller.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/dialog/alert_dialog.dart';
import '../../../../../utils/dimension.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        backgroundColor: AppColors.mainTextColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 60,
                  left: Dimension.padding12,
                  right: Dimension.padding12),
              height: 220,
              color: AppColors.drawerHeaderColor,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('assets/images/img_profile.png'),
                    height: 60,
                  ),
                  SizedBox(height: Dimension.padding16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Testest",
                            style: TextStyle(
                              fontSize: Dimension.fontSize16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          Text(
                            "012 345 6789",
                            style: TextStyle(
                              fontSize: Dimension.fontSize14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Scrollable Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  navigatorItem(() {
                    Get.back();
                    Get.toNamed(AppRoutes.printerScreen);
                    // Get.to(() => const PrinterScreen());
                  }, 'assets/icons/ic_print.png', 'ការកំណត់ម៉ាស៊ីនព្រីន'),
                  navigatorItem(() {
                    showDialogTwoButton(
                      title: "Logout Info",
                      description: "Do you want to logout the app?",
                      buttonText1: "NO",
                      color1: AppColors.redColor,
                      buttonText2: "YES",
                      onButtonPressed1: () {
                        Get.back();
                        Future.delayed(const Duration(milliseconds: 200), () {
                          Get.back();
                        });
                      },
                      onButtonPressed2: () async {
                        await controller.logOut();
                      },
                    );
                  }, 'assets/icons/ic_logout.png', 'ចាកចេញ'),
                ],
              ),
            ),

            // Footer with Version Number
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'ជំនាន់ 1.1.0',
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// * List for Drawer
InkWell navigatorItem(Function() onClick, String assets, String title) {
  return InkWell(
    onTap: onClick,
    child: Container(
      color: AppColors.drawerColor,
      child: Padding(
        padding: const EdgeInsets.all(Dimension.padding14),
        child: Row(
          children: [
            Image.asset(
              assets,
              width: 36,
              height: 36,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}
