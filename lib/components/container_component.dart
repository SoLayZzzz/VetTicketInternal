import 'package:flutter/material.dart';
import 'package:vet_internal_ticket/utils/colors.dart';

class ContainerComponent extends StatelessWidget {
  const ContainerComponent(
      {super.key,
      this.height = 20,
      this.width = double.infinity,
      this.color = AppColors.whiteColor,
      this.child = const Text(""),
      this.shadow,
      this.borderRadius = BorderRadius.zero,
      this.assetImage,
      this.networkImage,
      this.border});

  final double height;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  final BoxShadow? shadow;
  final Widget child;
  final NetworkImage? networkImage;
  final AssetImage? assetImage;
  final Border? border;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: child,
      decoration: BoxDecoration(
          image: _getImageDecoration(),
          color: color,
          border: border,
          borderRadius: borderRadius,
          boxShadow: shadow != null ? [shadow!] : []),
    );
  }

  DecorationImage? _getImageDecoration() {
    if (networkImage != null) {
      return DecorationImage(image: networkImage!);
    } else if (assetImage != null) {
      return DecorationImage(image: assetImage!);
    }
    return null;
  }
}
