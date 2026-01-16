import 'package:flutter/material.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final EdgeInsets? padding;
  const CustomTitle({super.key, required this.title, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppPadding.extraLarge),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
