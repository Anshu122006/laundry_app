import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/contact_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactHelper {
  static Future<void> openWhattsapp() async {
    final controller = Get.find<ContactController>();
    String number = controller.contact.value.whatsapp;
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '91$number',
    );
    await launchUrl(whatsappUri, mode: LaunchMode.platformDefault);
  }

  static Future<void> openFacebook() async {
    final controller = Get.find<ContactController>();
    String facebook = controller.contact.value.facebook;
    final Uri facebookUri = Uri(
      scheme: 'https',
      host: 'www.facebook.com',
      path: facebook,
    );

    await launchUrl(facebookUri, mode: LaunchMode.platformDefault);
  }

  static Future<void> openInstagram() async {
    final controller = Get.find<ContactController>();
    String instagram = controller.contact.value.instagram;
    final Uri instagramUri = Uri(
      scheme: 'https',
      host: 'www.instagram.com',
      path: instagram,
    );

    await launchUrl(instagramUri, mode: LaunchMode.platformDefault);
  }

  static Future<void> openEmail() async {
    final controller = Get.find<ContactController>();
    String email = controller.contact.value.email;
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': '', 'body': ''},
    );
    await launchUrl(emailUri, mode: LaunchMode.platformDefault);
  }
}
