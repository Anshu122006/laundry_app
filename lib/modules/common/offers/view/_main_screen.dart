import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/offer_controller.dart';
import 'package:laundary_app/data/models/offer.dart';
import 'package:laundary_app/modules/common/offers/widgets/inputs.dart';
import 'package:laundary_app/modules/common/offers/widgets/offer_card.dart';
import 'package:laundary_app/modules/common/offers/widgets/offer_header.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool canEdit = AuthController.instance.userType.value == UserType.admin;

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    OfferHeader.getHeader(),
                    Transform.translate(
                      offset: Offset(0, -15),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() {
                          List<Offer> offers =
                              OfferController.instance.offers
                                  .map((o) => o.value)
                                  .toList();
                          offers.sort(
                            (a, b) => a.priority.compareTo(b.priority),
                          );

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),

                            itemCount: offers.length,
                            itemBuilder:
                                (context, index) =>
                                    OfferCard(offer: offers[index]),
                            // (_, index) => OfferCard(offer: offers[index]),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      ),
      floatingActionButton:
          canEdit
              ? ElevatedButton(
                onPressed:
                    () => Get.bottomSheet(
                      OfferInputs.getAddInput(context),
                      isScrollControlled: true,
                      isDismissible: true,
                    ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Transform.scale(
                  scale: 1.2,
                  child: Icon(
                    Icons.add,
                    color: CColors.white,
                    size: 24,
                    weight: 1,
                  ),
                ),
              )
              : null,
    );
  }
}

// class CardLayout {
//   static getCards(int n, bool canEdit) {
//     int start = 0;
//     List<Widget> cards = [];

//     while (n > 0) {
//       int count = n > 4 ? 4 : n;
//       cards.add(_getBasicUnit(start, count, canEdit));
//       start += count;
//       n -= 4;
//     }
//     return cards;
//   }

//   static Widget _getBasicUnit(int start, int count, bool canEdit) {
//     final controller = OfferController.instance;

//     return Column(
//       spacing: 10,
//       children: [
//         IntrinsicHeight(
//           child: Row(
//             spacing: 10,
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   spacing: 10,
//                   children: [
//                     if (count > 0)
//                       SizedBox(
//                         width: double.infinity,
//                         child: Obx(
//                           () => OfferCard(
//                             index: start,
//                             offer: controller.offers[start].value,
//                             canEdit: canEdit,
//                           ),
//                         ),
//                       ),
//                     if (count > 1)
//                       SizedBox(
//                         width: double.infinity,
//                         child: Obx(
//                           () => OfferCard(
//                             index: start + 1,
//                             offer: controller.offers[start + 1].value,
//                             canEdit: canEdit,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               count > 2
//                   ? Expanded(
//                     flex: 1,
//                     child: Obx(
//                       () => OfferCard(
//                         index: start + 2,
//                         offer: controller.offers[start + 2].value,
//                         canEdit: canEdit,
//                       ),
//                     ),
//                   )
//                   : Expanded(flex: 1, child: SizedBox()),
//             ],
//           ),
//         ),
//         if (count > 3)
//           SizedBox(
//             width: double.infinity,
//             child: Obx(
//               () => OfferCard(
//                 index: start + 3,
//                 offer: controller.offers[start + 3].value,
//                 canEdit: canEdit,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
