import 'package:flutter/material.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class CFormInputField extends StatelessWidget {
  const CFormInputField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixCallback,
    this.initialValue,
    this.filled = true,
    this.obscureText = false,
    this.enabled = true,
    this.autofillHints,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    required this.labelText,
  });

  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final String? labelText;
  final String? initialValue;
  final bool filled;
  final bool obscureText;
  final bool enabled;
  final TextEditingController? controller;
  final VoidCallback? suffixCallback;
  final void Function(String)? onChanged;
  final List<String>? autofillHints;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final bool isDark = CDeviceHelper.isDarkMode();
    return SizedBox(
      width: double.infinity,
      child: Opacity(
        opacity: !enabled ? 0.6 : 1,
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          initialValue: initialValue,
          cursorColor: Colors.grey.shade700,
          style: TextStyle(
            color: isDark ? Colors.grey : Colors.grey.shade800,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            filled: filled,
            prefixIcon: prefixIcon,
            labelText: labelText,
            suffixIcon:
                suffixIcon != null
                    ? IconButton(onPressed: suffixCallback, icon: suffixIcon!)
                    : null,
          ),
        ),
      ),
    );
  }
}
