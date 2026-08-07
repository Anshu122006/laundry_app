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

  @override
  Widget build(BuildContext context) {
    // Read keyboard height dynamically
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      // Margin wrapper to make it look floating and clean
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          // Pushes sheet cleanly above keyboard while leaving breathing room
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar visual for bottom sheet recognition
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(100),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      "Edit ${widget.title}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _inputController,
                      autofocus: true,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: widget.isDecimal,
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: CColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final text = _inputController.text.trim();
                              final num parsedValue =
                                  widget.isDecimal
                                      ? (double.tryParse(text) ?? 0.0)
                                      : (int.tryParse(text) ?? 0);

                              widget.onConfirm(parsedValue);
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
      firstDate: DateTime.now().subtract(
        const Duration(days: 30),
      ), // Allows slight retroactive padding if needed
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ), // Bound to 1 year out
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
