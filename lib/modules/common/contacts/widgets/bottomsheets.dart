import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactEditBottomSheet {
  static void show({
    required BuildContext context,
    required String fieldName,
    required String initialValue,
    required Future<void> Function(String) onConfirm
  }) {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder:
          (context) => SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 15,
                right: 15,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update $fieldName",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter new $fieldName",
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async{
                        FocusManager.instance.primaryFocus?.unfocus();
                        Get.back(); // close bottom sheet
                       await onConfirm(controller.text.trim());
                      },
                      child: const Text("Confirm"),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
