import 'package:flutter/material.dart';
import 'package:vet_internal_ticket/utils/dimension.dart';

class ContainerButton extends StatelessWidget {
  const ContainerButton(
      {super.key,
      required this.assetImage,
      required this.onclick,
      this.color = Colors.transparent});

  final VoidCallback onclick;
  final AssetImage assetImage;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onclick,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: color,
                width: 2.0,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimension.padding10),
            child: Image(
              image: assetImage,
              height: Dimension.iconSize30,
            ),
          ),
        ),
      ),
    );
  }
}
