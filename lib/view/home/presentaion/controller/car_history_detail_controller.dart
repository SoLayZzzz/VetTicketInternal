import 'package:get/get.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_find_body.dart';
import 'package:vet_internal_ticket/view/home/domain/uscase/booking_history_usecase.dart';
import 'package:vet_internal_ticket/view/home/presentaion/state/car_history_detail_state.dart';

class CarHistoryDetailController
    extends StateController<CarHistoryDetailState> {
  final BookingHistoryUsecase bookingHistoryUsecase;

  CarHistoryDetailController(this.bookingHistoryUsecase);

  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;
    final int? id;

    if (arg is Map && arg['id'] != null) {
      final v = arg['id'];
      if (v is int) {
        id = v;
      } else {
        id = int.tryParse(v.toString());
      }
    } else {
      id = null;
    }

    if (id != null) {
      getDetail(id);
    } else {
      uiState.value.errorMessage.value = 'Missing booking id';
    }
  }

  @override
  CarHistoryDetailState onInitUiState() => CarHistoryDetailState();

  Future<void> getDetail(int id) async {
    final st = uiState.value;
    try {
      st.isLoading.value = true;
      st.errorMessage.value = '';

      final body = BookingHistoryFindBody(id: id);
      final response = await bookingHistoryUsecase.executeGetBookingHistoryById(
          id: id, body: body);

      st.detailResponse.value = response;
    } catch (e) {
      st.errorMessage.value = e.toString();
      st.detailResponse.value = null;
    } finally {
      st.isLoading.value = false;
    }
  }
}
