import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/appbar.dart';
import '../../../../models/vehicle_image_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/dimension.dart';

import 'bus_detail_screen.dart';

class BusScreen extends StatelessWidget {
  const BusScreen({super.key});

  static const Map<String, String> _titleById = <String, String>{
    'luxury_hotel_bus': 'Luxury Hotel Bus',
    'air_bus': 'Air Bus',
    'hotel_bus': 'Hotel Bus',
    'speedboat': 'SpeedBoat',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault(
        title: "ប្រភេទឡាននិងទូក",
        onPressed: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimension.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ប្រភេទឡាន",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 3),
                  ),
                  children: VehicleImageData.covers
                      .where((e) => e.id != 'speedboat')
                      .map(
                        (e) => buildInfoCard(
                          id: e.id,
                          title: _titleById[e.id] ?? e.id,
                          image: e.image,
                        ),
                      )
                      .toList(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("ប្រភេទទូក",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                GridView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 3),
                  ),
                  children: VehicleImageData.covers
                      .where((e) => e.id == 'speedboat')
                      .map(
                        (e) => buildInfoCard(
                          id: e.id,
                          title: _titleById[e.id] ?? e.id,
                          image: e.image,
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required String id,
    required String title,
    required String image,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimension.border10),
        onTap: () {
          Get.to(
            () => BusDetailScreen(
              id: id,
              title: title,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimension.border10),
              child: Container(
                width: double.infinity,
                height: 100,
                color: AppColors.borderColor,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
