import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/schedule_response.dart';

class ScheduleDetailController extends GetxController {
  late final PageController pageController;
  final RxInt currentPage = 0.obs;

  final List<String> fallbackImages = const [
    'assets/images/img_vet_express.png',
    'assets/images/img_vet_ticket.png',
    'assets/images/img_vet_exp.png',
  ];

  final Rxn<ScheduleListResponse> schedule = Rxn<ScheduleListResponse>();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    _loadArgs();
  }

  void _loadArgs() {
    final args = Get.arguments;
    if (args is Map) {
      final s = args['schedule'];
      if (s is ScheduleListResponse) {
        schedule.value = s;
      }
    }
  }

  List<Map<String, String>> get pickupPoints =>
      (schedule.value?.boardingPointList ?? [])
          .map((p) => {
                'name': _extractPointName(p.name),
                'time': _extractPointTime(p.name),
              })
          .toList();

  List<Map<String, String>> get dropoffPoints =>
      (schedule.value?.dropOffPointList ?? [])
          .map((p) => {
                'name': _extractPointName(p.name),
                'time': _extractPointTime(p.name),
              })
          .toList();

  List<String> get images {
    final s = schedule.value;
    final networkImages = (s?.slidePhoto ?? [])
        .map((e) => e.photo)
        .whereType<String>()
        .where((p) => p.trim().isNotEmpty)
        .toList();

    if (networkImages.isNotEmpty) return networkImages;

    final photo = s?.transportationPhoto?.trim();
    if (photo != null && photo.isNotEmpty) return [photo];

    return fallbackImages;
  }

  bool get canBook {
    final s = schedule.value;
    return s != null && (s.id ?? '').toString().isNotEmpty;
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

String _extractPointName(String? value) {
  if (value == null) return '';
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '';

  final parts = trimmed.split(' ');
  if (parts.isEmpty) return trimmed;

  final last = parts.last;
  if (_isTime(last)) {
    return parts.sublist(0, parts.length - 1).join(' ');
  }

  return trimmed;
}

String _extractPointTime(String? value) {
  if (value == null) return '';
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '';

  final parts = trimmed.split(' ');
  if (parts.isEmpty) return '';

  final last = parts.last;
  return _isTime(last) ? last : '';
}

bool _isTime(String value) {
  final v = value.trim();
  if (v.isEmpty) return false;
  final parts = v.split(':');
  if (parts.length < 2) return false;
  return int.tryParse(parts[0]) != null;
}
