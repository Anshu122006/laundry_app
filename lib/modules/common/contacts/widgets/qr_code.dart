import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/contact_controller.dart';
import 'package:laundary_app/data/db_cloud/contact_cloud_db.dart';
import 'package:laundary_app/modules/common/contacts/widgets/bottomsheets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class QRCode extends StatelessWidget {
  const QRCode({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAdmin = AuthController.instance.userType.value == UserType.admin;
    double width = CDeviceHelper.getScreenWidth();
    String paymentLink = ContactController.instance.contact.value.paymentLink;

    return SizedBox(
      height: CDeviceHelper.getScreenHeight(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "SCAN TO PAY FOR YOUR ORDERS",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isAdmin)
                  IconButton(
                    onPressed: () {
                      final id = ContactController.instance.contact.value.id;
                      ContactEditBottomSheet.show(
                        context: context,
                        fieldName: "Payment Link",
                        initialValue: paymentLink,
                        onConfirm: (value) async {
                          await ContactCloudDb.instance.updateContacts(
                            id: id,
                            paymentLink: value,
                          );
                          await ContactController.instance.syncData();
                        },
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color:
                          CDeviceHelper.isDarkMode()
                              ? CColors.white
                              : CColors.black,
                      size: 24,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: CLineDivider(),
            ),
            const SizedBox(height: 20),

            Center(
              child: QrImageView(
                data:
                    paymentLink.isNotEmpty
                        ? paymentLink
                        : "No payment link found",
                version: QrVersions.auto,
                size: width * 0.6,
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: CLineDivider(),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Payments are handled securely through your chosen payment app. This app does not process payments directly.",
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
