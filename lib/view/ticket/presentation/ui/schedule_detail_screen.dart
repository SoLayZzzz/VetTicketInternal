import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/utils/dimension.dart';

class ScheduleDetailScreen extends StatefulWidget {
  const ScheduleDetailScreen({super.key});

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  final List<String> _images = const [
    'assets/images/img_vet_express.png',
    'assets/images/img_vet_ticket.png',
    'assets/images/img_vet_exp.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pickupPoints = <Map<String, String>>[
      {'name': 'Phnom Penh (Chaom Chao)', 'time': '15:00:00'},
      {'name': 'Phnom Penh (Stueng Mean Chey)', 'time': '15:00:00'},
      {'name': 'Phnom Penh Boeng Chhouk', 'time': '15:00:00'},
      {'name': 'Phnom Penh (Olympic)', 'time': '15:30:00'},
      {'name': 'Phnom Penh (Cannon Rifle Roundabout Park)', 'time': '16:00:00'},
    ];

    final dropoffPoints = <Map<String, String>>[
      {'name': 'Siem Reap Chong Kaosou', 'time': '22:00:00'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
            size: Dimension.iconSize20,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'ព័ត៌មានលម្អិត',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: Dimension.fontSize18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _images.length,
                              onPageChanged: (index) {
                                setState(() => _currentPage = index);
                              },
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  _images[index],
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 10,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.25),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          _images.length,
                                          (index) => AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            height: 8,
                                            width:
                                                _currentPage == index ? 18 : 8,
                                            decoration: BoxDecoration(
                                              color: _currentPage == index
                                                  ? AppColors.primaryColor
                                                  : Colors.white
                                                      .withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ចំណតឡើង:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _PointList(points: pickupPoints),
                  const SizedBox(height: 16),
                  const Text(
                    'ចំណតចុះ:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _PointList(points: dropoffPoints),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    'កក់សំបុត្រ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointList extends StatelessWidget {
  const _PointList({required this.points});

  final List<Map<String, String>> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: points
            .asMap()
            .entries
            .map(
              (entry) => Column(
                children: [
                  ListTile(
                    title: Text(
                      entry.value['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.mainTextColor,
                      ),
                    ),
                    subtitle: Text(
                      entry.value['time'] ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {},
                  ),
                  if (entry.key != points.length - 1)
                    Divider(height: 1, color: Colors.grey.shade300),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
