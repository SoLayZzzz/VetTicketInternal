// ignore_for_file: avoid_print

import 'dart:async';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_route.dart';
import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_from_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_to_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/destination_model.dart';
import 'package:vet_internal_ticket/booking_service.dart';
import 'package:vet_internal_ticket/view/ticket/domain/uscase/ticket_usecase.dart';
import 'package:vet_internal_ticket/view/ticket/presentation/state/ticket_state.dart';

class TicketMenuController extends StateController<TicketState> {
  final TicketUsecase _useCase;
  TicketMenuController(this._useCase);

  @override
  TicketState onInitUiState() => TicketState();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    final bookingService = Get.find<BookingService>();
    bookingService.reset();
    print("====> BookingService reset called");
    bookingService.bookingData.debugPrint();
  }

  Future<void> loadInitialData() async {
    try {
      uiState.value.futureSelect = fetchDestinationsFrom();
    } catch (e) {
      uiState.value.errorMessage.value = 'Failed to load initial data: $e';
    }
  }

  Future<DestinationFromModel> fetchDestinationsFrom() async {
    try {
      uiState.value.isLoading.value = true;
      uiState.value.errorMessage.value = '';

      final body = DestinationFromBody(
        lang: "kh",
        type: uiState.value.selectedType.toString(),
        searchText: "",
      );

      final result = await _useCase.executeDestinationFrom(body);

      uiState.update((state) {
        state?.ticketsFrom.assignAll(result.body ?? []);
        state?.status.value = 200;
      });

      return result;
    } catch (e) {
      uiState.value.errorMessage.value = 'Failed to load destinations: $e';
      uiState.value.status.value = -1;
      rethrow;
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  Future<DestinationFromModel?> loadDestinationTo(
      DestinationToBody body) async {
    uiState.value.isLoading.value = true;

    final resultFuture = _useCase.executeDestinationTo(body);

    uiState.update((state) {
      state?.futuretoSelect.value = resultFuture;
      state?.ticketsTo.clear();
      state?.status.value = 0;
    });

    try {
      final result = await resultFuture;

      uiState.update((state) {
        state?.ticketsTo.assignAll(result.body ?? []);
        state?.status.value = 200;
      });

      return result;
    } catch (e) {
      uiState.value.errorMessage.value = 'Failed to load destinations: $e';
      uiState.value.status.value = -1;
      rethrow;
    } finally {
      uiState.value.isLoading.value = false;
    }
  }

  void setTransportType(int type) {
    if (uiState.value.selectedType.value == type) return;

    uiState.update((state) {
      state?.selectedType.value = type;
      state?.selectedFromId = null;
      state?.selectedFromName = null;
      state?.selectedToId = null;
      state?.selectedToName = null;
      state?.ticketsTo.clear();
      state?.futuretoSelect.value = null;
      state?.fromWidgetKeyId++;
      state?.toWidgetKeyId++;
      state?.futureSelect = fetchDestinationsFrom();
    });
  }

  void resetSelections() {
    uiState.update((state) {
      state?.selectedFromId = null;
      state?.selectedFromName = null;
      state?.selectedToId = null;
      state?.selectedToName = null;
      state?.ticketsTo.clear();
      state?.futuretoSelect.value = null;
      state?.fromWidgetKeyId++;
      state?.toWidgetKeyId++;
    });
  }

  void setSelectedFrom(String? id, String? name) {
    uiState.update((state) {
      if (state == null) return;
      state.selectedFromId = id;
      state.selectedFromName = name;
      // FIX: When it back to have data it will be remove error state if it empty it will be show error state
      state.showFromError = false;

      // Reset subsequent fields
      state.selectedToId = null;
      state.selectedToName = null;
      state.ticketsTo.clear();
      state.futuretoSelect.value = null;
      state.toWidgetKeyId++;
    });
  }

  void setSelectedTo(String? id, String? name) {
    uiState.update((state) {
      if (state == null) return;
      state.selectedToId = id;
      state.selectedToName = name;
      // FIX: When a user selects a value, remove the error state.
      state.showToError = false;
    });
  }

  void updateSelectedDate(String date) {
    uiState.update((state) {
      state?.selectDate = date;
      state?.showDateError = false;
    });
  }

  void updateSelectedReturnDate(String? date) {
    uiState.update((state) {
      state?.selectDateBack = date;
    });
  }

  void navigateToScheduleList() async {
    if (!uiState.value.validate()) {
      uiState.update((state) {
        if (state == null) return;
        state.showFromError = state.selectedFromId == null;
        state.showToError = state.selectedToId == null;

        state.showDateError = state.selectDate.isEmpty;
      });
      return;
    }

    final result = await Get.toNamed(
      AppRoutes.schedule_list_screen,
      arguments: {
        'fromId': uiState.value.selectedFromId!,
        'fromName': uiState.value.selectedFromName!,
        'toId': uiState.value.selectedToId!,
        'toName': uiState.value.selectedToName!,
        'date': uiState.value.selectDate,
        'type': uiState.value.selectedType.value,
        'dateback': uiState.value.selectDateBack ?? "",
      },
    );

    // Update the date if a new one was returned
    if (result != null && result is String) {
      updateSelectedDate(result);
    }
  }
}
