import "dart:core";

class Contact {
  final String id;
  final String whatsapp;
  final String review;
  final String map;
  final String paymentLink;
  final String email;
  final String groupLink;
  final List<String> extraLinks;

  Contact({
    required this.id,
    required this.whatsapp,
    required this.review,
    required this.map,
    required this.paymentLink,
    required this.email,
    required this.groupLink,
    required this.extraLinks,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? "",
      whatsapp: json['whatsapp'] ?? "",
      review: json['review'] ?? "",
      map: json['map'] ?? "",
      paymentLink: json['paymentLink'] ?? "",
      email: json['email'] ?? "",
      groupLink: json['groupLink'] ?? "",
      extraLinks:
          json['extraLinks'] != null
              ? List<String>.from(json['extraLinks'])
              : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'whatsapp': whatsapp,
      'review': review,
      'map': map,
      'paymentLink': paymentLink,
      'email': email,
      'groupLink': groupLink,
      'extraLinks': extraLinks,
    };
  }
}
