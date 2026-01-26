import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/theme/app_colors.dart';
import 'package:vet_internal_ticket/utils/dimension.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/schedule_response.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/schedule_controller.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/controller/schedule_detail_controller.dart';

class ScheduleDetailScreen extends GetView<ScheduleDetailController> {
  const ScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleListResponse? schedule = controller.schedule.value;
    final pickupPoints = controller.pickupPoints;
    final dropoffPoints = controller.dropoffPoints;
    final images = controller.images;
    final canBook = controller.canBook;

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
        title: Obx(() {
          try {
            final scheduleController = Get.find<ScheduleController>();
            final isReturn =
                scheduleController.uiState.value.isReturnTrip.value;
            final from = isReturn
                ? scheduleController.uiState.value.toName
                : scheduleController.uiState.value.fromName;
            final to = isReturn
                ? scheduleController.uiState.value.fromName
                : scheduleController.uiState.value.toName;
            final titleText =
                (from != null && to != null) ? '$from - $to' : 'ព័ត៌មានលម្អិត';

            return Text(
              titleText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: Dimension.fontSize18,
                fontWeight: FontWeight.w600,
              ),
            );
          } catch (_) {
            return const Text(
              'ព័ត៌មានលម្អិត',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: Dimension.fontSize18,
                fontWeight: FontWeight.w600,
              ),
            );
          }
        }),
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
                              controller: controller.pageController,
                              itemCount: images.length,
                              onPageChanged: controller.onPageChanged,
                              itemBuilder: (context, index) {
                                final image = images[index];
                                if (image.startsWith('http')) {
                                  return Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const _ImageSkeleton();
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        controller.fallbackImages.first,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  );
                                }
                                return Image.asset(
                                  image,
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
                                          images.length,
                                          (index) => Obx(
                                            () => AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              height: 8,
                                              width: controller
                                                          .currentPage.value ==
                                                      index
                                                  ? 18
                                                  : 8,
                                              decoration: BoxDecoration(
                                                color: controller.currentPage
                                                            .value ==
                                                        index
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
                  if ((schedule?.amenities ?? []).isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'គ្រឿងបរិក្ខា:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainTextColor,
                      ),
                    ),
                    _AmenitiesList(amenities: schedule!.amenities ?? []),
                  ],
                  if ((schedule?.note ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'ចំណាំ:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        schedule!.note!.trim(),
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: AppColors.mainTextColor,
                        ),
                      ),
                    ),
                  ],
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
                  onPressed: !canBook
                      ? null
                      : () {
                          final controller = Get.find<ScheduleController>();
                          Get.back();
                          Future.microtask(() {
                            controller.navigateToSeat(
                              schedule!.id.toString(),
                              (schedule.journeyId ?? '').toString(),
                              (schedule.price ?? 0).toString(),
                              (schedule.totalSeat ?? 0).toString(),
                            );
                          });
                        },
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

class _AmenitiesList extends StatelessWidget {
  const _AmenitiesList({required this.amenities});

  final List<Amenity> amenities;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: amenities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final a = amenities[index];
        final icon = (a.icon ?? '').trim();
        final name = (a.name ?? '').trim();

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon.startsWith('http'))
              Image.network(
                icon,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.check_circle_outline,
                    size: 28,
                    color: AppColors.primaryColor,
                  );
                },
              )
            else
              const Icon(
                Icons.photo_outlined,
                size: 28,
                color: AppColors.primaryColor,
              ),
            const SizedBox(height: 10),
            Text(
              name.isEmpty ? '-' : name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mainTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ImageSkeleton extends StatefulWidget {
  const _ImageSkeleton();

  @override
  State<_ImageSkeleton> createState() => _ImageSkeletonState();
}

class _ImageSkeletonState extends State<_ImageSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final begin = Alignment(-1.0 - 2 * t, 0);
        final end = Alignment(1.0 + 2 * t, 0);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
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
                      style: const TextStyle(color: Colors.black),
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
