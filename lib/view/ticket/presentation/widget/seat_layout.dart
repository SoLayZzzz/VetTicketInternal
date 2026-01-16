import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/utils/colors.dart';

class SeatLayoutSceduleWidget extends StatelessWidget {
  final String layoutJson;
  final List<String> occupiedSeats;
  final List<Map<String, String>> selectedSeats;
  final Function(String value, String label) onSeatTap;
  final bool isScanScreen;
  final int seatType;

  const SeatLayoutSceduleWidget({
    super.key,
    required this.layoutJson,
    required this.occupiedSeats,
    required this.selectedSeats,
    required this.onSeatTap,
    this.isScanScreen = false,
    this.seatType = 1,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final layoutData = jsonDecode(layoutJson) as List<dynamic>;

      int maxColumns = 0;
      for (var row in layoutData) {
        final columns = (row as Map<String, dynamic>)['col'] as List<dynamic>;
        int columnCount = 0;
        for (var col in columns) {
          final attr = col['attr'] as Map<String, dynamic>;
          final colspan = int.tryParse(attr['colspan']?.toString() ?? '1') ?? 1;
          columnCount += colspan;
        }
        if (columnCount > maxColumns) {
          maxColumns = columnCount;
        }
      }

      return ListView.builder(
        itemCount: layoutData.length,
        itemBuilder: (context, rowIndex) {
          final row = layoutData[rowIndex] as Map<String, dynamic>;
          final columns = row['col'] as List<dynamic>;

          int totalColspan = 0;
          for (var col in columns) {
            final attr = col['attr'] as Map<String, dynamic>;
            totalColspan +=
                int.tryParse(attr['colspan']?.toString() ?? '1') ?? 1;
          }
          int remainingSpace = maxColumns - totalColspan;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                if (remainingSpace > 0)
                  Expanded(flex: remainingSpace ~/ 2, child: const SizedBox()),
                ...columns.map((colData) {
                  return _buildSeatItem(
                    context,
                    colData as Map<String, dynamic>,
                    maxColumns,
                  );
                }),
                if (remainingSpace > 0)
                  Expanded(
                      flex: (remainingSpace ~/ 2) + (remainingSpace % 2),
                      child: const SizedBox()),
              ],
            ),
          );
        },
      );
    } catch (e) {
      return Center(child: Text("Error: $e"));
    }
  }

  Widget _buildSeatItem(
    BuildContext context,
    Map<String, dynamic> seatData,
    int maxColumns,
  ) {
    final attr = seatData['attr'] as Map<String, dynamic>;
    final label = seatData['label']?.toString() ?? '';
    final value = seatData['value']?.toString() ?? '';
    final colspan = int.tryParse(attr['colspan']?.toString() ?? '1') ?? 1;

    if (label.isEmpty && value.isEmpty) {
      return Expanded(flex: colspan, child: const SizedBox());
    }

    // ✅ Special cases
    if (label == "Door" || label == "Toilet") {
      return Expanded(
        flex: colspan,
        child: Container(
          margin: const EdgeInsets.all(4),
          child: Center(
            child: Text(label,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }

    if (label == "Down Stair" || label == "Up Stair") {
      return Expanded(
        flex: colspan,
        child: Container(
          height: 30,
          decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(4)),
          child: Center(child: Text(label)),
        ),
      );
    }

    bool isOccupied = occupiedSeats
        .any((s) => s.trim().toLowerCase() == value.trim().toLowerCase());
    bool isSelected = selectedSeats.any(
        (s) => s['value']?.trim().toLowerCase() == value.trim().toLowerCase());

    String seatImage;
    if (label == "Capitain") {
      seatImage = AppIcons.IC_Driver;
      isOccupied = true;
    } else if (label == "Hostess") {
      seatImage = AppIcons.IC_Hotess;
      isOccupied = true;
    } else if (isOccupied) {
      seatImage = seatType == 2
          ? AppIcons.IC_seat_Bed_not_free
          : AppIcons.IC_seat_not_free;
    } else if (isSelected) {
      seatImage =
          seatType == 2 ? AppIcons.IC_seat_Bed_select : AppIcons.IC_seat_select;
    } else {
      seatImage =
          seatType == 2 ? AppIcons.IC_seat_Bed_free : AppIcons.IC_seat_free;
    }

    return Expanded(
      flex: colspan,
      child: GestureDetector(
        onTap:
            value.isEmpty || isOccupied ? null : () => onSeatTap(value, label),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(seatImage, height: 45, width: 45),
            if (label.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TextSmall(text: label, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}

class SeatLayoutWidget extends StatelessWidget {
  final String layoutJson;
  final List<String> scannedSeats; // Already checked-in
  final List<String> bookedSeats; // Booked but not checked-in
  final List<Map<String, String>> selectedSeats; // Selected for action
  final Function(String value, String label) onSeatTap;

  const SeatLayoutWidget({
    super.key,
    required this.layoutJson,
    required this.scannedSeats,
    required this.bookedSeats,
    required this.selectedSeats,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final layoutData = jsonDecode(layoutJson) as List<dynamic>;

      return ListView.builder(
        itemCount: layoutData.length,
        itemBuilder: (context, rowIndex) {
          final row = layoutData[rowIndex] as Map<String, dynamic>;
          final columns = row['col'] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: columns.map((colData) {
                return _buildSeatItem(context, colData as Map<String, dynamic>);
              }).toList(),
            ),
          );
        },
      );
    } catch (e) {
      return Center(child: Text("Error: $e"));
    }
  }

  Widget _buildSeatItem(BuildContext context, Map<String, dynamic> seatData) {
    final label = seatData['label']?.toString() ?? '';
    final value = seatData['value']?.toString() ?? '';

    // ✅ Empty cell in layout
    if (label.isEmpty && value.isEmpty) {
      return const Expanded(child: SizedBox());
    }

    // ✅ Special cases with ICONS (Capitain & Hostess only)
    if (label == "Capitain" || label == "Hostess") {
      String iconPath =
          label == "Capitain" ? AppIcons.IC_Driver : AppIcons.IC_Hotess;

      return Expanded(
        child: Container(
          margin: const EdgeInsets.all(6),
          child: Column(
            children: [
              Image.asset(iconPath, width: 45, height: 45),
              const SizedBox(height: 4),
              TextSmall(text: label, color: Colors.black),
            ],
          ),
        ),
      );
    }

    // ✅ Special cases with TEXT only (Door, Toilet, Up Stair, Down Stair)
    if (label == "Door" ||
        label == "Toilet" ||
        label == "Up Stair" ||
        label == "Down Stair") {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.all(6),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Seat logic
    bool isScanned = scannedSeats.contains(value);
    bool isBooked = bookedSeats.contains(value);
    bool isSelected = selectedSeats.any((s) => s['value'] == value);

    String seatIcon;
    Color tintColor;

    if (isScanned) {
      seatIcon = AppIcons.IC_seat_not_free;
      tintColor =
          AppColors.primaryColor; // Scanned but can be select to show data
    } else if (isSelected) {
      seatIcon = AppIcons.IC_seat_select;
      tintColor = AppColors.drawerColor; // Selected
    } else if (isBooked) {
      seatIcon = AppIcons.IC_seat_free;
      tintColor = Colors.red; // Booked but not yet to scan
    } else {
      seatIcon = AppIcons.IC_seat_free;
      tintColor = Colors.grey.shade200; // Not booked (cannot select)
    }

    return Expanded(
      child: GestureDetector(
        onTap: (isBooked || isScanned)
            ? () => onSeatTap(value, label)
            : null, // ✅ Clickable if booked OR scanned
        child: Container(
          margin: const EdgeInsets.all(6),
          child: Column(
            children: [
              Image.asset(seatIcon, width: 45, height: 45, color: tintColor),
              const SizedBox(height: 4),
              TextSmall(text: label, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
