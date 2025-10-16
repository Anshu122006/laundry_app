import "dart:core";

class Contact {
  final String id;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String email;

  Contact({
    required this.id,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? "",
      whatsapp: json['whatsapp'] ?? "",
      facebook: json['facebook'] ?? "",
      instagram: json['instagram'] ?? "",
      email: json['email'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'whatsapp': whatsapp,
      'facebook': facebook,
      'instagram': instagram,
      'email': email,
    };
  }
}
