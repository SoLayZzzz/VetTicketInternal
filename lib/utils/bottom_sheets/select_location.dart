import 'package:flutter/material.dart';
import 'package:vet_internal_ticket/utils/bottom_sheets/text.dart';

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
  late String? selectedText;

  @override
  void initState() {
    super.initState();
    selectedText = widget.text;
  }

  // Function if it have data back it will be update data
  @override
  void didUpdateWidget(covariant SelectLocation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      setState(() {
        selectedText = widget.text;
      });
    }
  }

  void _navigateAndSelect() async {
    if (!widget.isEnabled || widget.isLoading) return;

    if (widget.showChooseScreen) {
      if (widget.locationList.isEmpty) return;

      final result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (_) => ChooseScreen(
            locationList: widget.locationList,
            selectedLocation: selectedText,
            hintText: widget.hintText ?? widget.text,
            noDataIcon: widget.noDataIcon,
            noDataText: widget.noDataText,
            appBarBackgroundColor: widget.appBarBackgroundColorChooseScreen,
            title: widget.titleTextField,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      );

      if (result != null && mounted) {
        setState(() {
          selectedText = result["value"];
        });
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: widget.borderRadius,
              border: Border.all(
                width: widget.borderWidth,
                color: effectiveBorderColor,
              ),
              boxShadow: widget.boxShadow ??
                  [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
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
                          color: widget.isEnabled ? null : Colors.grey,
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
                          : Text14(
                              text: selectedText ??
                                  widget.hintText ??
                                  widget.title.toString(),
                              color: widget.isEnabled
                                  ? widget.textStyle?.color
                                  : Colors.grey,
                              textOverflow: TextOverflow.ellipsis,
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
  const ChooseScreen({
    super.key,
    required this.locationList,
    this.hintText,
    this.selectedLocation,
    this.noDataIcon,
    this.noDataText,
    this.appBarBackgroundColor,
    this.title,
    this.suffixIcon,
  });

  final List<dynamic> locationList;
  final String? hintText;
  final String? selectedLocation;
  final String? noDataText;
  final IconData? noDataIcon;
  final Color? appBarBackgroundColor;
  final String? title;
  final String? suffixIcon;

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  List<dynamic> filteredData = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData = widget.locationList;
    _filterData('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty && widget.selectedLocation != null) {
        _controller.text = widget.selectedLocation!;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }

      filteredData = widget.locationList
          .where(
            (item) =>
                item.toString().toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _selectItem(String value) {
    final index = widget.locationList.indexOf(value);
    Navigator.pop(context, {"value": value, "index": index});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarBackgroundColor,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(
          height: 50,
          child: TextField(
            onChanged: _filterData,
            controller: _controller,
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
      body: filteredData.isEmpty
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
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final value = filteredData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () => _selectItem(value.toString()),
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
  }
}
