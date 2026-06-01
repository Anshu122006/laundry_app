import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laundary_app/data/controllers/contact_controller.dart';
import 'package:laundary_app/data/db_cloud/contact_cloud_db.dart';
import 'package:laundary_app/data/services/url_service.dart';
import 'package:laundary_app/modules/common/contacts/widgets/bottomsheets.dart';
import 'package:laundary_app/modules/common/contacts/widgets/qr_code.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/modules/common/contacts/widgets/contact_row.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactdata = ContactController.instance;

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 25, left: 15),
                      child: CBackButton(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Text(
                        "Contact-us",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        spacing: 12,
                        children: [
                          ContactRow(
                            icon: FontAwesomeIcons.envelope,
                            name: "Email",
                            value: contactdata.contact.value.email,
                            onTap: UrlService.openEmail,
                            onEdit: () {
                              final id =
                                  ContactController.instance.contact.value.id;
                              ContactEditBottomSheet.show(
                                context: context,
                                fieldName: "Email",
                                initialValue: contactdata.contact.value.email,
                                onConfirm: (value) async {
                                  await ContactCloudDb.instance.updateContacts(
                                    id: id,
                                    email: value,
                                  );
                                  await ContactController.instance.syncData();
                                },
                              );
                            },
                          ),

                          ContactRow(
                            icon: FontAwesomeIcons.whatsapp,
                            name: "WhatsApp",
                            value: "+91 ${contactdata.contact.value.whatsapp}",
                            onTap: UrlService.openWhattsapp,
                            onEdit: () {
                              final id =
                                  ContactController.instance.contact.value.id;
                              ContactEditBottomSheet.show(
                                context: context,
                                fieldName: "Whattsapp",
                                initialValue:
                                    contactdata.contact.value.whatsapp,
                                onConfirm: (value) async {
                                  await ContactCloudDb.instance.updateContacts(
                                    id: id,
                                    whatsapp: value,
                                  );
                                  await ContactController.instance.syncData();
                                },
                              );
                            },
                          ),

                          ContactRow(
                            icon: FontAwesomeIcons.mapLocationDot,
                            name: "Location",
                            value: "reach us",
                            onTap: UrlService.openMap,
                            onEdit: () {
                              final id =
                                  ContactController.instance.contact.value.id;
                              ContactEditBottomSheet.show(
                                context: context,
                                fieldName: "Location",
                                initialValue: contactdata.contact.value.map,
                                onConfirm: (value) async {
                                  await ContactCloudDb.instance.updateContacts(
                                    id: id,
                                    map: value,
                                  );
                                  await ContactController.instance.syncData();
                                },
                              );
                            },
                          ),
                          SizedBox(height: 30),
                          QRCode(),
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
