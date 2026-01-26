import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/view/home/data/model/request/booking_history_list_body.dart';
import 'package:vet_internal_ticket/view/home/domain/uscase/booking_history_usecase.dart';
import 'package:vet_internal_ticket/view/home/presentaion/state/car_history_state.dart';

class CarHistoryController extends StateController<CarHistoryState> {
  final BookingHistoryUsecase bookingHistoryUsecase;

  CarHistoryController(this.bookingHistoryUsecase);

  @override
  void onInit() {
    super.onInit();
    getHistories();
  }

  @override
  CarHistoryState onInitUiState() => CarHistoryState();

  Future<void> getHistories() async {
    final st = uiState.value;
    try {
      st.isLoading.value = true;
      st.errorMessage.value = '';

      final body = BookingHistoryListBody(
        page: 1,
        rowsPerPage: 10,
        searchText: '',
        orderBy: '',
        session: '',
      );

      final response =
          await bookingHistoryUsecase.executeGetBookingHistoryList(body);

      final list = response.body?.data ?? [];

      st.histories.value = list;
    } catch (e) {
      st.errorMessage.value = e.toString();
      st.histories.clear();
    } finally {
      st.isLoading.value = false;
    }
  }
}
