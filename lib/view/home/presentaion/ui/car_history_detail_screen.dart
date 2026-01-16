import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/components/appbar.dart';
import 'package:vet_internal_ticket/utils/colors.dart';

class CarHistoryDetailScreen extends StatelessWidget {
  const CarHistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        (Get.arguments is Map) ? (Get.arguments as Map) : <dynamic, dynamic>{};

    final String route = (args['route']?.toString().isNotEmpty ?? false)
        ? args['route'].toString()
        : 'Battambang - Phnom Penh';

    final String code = (args['code']?.toString().isNotEmpty ?? false)
        ? args['code'].toString()
        : 'VETAB-T2601000586';

    final String dateTime = (args['date']?.toString().isNotEmpty ?? false)
        ? args['date'].toString()
        : '2026-01-04 (07:30:00)';

    final String vehicle = (args['vehicle']?.toString().isNotEmpty ?? false)
        ? args['vehicle'].toString()
        : 'Air Bus 35 Seats';

    final String passengerName =
        (args['passengerName']?.toString().isNotEmpty ?? false)
            ? args['passengerName'].toString()
            : 'Sopheap';

    final String gender = (args['gender']?.toString().isNotEmpty ?? false)
        ? args['gender'].toString()
        : 'Male';

    final String nationality =
        (args['nationality']?.toString().isNotEmpty ?? false)
            ? args['nationality'].toString()
            : 'Khmer';

    final String seatNo = (args['seatNo']?.toString().isNotEmpty ?? false)
        ? args['seatNo'].toString()
        : '2A';

    const String phone = '086986093';
    const String payment = 'Cash';

    return Scaffold(
      appBar: appBarDefault(
        title: 'ព័ត៌មានលម្អិត',
        onPressed: () => Get.back(),
      ),
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/img_buva_sea.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.45),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final qrSize =
                          (constraints.maxHeight * 0.50).clamp(90.0, 120.0);
                      return Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: QrImageView(
                                    data: code,
                                    size: qrSize,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  route,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  code,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateTime,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                const _InfoRow(label: 'ថ្ងៃធ្វើដំណើរ', value: '2026-01-03'),
                const _InfoRow(label: 'លេខទូរស័ព្ទ', value: phone),
                const _InfoRow(label: 'ទូទាត់', value: payment),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _StationCard(
            title: 'ចំណតឡើង:',
            name: 'Battambang Lok ta Dombong kronhoung',
            time: '(07:30:00)',
            address:
                'National Road 5 , Romchek 4 village, Sangkat Rattanak, Battambang City , Battambang',
          ),
          const SizedBox(height: 14),
          const _StationCard(
            title: 'ចំណតចុះ:',
            name: 'Phnom Penh (Cannon Rifle Roundabout Park)',
            time: '(11:30:00)',
            address: 'Oknha Dekcho Ei (St. 76), Phnom Penh, Cambodia',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _InfoRow(label: 'ឈ្មោះ', value: passengerName),
                _InfoRow(label: 'ភេទ', value: gender),
                _InfoRow(label: 'សញ្ជាតិ', value: nationality),
                _InfoRow(label: 'លេខកៅអី', value: seatNo),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              children: [
                _PriceRow(label: 'សរុប', value: '\$ 12.00'),
                SizedBox(height: 8),
                _PriceRow(label: 'បង់រួច', value: '\$ 12.00'),
                SizedBox(height: 8),
                _PriceRow(label: 'បញ្ចុះតម្លៃ', value: '\$ 0.00'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.mainTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  const _StationCard({
    required this.title,
    required this.name,
    required this.time,
    required this.address,
  });

  final String title;
  final String name;
  final String time;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainTextColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.car_history_map_screen),
                child: const Text(
                  'មើលផែនទី',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$name  $time',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.mainTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.mainTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
