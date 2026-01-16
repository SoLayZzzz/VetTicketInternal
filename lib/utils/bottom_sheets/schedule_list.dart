// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/utils/bottom_sheets/text.dart';
import 'package:vet_internal_ticket/utils/colors.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({
    super.key,
    this.startTime = "07:00",
    this.middleTime = "03:00",
    this.endTime = "02:00",
    this.onTap,
    this.seatAvailable = 20,
    this.totalSeat = 1,
    this.buttonBackgroundColor = Colors.deepOrange,
    this.assetImage = const AssetImage("images/assets/ic_arrow.png"),
    this.price,
    this.agencyPrice,
    this.buttonText = "កក់សំបុត្រ",
    this.isButtonEnabled = true,
    this.textColor,
  });

  final String startTime, middleTime, endTime;
  final VoidCallback? onTap;
  final int seatAvailable;
  final int totalSeat;
  final Color buttonBackgroundColor;
  final AssetImage? assetImage;
  final double? price;
  final double? agencyPrice;
  final String buttonText;
  final bool isButtonEnabled;
  final Color? textColor;

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  @override
  Widget build(BuildContext context) {
    final double displayOldPrice = (widget.price ?? 0).toDouble();
    final double displayNewPrice =
        (widget.agencyPrice ?? widget.price ?? 0).toDouble();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text18(text: widget.startTime, fontWeight: FontWeight.w500),
                Image(image: widget.assetImage!),
                Text18(text: widget.middleTime, fontWeight: FontWeight.w500),
                Image(image: widget.assetImage!),
                Text18(text: widget.endTime, fontWeight: FontWeight.w500),
              ],
            ),

            const SizedBox(height: 10),

            // Chair qty
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text14(text: "ចំនួនកៅអីនៅសល់"),
                      Text14(text: "Luxury Coaster (${widget.totalSeat})"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text14(text: "${widget.seatAvailable} កៅអី"),
                      Text14(
                        text: "${widget.totalSeat} កៅអី",
                        color: widget.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Price and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${widget.price} \$ ",
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const TextSpan(
                        text: "(Company) - ",
                        style: TextStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: "${widget.agencyPrice} \$ ",
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      const TextSpan(
                          text: "(Net)", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),

                // Updated Button with disabled state
                Opacity(
                  opacity: widget.isButtonEnabled ? 1.0 : 0.6,
                  child: Material(
                    color: widget.isButtonEnabled
                        ? widget.buttonBackgroundColor
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: widget.isButtonEnabled ? widget.onTap : null,
                      child: Container(
                        height: 35,
                        width: 120,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Center(
                          child: Text(
                            widget.buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                InkWell(
                  onTap: () => Get.toNamed(AppRoutes.schedule_detail_screen),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 6),
                      Text14(
                        text: 'ព័ត៌មានលម្អិត',
                        translate: false,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text14(
                          text: '\$${displayOldPrice.toStringAsFixed(2)}',
                          translate: false,
                          color: Colors.grey,
                          textDecoration: TextDecoration.lineThrough,
                        ),
                        const SizedBox(height: 4),
                        Text18(
                          text: '\$${displayNewPrice.toStringAsFixed(2)}',
                          translate: false,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
