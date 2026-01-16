import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.width = double.infinity,
    this.height = 60,
    this.color = Colors.black,
    this.child,
    this.border,
    this.borderRadius = BorderRadius.zero,
    this.assetImage,
    this.networkImage,
    this.shadow,
    this.onTap,
  });

  final double height;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  final Widget? child;
  final VoidCallback? onTap;
  final BoxShadow? shadow;
  final NetworkImage? networkImage;
  final AssetImage? assetImage;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: _getImageDecoration(),
          color: color,
          border: border,
          boxShadow: shadow != null ? [shadow!] : [],
          borderRadius: borderRadius,
        ),
        child: Center(child: child),
      ),
    );
  }

  _getImageDecoration() {
    if (networkImage != null) {
      return DecorationImage(image: networkImage!);
    } else if (assetImage != null) {
      return DecorationImage(image: assetImage!);
    }
    return null;
  }
}