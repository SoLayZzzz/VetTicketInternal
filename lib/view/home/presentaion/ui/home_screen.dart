import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/view/home/presentaion/controller/home_controller.dart';
import '../../../../components/appbar.dart';
import '../../../../utils/dimension.dart';
import 'widget/card_item.dart';
import 'widget/drawer_menu.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerMenu(),
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.extraLarge, vertical: AppPadding.bigger),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildTitle(context), _buildGird(context)],
        ),
      ),
    );
  }

  _buildAppBar() {
    return appBarHome(
      title: "VET Ticket Internal",
      center: false,
      leadingIcon: IconButton(
        icon: Image.asset(
          AppIcons.IC_menu_drawer,
          color: Colors.white,
          height: Dimension.iconSize24,
        ),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
  }

  _buildTitle(BuildContext context) {
    return const TextDefault(
      text: "ប្រព័ន្ធកម្មវិធីកក់សំបុត្របែប\nឌីជីថល",
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
    );
  }

  _buildGird(BuildContext context) => GridView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.2),
        ),
        children: [
          CardItem(
              title: "កក់សំបុត្រ",
              img: AppIcons.IC_Ticket,
              onClick: () {
                Get.toNamed(AppRoutes.ticket_menu_Screen);
              }),
          CardItem(
              title: "របាយការណ៍",
              img: AppIcons.IC_statistics,
              onClick: () {
                Get.toNamed(AppRoutes.reportScreen);
              }),
          CardItem(
              title: "ស្គែនសំបុត្រឡើងឡាន",
              img: AppIcons.IC_ticket_scanner,
              onClick: () {
                Get.toNamed(AppRoutes.scan_ticket_screen);
              }),
          CardItem(
              title: "រូបឡាននិងទូក",
              img: AppIcons.IC_bus,
              onClick: () {
                Get.toNamed(AppRoutes.busScreen);
              }),
          CardItem(
              title: "ប្រវត្តិសំបុត្រធ្វើដំណើរ",
              img: AppIcons.IC_bus,
              onClick: () {
                Get.toNamed(AppRoutes.car_history_screen);
              }),
        ],
      );
}
