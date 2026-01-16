import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/destination_model.dart';

class TicketState {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  RxInt status = 0.obs;
  RxInt selectedType = 1.obs;

  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();

  // <<< ADDED: Keys to force widget recreation/reset
  int fromWidgetKeyId = 1;
  int toWidgetKeyId = 1;

  // Method to clear all data
  void clearAll() {
    selectedFromId = null;
    selectedFromName = null;
    selectedToId = null;
    selectedToName = null;
    // selectDate = null;
    ticketsFrom.clear();
    ticketsTo.clear();
    futuretoSelect.value = null;
    fromTextController.clear();
    toTextController.clear();
  }

  // From
  final RxList<DestinationResponse> ticketsFrom = <DestinationResponse>[].obs;
  Future<DestinationFromModel>? futureSelect;
  String? selectedFromId;
  String? selectedFromName;
  // =================================

  // To
  final Rxn<Future<DestinationFromModel>> futuretoSelect =
      Rxn<Future<DestinationFromModel>>();

  final RxList<DestinationResponse> ticketsTo = <DestinationResponse>[].obs;
  String? selectedToId;
  String? selectedToName;

  // Date
  // String? selectDate;
  String selectDate = "";
  String? selectDateBack;

  // Error State
  bool showFromError = false;
  bool showToError = false;
  bool showDateError = false;

  // Method to validate all fields
  bool validate() {
    showFromError = selectedFromId == null;
    showToError = selectedToId == null;
    showDateError = selectDate == null;

    return !showFromError && !showToError && !showDateError;
  }
}
