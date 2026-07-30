import 'package:equatable/equatable.dart';

class ContactUsEntity extends Equatable {
  const ContactUsEntity({
    required this.x,
    required this.tiktok,
    required this.instagram,
    required this.facebook,
    required this.snapchat,
    required this.email,
    required this.youtube,
    required this.whatsapp,
    required this.mobiles,
    required this.appProvider,
    required this.playProvider,
  });

  final String x;
  final String tiktok;
  final String instagram;
  final String facebook;
  final String snapchat;
  final String youtube;
  final String appProvider;
  final String playProvider;
  final String email;
  final List<String> whatsapp;
  final List<String> mobiles;

  List<String> get getSocialLinks {
    return [
      if (x.isNotEmpty) x,
      if (tiktok.isNotEmpty) tiktok,
      if (instagram.isNotEmpty) instagram,
      if (facebook.isNotEmpty) facebook,
      if (snapchat.isNotEmpty) snapchat,
      if (youtube.isNotEmpty) youtube,
      if (appProvider.isNotEmpty) appProvider,
      if (playProvider.isNotEmpty) playProvider,
    ];
  }

  @override
  List<Object?> get props => [x, tiktok, instagram, facebook, snapchat, youtube, email, whatsapp, mobiles, playProvider, appProvider];

  factory ContactUsEntity.fromJson(Map<String, dynamic> json) {
    final whatsapp = json['social']['whatsapp'];
    return ContactUsEntity(
      email: json['email'] ?? '',
      x: json['social']['x'] ?? '',
      tiktok: json['social']['tiktok'] ?? '',
      instagram: json['social']['instagram'] ?? '',
      facebook: json['social']['facebook'] ?? '',
      snapchat: json['social']['snapchat'] ?? '',
      youtube: json['social']['youtube'] ?? '',
      appProvider: json['social']['app_provider'] ?? '',
      playProvider: json['social']['play_provider'] ?? '',
      mobiles: json['mobiles'] != null ? List<String>.from(json['mobiles']) : [],
      whatsapp: whatsapp is List
          ? List<String>.from(json['social']['whatsapp'])
          : whatsapp is String
          ? [whatsapp]
          : [],
    );
  }
}
