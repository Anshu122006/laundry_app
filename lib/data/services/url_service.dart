import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/contact_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlService {
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

  static Future<void> openMap() async {
    final controller = Get.find<ContactController>();
    String mapLink = controller.contact.value.map;

    final Uri googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {'api': '1', 'query': mapLink},
    );

    await launchUrl(googleMapsUri, mode: LaunchMode.platformDefault);
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

  static Future<void> joinWhatsAppGroup() async {
    final controller = Get.find<ContactController>();
    String groupLink = controller.contact.value.groupLink;

    final Uri linkUri = Uri.parse(groupLink);

    if (await canLaunchUrl(linkUri)) {
      await launchUrl(linkUri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> openReviewPage() async {
    final controller = Get.find<ContactController>();
    String appId = controller.contact.value.review;

    final Uri playStoreUri = Uri(
      scheme: 'https',
      host: 'play.google.com',
      path: '/store/apps/details',
      queryParameters: {'id': appId, 'showAllReviews': 'true'},
    );

    await launchUrl(playStoreUri, mode: LaunchMode.platformDefault);
  }
}
