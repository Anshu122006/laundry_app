import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CIcons {
  CIcons._();

  static Icon successCheck = Icon(
    Icons.check_circle,
    color: CColors.secondaryColor,
  );
  static Icon errorCross = Icon(Icons.cancel, color: CColors.secondaryColor);
  static Icon welcome = Icon(Icons.waving_hand, color: CColors.secondaryColor);
  static Icon info = Icon(Icons.info, color: CColors.secondaryColor);

  static Icon userIcon = Icon(Icons.person);
  static Icon emailIcon = Icon(Icons.email);
  static Icon password = Icon(Icons.password);
  static Icon phoneIcon = Icon(Icons.phone);
  static Icon hostelIcon = Icon(Icons.apartment);
  static Icon roomIcon = Icon(Icons.door_sliding);
  static Icon wallet = Icon(Icons.wallet);
  static Icon passbook = Icon(FontAwesomeIcons.moneyCheck);
  static Icon prices = Icon(FontAwesomeIcons.coins);
  static Icon offers = Icon(Icons.local_offer);
  static Icon contactus = Icon(Icons.support_agent);
  static Icon role = Icon(FontAwesomeIcons.idBadge);
  static Icon editIcon = Icon(Icons.edit, color: CColors.secondaryColor);

  static Icon hangerIcon = Icon(Icons.checkroom, color: CColors.blue);
  static Icon clothIcon = Icon(Icons.dry_cleaning, color: CColors.white);
  static Icon laundryIcon = Icon(
    Icons.local_laundry_service,
    color: CColors.blue,
  );
}
