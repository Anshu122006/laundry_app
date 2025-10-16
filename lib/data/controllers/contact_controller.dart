import 'dart:async';

import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/contact_cloud_db.dart';
import 'package:laundary_app/data/models/contacts.dart';

class ContactController extends GetxController {
  static ContactController get instance {
    return Get.find<ContactController>();
  }

  Rx<Contact> contact =
      Contact(id: "", email: "", facebook: "", instagram: "", whatsapp: "").obs;

  static Future<void> initController() async {
    if (!Get.isRegistered<ContactController>()) {
      Get.put(ContactController(), permanent: true);
    }

    Contact? contact = await ContactCloudDb.instance.getContact();
    if (contact != null) ContactController.instance.contact.value = contact;
  }

  Future<void> syncData() async {
    Contact? contact = await ContactCloudDb.instance.getContact();
    if (contact != null) ContactController.instance.contact.value = contact;
  }
}
