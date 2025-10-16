import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laundary_app/data/controllers/contact_controller.dart';
import 'package:laundary_app/data/db_cloud/contact_cloud_db.dart';
import 'package:laundary_app/modules/common/contacts/widgets/bottomsheets.dart';
import 'package:laundary_app/modules/common/contacts/widgets/contact_helper.dart';
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
                            icon: FontAwesomeIcons.whatsapp,
                            name: "WhatsApp",
                            value: "+91 ${contactdata.contact.value.whatsapp}",
                            onTap: ContactHelper.openWhattsapp,
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
                            icon: FontAwesomeIcons.facebook,
                            name: "Facebook",
                            value: contactdata.contact.value.facebook,
                            onTap: ContactHelper.openFacebook,
                            onEdit: () {
                              final id =
                                  ContactController.instance.contact.value.id;
                              ContactEditBottomSheet.show(
                                context: context,
                                fieldName: "Facebook",
                                initialValue:
                                    contactdata.contact.value.facebook,
                                onConfirm: (value) async {
                                  await ContactCloudDb.instance.updateContacts(
                                    id: id,
                                    facebook: value,
                                  );
                                  await ContactController.instance.syncData();
                                },
                              );
                            },
                          ),

                          ContactRow(
                            icon: FontAwesomeIcons.instagram,
                            name: "Instagram",
                            value: contactdata.contact.value.instagram,
                            onTap: ContactHelper.openInstagram,
                            onEdit: () {
                              final id =
                                  ContactController.instance.contact.value.id;
                              ContactEditBottomSheet.show(
                                context: context,
                                fieldName: "Instagram",
                                initialValue:
                                    contactdata.contact.value.instagram,
                                onConfirm: (value) async {
                                  await ContactCloudDb.instance.updateContacts(
                                    id: id,
                                    instagram: value,
                                  );
                                  await ContactController.instance.syncData();
                                },
                              );
                            },
                          ),

                          ContactRow(
                            icon: FontAwesomeIcons.envelope,
                            name: "Email",
                            value: contactdata.contact.value.email,
                            onTap: ContactHelper.openEmail,
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

                          // SizedBox(height: 10),
                          // FeedbackForm(),
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
