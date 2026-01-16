import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_image.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/view/booking/presentation/controller/booking_controller.dart';

class BookingDetailScreen extends GetView<BookingController> {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        final state = controller.state;

        //  loading for data fetched
        if (state.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check if transaction data is available
        if (state.bookingTransactonModel.value == null) {
          return Center(
            child: TextMedium(text: 'No booking information available'),
          );
        }

        return _buildBody();
      }),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: TextMedium(
        text: "វិក្ក័យបត្រ",
        color: Colors.white,
      ),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.large),
      child: Column(
        children: [_buildTitleOfRecip(), _buildData(), _buildButton()],
      ),
    );
  }

  _buildTitleOfRecip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: Get.height / 16,
          width: Get.width / 6,
          decoration: BoxDecoration(
              // color: Colors.red,
              image: DecorationImage(
                  image: AssetImage(AppImages.IM_VET_LOGO_RECIP),
                  fit: BoxFit.cover)),
        ),
        SizedBox(
          width: 30,
        ),
        Column(
          children: const [
            TextExtraMedium(
              text: "អេចេនសុី អេចប្រេស",
              fontWeight: FontWeight.bold,
            ),
            TextExtraMedium(
              text: "Agency Express CO.Ltd",
              fontWeight: FontWeight.w400,
            )
          ],
        )
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      children: [
        Expanded(
            child: TextExtraSmall(
          text: label,
          fontWeight: FontWeight.w500,
        )),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextExtraSmall(
                text: value,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  _buildData() {
    final transaction = controller.state.bookingTransactonModel.value;
    final ticket = transaction?.body?.ticket?.first;
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppPadding.large, horizontal: AppPadding.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextExtraMedium(
            text: "TICKET",
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          _buildRow('លេខទូរស័ព្ទ / Phone No. :', ticket?.telephone ?? ""),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.medium),
            child: _buildRow('លេខវិក័យបត្រ / Invoice No. :',
                transaction!.body!.transactionId.toString()),
          ),
          _buildRow('ទឹសដៅ / Direction :',
              '${ticket?.destinationFrom} to ${ticket?.destinationTo}'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppPadding.medium),
            child: _buildRow('លេខកៅអី / Seat No. :', ticket?.seatLabel ?? ""),
          ),
          _buildRow('អតិថិជន / Customer :', 'SOkhmer'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.medium),
            child:
                _buildRow('ថ្ងៃទិញ / Issued Date :', ticket?.bookingDate ?? ""),
          ),
          _buildRow('ថ្ងៃធ្វើដំណើរ / Journey Date :', ticket?.travelDate ?? ""),
        ],
      ),
    );
  }

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.large, vertical: AppPadding.large),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: Size(double.infinity, 40)),
          onPressed: () {
            Get.offAllNamed(AppRoutes.homeScreen);
          },
          child: TextExtraMedium(
            text: "Print Ticket",
            color: Colors.white,
          )),
    );
  }
}
