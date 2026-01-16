import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/appbar.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';

class BusScreen extends StatelessWidget {
  const BusScreen({super.key});

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
                const Text("ប្រភេទឡាន"),
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
                  children: [
                    buildInfoCard(title: "Luxury Hotel Bus"),
                    buildInfoCard(title: "Luxury Hotel Bus"),
                    buildInfoCard(title: "Luxury Hotel Bus"),
                  ],
                ),
                const SizedBox(
                  height: Dimension.padding20,
                ),
                const Text("ប្រភេទទូក"),
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
                  children: [
                    buildInfoCard(title: "Luxury Hotel Bus"),
                    buildInfoCard(title: "Luxury Hotel Bus"),
                    buildInfoCard(title: "Luxury Hotel Bus"),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(Dimension.border10)),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
