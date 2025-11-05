import "dart:core";

class Contact {
  final String id;
  final String whatsapp;
  final String review;
  final String map;
  final String paymentLink;
  final String email;

  Contact({
    required this.id,
    required this.whatsapp,
    required this.review,
    required this.map,
    required this.paymentLink,
    required this.email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? "",
      whatsapp: json['whatsapp'] ?? "",
      review: json['review'] ?? "",
      map: json['map'] ?? "",
      paymentLink: json['paymentLink'] ?? "",
      email: json['email'] ?? "",
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
    };
  }
}
