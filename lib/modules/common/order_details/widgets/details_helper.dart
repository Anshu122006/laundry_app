import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';

class NumericEditBottomSheet extends StatefulWidget {
  const NumericEditBottomSheet({
    super.key,
    required this.title,
    required this.hintText,
    required this.initialValue,
    required this.onConfirm,
    this.isDecimal = false,
  });

  final String title;
  final String hintText;
  final num initialValue;
  final bool isDecimal;
  final Function(num) onConfirm;

  static Future<T?> show<T>({
    required String title,
    required String hintText,
    required num initialValue,
    required Function(num) onConfirm,
    bool isDecimal = false,
  }) {
    return Get.bottomSheet<T>(
      NumericEditBottomSheet(
        title: title,
        hintText: hintText,
        initialValue: initialValue,
        onConfirm: onConfirm,
        isDecimal: isDecimal,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
    );
  }

  @override
  State<NumericEditBottomSheet> createState() => _NumericEditBottomSheetState();
}

class _NumericEditBottomSheetState extends State<NumericEditBottomSheet> {
  late TextEditingController _inputController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final initialText =
        widget.initialValue == 0 ? '' : widget.initialValue.toString();
    _inputController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final text = _inputController.text.trim();
      final num parsedValue =
          widget.isDecimal
              ? (double.tryParse(text) ?? 0.0)
              : (int.tryParse(text) ?? 0);

      widget.onConfirm(parsedValue);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit ${widget.title}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _inputController,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: widget.isDecimal,
                  ),
                  decoration: InputDecoration(hintText: widget.hintText),
                  onFieldSubmitted: (_) => _submitData(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a value";
                    }
                    if (widget.isDecimal) {
                      if (double.tryParse(value) == null) {
                        return "Enter a valid number";
                      }
                    } else {
                      if (int.tryParse(value) == null) {
                        return "Enter a valid count";
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _submitData,
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsHelper {
  DetailsHelper._();

  /// Opens a Material Date Picker and pipes the verified selection back out
  static Future<void> selectDeliveryDate({
    required BuildContext context,
    required DateTime initialDate,
    required Function(DateTime) onDateSelected,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: CColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}
