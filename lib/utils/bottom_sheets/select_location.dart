import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/utils/bottom_sheets/text.dart';

class SelectLocationController extends GetxController {
  SelectLocationController({this.selectedText});

  String? selectedText;

  void setSelectedText(String? value) {
    selectedText = value;
    update();
  }
}

class SelectLocation extends StatefulWidget {
  const SelectLocation({
    super.key,
    required this.hasData,
    this.borderRadius,
    this.locationList = const [],
    this.backgroundColor,
    this.borderColor = Colors.grey,
    this.activeBorderColor,
    this.borderWidth = 1,
    this.assetImage,
    this.text,
    this.showChooseScreen = false,
    this.onTap,
    this.onSelected,
    this.noDataIcon = Icons.close_outlined,
    this.noDataText,
    this.textStyle,
    this.isLoading = false,
    this.isEnabled = true,
    this.hintText,
    this.appBarBackgroundColorChooseScreen,
    this.titleTextField,
    this.title,
    this.hasError = false,
    this.errorText,
    this.suffixIcon,
    this.boxShadow,
  });

  final bool hasData;
  final Color? activeBorderColor;
  final BorderRadius? borderRadius;
  final List<dynamic> locationList;
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final AssetImage? assetImage;
  final String? text;
  final bool showChooseScreen;
  final VoidCallback? onTap;
  final ValueChanged<int>? onSelected;
  final String? noDataText;
  final IconData? noDataIcon;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool isEnabled;
  final String? hintText;
  final Color? appBarBackgroundColorChooseScreen;
  final String? titleTextField;
  final String? title;
  final bool hasError;
  final String? errorText;
  final String? suffixIcon;
  final List<BoxShadow>? boxShadow;

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  late final String _controllerTag;
  late final SelectLocationController _controller;

  @override
  void initState() {
    super.initState();
    _controllerTag = '${widget.hashCode}_${identityHashCode(this)}';
    _controller = Get.put(
      SelectLocationController(selectedText: widget.text),
      tag: _controllerTag,
    );
  }

  // Function if it have data back it will be update data
  @override
  void didUpdateWidget(covariant SelectLocation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _controller.setSelectedText(widget.text);
    }
  }

  @override
  void dispose() {
    if (Get.isRegistered<SelectLocationController>(tag: _controllerTag)) {
      Get.delete<SelectLocationController>(tag: _controllerTag);
    }
    super.dispose();
  }

  void _navigateAndSelect() async {
    if (!widget.isEnabled || widget.isLoading) return;

    if (widget.showChooseScreen) {
      if (widget.locationList.isEmpty) return;

      final result = await Get.to<Map<String, dynamic>>(
        () => ChooseScreen(
          locationList: widget.locationList,
          selectedLocation: _controller.selectedText,
          hintText: widget.hintText ?? widget.text,
          noDataIcon: widget.noDataIcon,
          noDataText: widget.noDataText,
          appBarBackgroundColor: widget.appBarBackgroundColorChooseScreen,
          title: widget.titleTextField,
          suffixIcon: widget.suffixIcon,
        ),
      );

      if (result != null && mounted) {
        _controller.setSelectedText(result["value"]);
        widget.onSelected?.call(result["index"]);
      }
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = widget.hasError
        ? Colors.red
        : (widget.activeBorderColor != null && widget.hasData)
            ? widget.activeBorderColor!
            : widget.borderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _navigateAndSelect,
          child: Container(
            // duration: const Duration(milliseconds: 300),
            // curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: widget.borderRadius,
              border: Border.all(
                width: 0.5,
                color: effectiveBorderColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 18),
              child: Center(
                child: Row(
                  children: [
                    if (widget.assetImage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Image(
                          image: widget.assetImage!,
                          width: 24,
                          color: Colors.black,
                        ),
                      ),
                    Expanded(
                      child: widget.isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : GetBuilder<SelectLocationController>(
                              tag: _controllerTag,
                              builder: (controller) {
                                return Text14(
                                  text: controller.selectedText ??
                                      widget.hintText ??
                                      widget.title.toString(),
                                  color: widget.isEnabled
                                      ? widget.textStyle?.color
                                      : Colors.black,
                                  textOverflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.hasError && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text12(text: widget.errorText!, color: Colors.red),
          ),
      ],
    );
  }
}

class ChooseScreen extends StatefulWidget {
  ChooseScreen({
    super.key,
    required this.locationList,
    this.hintText,
    this.selectedLocation,
    this.noDataIcon,
    this.noDataText,
    this.appBarBackgroundColor,
    this.title,
    this.suffixIcon,
  }) : controllerTag =
            '${DateTime.now().microsecondsSinceEpoch}_${locationList.hashCode}';

  final List<dynamic> locationList;
  final String? hintText;
  final String? selectedLocation;
  final String? noDataText;
  final IconData? noDataIcon;
  final Color? appBarBackgroundColor;
  final String? title;
  final String? suffixIcon;

  final String controllerTag;

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    Get.put(
      ChooseScreenController(locationList: widget.locationList),
      tag: widget.controllerTag,
    );

    _textController = TextEditingController(text: widget.selectedLocation);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = Get.find<ChooseScreenController>(tag: widget.controllerTag);
      c.filterData(_textController.text);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    if (Get.isRegistered<ChooseScreenController>(tag: widget.controllerTag)) {
      Get.delete<ChooseScreenController>(tag: widget.controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChooseScreenController>(
      tag: widget.controllerTag,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: widget.appBarBackgroundColor,
            toolbarHeight: 80,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: SizedBox(
              height: 50,
              child: TextField(
                onChanged: controller.filterData,
                controller: _textController,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.hintText ?? widget.title,
                  suffixIcon: widget.suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(widget.suffixIcon!),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          body: controller.filteredData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.noDataIcon, size: 50, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text24(
                        text: widget.noDataText ?? 'No data found',
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: controller.filteredData.length,
                  itemBuilder: (context, index) {
                    final value = controller.filteredData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () => controller.selectItem(value.toString()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            border: const Border(
                              bottom: BorderSide(width: 1, color: Colors.grey),
                            ),
                            color: value.toString() == widget.selectedLocation
                                ? Colors.grey[200]
                                : Colors.transparent,
                          ),
                          child: Text(value.toString()),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class ChooseScreenController extends GetxController {
  ChooseScreenController({
    required this.locationList,
  });

  final List<dynamic> locationList;
  List<dynamic> filteredData = [];

  @override
  void onInit() {
    super.onInit();
    filteredData = locationList;
    filterData('');
  }

  void filterData(String query) {
    filteredData = locationList
        .where(
          (item) => item.toString().toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    update();
  }

  void selectItem(String value) {
    final index = locationList.indexOf(value);
    Get.back(result: {"value": value, "index": index});
  }
}
