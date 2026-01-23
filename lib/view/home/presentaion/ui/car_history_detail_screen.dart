import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/components/appbar.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/utils/bottom_sheets/app_padding.dart';
import 'package:vet_internal_ticket/theme/app_colors.dart';
import 'package:vet_internal_ticket/view/home/presentaion/controller/car_history_detail_controller.dart';

class CarHistoryDetailScreen extends StatelessWidget {
  const CarHistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CarHistoryDetailController>();

    return Scaffold(
      appBar: appBarDefault(
        title: 'ព័ត៌មានលម្អិត',
        onPressed: () => Get.back(),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        final st = controller.uiState.value;
        if (st.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (st.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              st.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final item = st.item;
        final from = item?.destinationFrom ?? 'Battambang';
        final to = item?.destinationTo ?? 'Phnom Penh';
        final route = '$from - $to';

        final code = item?.code ?? 'VETAB-T2601000586';

        final departure = (item?.departure ?? '').split('.').first;
        final date = item?.travelDate ?? item?.bookingDate ?? '2026-01-04';
        final dateTime =
            departure.isNotEmpty ? '$date ($departure)' : '$date (07:30:00)';

        final vehicle = item?.transportationType ?? 'Air Bus 35 Seats';
        final phone = item?.telephone ?? '086986093';
        final payment = item?.paymentType ?? 'Cash';

        final seat = (item?.bookingSeatDetailList?.isNotEmpty == true)
            ? item!.bookingSeatDetailList!.first
            : null;

        final nationality =
            (seat?.nationalityName?.toString().isNotEmpty ?? false)
                ? seat!.nationalityName!.toString()
                : 'Khmer';

        final seatNo = (seat?.seatNumber?.toString().isNotEmpty ?? false)
            ? seat!.seatNumber!.toString()
            : '-';

        final genderText = () {
          final raw = seat?.gender?.toString().trim();
          if (raw == null || raw.isEmpty) {
            return '-';
          }
          if (raw == '1' || raw.toLowerCase() == 'male') {
            return 'Male';
          }
          if (raw == '2' || raw.toLowerCase() == 'female') {
            return 'Female';
          }
          return '-';
        }();

        final seatGenderLabel = '$seatNo-$genderText';

        return ListView(
          children: [
            _buildImage(code, route, dateTime, seatGenderLabel),
            const SizedBox(height: 14),
            _buildCartDisplay(
              vehicle: vehicle,
              phone: phone,
              payment: payment,
              gender: genderText,
              nationality: nationality,
              seatNo: seatNo,
              travelDate: date,
              boardingName: item?.boardingPoint ?? '',
              boardingTime: departure.isNotEmpty ? '($departure)' : '',
              boardingAddress: item?.boardingPointAddress ?? '',
              boardingLat: item?.boardingPointLat ?? '',
              boardingLng: item?.boardingPointLong ?? '',
              dropOffName: item?.dropOffPoint ?? '',
              dropOffTime: (item?.arrival ?? '').isNotEmpty
                  ? '(${(item?.arrival ?? '').split('.').first})'
                  : '',
              dropOffAddress: item?.dropOffPointAddress ?? '',
              dropOffLat: item?.dropOffPointLat ?? '',
              dropOffLng: item?.dropOffPointLong ?? '',
              subTotal: item?.subTotal ?? '\$ 12.00',
              totalAmount: item?.totalAmount ?? '\$ 12.00',
              discount: item?.discount ?? '\$ 0.00',
            ),
            const SizedBox(height: 14),
          ],
        );
      }),
    );
  }

  Widget _buildImage(
      String code, String route, String dateTime, String seatGenderLabel) {
    return ClipRRect(
      child: AspectRatio(
        aspectRatio: 11 / 10,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/img_buva_sea.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final qrSize = (constraints.maxHeight * 0.45).clamp(80.0, 110.0);

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // QR Code Section
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QrImageView(
                          data: code,
                          size: qrSize,
                          backgroundColor: Colors.white,
                        ),
                        TextSmall(
                          text: seatGenderLabel,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Text Overlay Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(220),
                    ),
                    child: Column(
                      children: [
                        Text(
                          route,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          code,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          dateTime,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCartDisplay({
    required String vehicle,
    required String phone,
    required String payment,
    required String gender,
    required String nationality,
    required String seatNo,
    required String travelDate,
    required String boardingName,
    required String boardingTime,
    required String boardingAddress,
    required String boardingLat,
    required String boardingLng,
    required String dropOffName,
    required String dropOffTime,
    required String dropOffAddress,
    required String dropOffLat,
    required String dropOffLng,
    required String subTotal,
    required String totalAmount,
    required String discount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.large),
      child: Column(
        children: [
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
                _InfoRow(label: 'ថ្ងៃធ្វើដំណើរ', value: travelDate),
                _InfoRow(label: 'លេខទូរស័ព្ទ', value: phone),
                _InfoRow(label: 'ទូទាត់', value: payment),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: _StationCard(
              title: 'ចំណតឡើង:',
              name: boardingName.isNotEmpty
                  ? boardingName
                  : 'Battambang Lok ta Dombong kronhoung',
              time: boardingTime.isNotEmpty ? boardingTime : '(07:30:00)',
              address: boardingAddress.isNotEmpty
                  ? boardingAddress
                  : 'National Road 5 , Romchek 4 village, Sangkat Rattanak, Battambang City , Battambang',
              latitude: double.tryParse(boardingLat) ?? 11.568280,
              longitude: double.tryParse(boardingLng) ?? 104.890670,
            ),
          ),
          _StationCard(
            title: 'ចំណតចុះ:',
            name: dropOffName.isNotEmpty
                ? dropOffName
                : 'Phnom Penh (Cannon Rifle Roundabout Park)',
            time: dropOffTime.isNotEmpty ? dropOffTime : '(11:30:00)',
            address: dropOffAddress.isNotEmpty
                ? dropOffAddress
                : 'Oknha Dekcho Ei (St. 76), Phnom Penh, Cambodia',
            latitude: double.tryParse(dropOffLat) ?? 11.5703975,
            longitude: double.tryParse(dropOffLng) ?? 104.8980857,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(
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
                  _InfoRow(label: 'ភេទ', value: gender),
                  _InfoRow(label: 'សញ្ជាតិ', value: nationality),
                  _InfoRow(label: 'លេខកៅអី', value: seatNo),
                ],
              ),
            ),
          ),
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
                _PriceRow(label: 'សរុប', value: subTotal),
                const SizedBox(height: 8),
                _PriceRow(label: 'បង់រួច', value: totalAmount),
                const SizedBox(height: 8),
                _PriceRow(label: 'បញ្ចុះតម្លៃ', value: discount),
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
    required this.latitude,
    required this.longitude,
  });

  final String title;
  final String name;
  final String time;
  final String address;
  final double latitude;
  final double longitude;

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
                onTap: () => Get.toNamed(
                  AppRoutes.car_history_map_screen,
                  arguments: {
                    'lat': latitude,
                    'lng': longitude,
                    'label': name,
                    'address': address,
                  },
                ),
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
