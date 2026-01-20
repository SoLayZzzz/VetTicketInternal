import 'package:flutter/material.dart';
import 'package:vet_internal_ticket/utils/bottom_sheets/app_padding.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../utils/dimension.dart';

class CardItem extends StatelessWidget {
  final Function() onClick;
  final String title, img;

  const CardItem({
    super.key,
    required this.title,
    required this.img,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppPadding.extraLarge),
      ),
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimension.padding12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppPadding.medium),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.grey,
                  child: Image.asset(
                    img,
                    height: Dimension.iconSize40,
                  )),
              Text(
                title,
                style: const TextStyle(
                  fontSize: Dimension.fontSize16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
