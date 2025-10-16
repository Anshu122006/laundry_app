import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/controllers/contact_controller.dart';
import 'package:laundary_app/data/models/contacts.dart';

class ContactCloudDb {
  static ContactCloudDb? _instance;
  ContactCloudDb._();
  static ContactCloudDb get instance {
    _instance ??= ContactCloudDb._();
    return _instance!;
  }

  final contacts = FirebaseFirestore.instance.collection('contacts');

  Future<void> addContact(Contact contact) async {
    try {
      final docRef = await contacts.add(contact.toMap());
      await contacts.doc(docRef.id).update({"id": docRef.id});
    } catch (e) {
      // print("Failed to add contact: $e");
    }
  }

  Future<void> updateContacts({
    required String id,
    String? whatsapp,
    String? facebook,
    String? instagram,
    String? email,
  }) async {
    final Map<String, dynamic> updates = {};

    if (whatsapp != null) updates['whatsapp'] = whatsapp;
    if (facebook != null) updates['facebook'] = facebook;
    if (instagram != null) updates['instagram'] = instagram;
    if (email != null) updates['email'] = email;

    ContactController.instance.syncData();
    await contacts.doc(id).update(updates);
  }

  Future<Contact?> getContact() async {
    final query = await contacts.limit(1).get();
    if (query.docs.isNotEmpty) {
      return Contact.fromJson(query.docs.first.data());
    }
    return null;
  }
}
