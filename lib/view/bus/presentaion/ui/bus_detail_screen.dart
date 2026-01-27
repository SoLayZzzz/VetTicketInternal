import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/appbar.dart';
import '../../../../models/vehicle_image_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/dimension.dart';

class BusDetailScreen extends StatelessWidget {
  final String id;
  final String title;

  const BusDetailScreen({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final images = VehicleImageData.getInsideImages(id);

    return Scaffold(
      appBar: appBarDefault(
        title: "ប្រភេទឡាននិងទូក",
        onPressed: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: images.isEmpty
                    ? const Center(
                        child: Text('No images'),
                      )
                    : ListView.separated(
                        itemCount: images.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final imagePath = images[index];

                          return ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimension.border10),
                            child: Container(
                              height: 220,
                              color: AppColors.borderColor,
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
