// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';
// import 'package:laundary_app/modules/common/order_details/widgets/details_helper.dart';

// class ItemsListEdit extends StatelessWidget {
//   const ItemsListEdit({super.key, required this.type});

//   final String type;

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<OrderDetailsController>();

//     return Obx(
//       () => Column(
//         children: [
//           DetailsHelper.getWashTypeHeader(
//             name: type,
//             context: context,
//             icon: Icon(
//               controller.types[type]!.value
//                   ? Icons.expand_more
//                   : Icons.chevron_left,
//             ),
//             onPressed: () => controller.openCloseSection(type),
//           ),
//           if (controller.types[type]!.value)
//             Transform.translate(
//               offset: Offset(0, -30),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxHeight: 115),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount:
//                       controller.order.value.items
//                           .where((item) => item.type == type)
//                           .length,
//                   itemBuilder: (_, index) {
//                     final item =
//                         controller.order.value.items
//                             .where((item) => item.type == type)
//                             .toList()[index];
//                     int i = controller.indexof(item);
//                     return DetailsHelper.getUpdateTile(
//                       context: context,
//                       name: item.name,
//                       price: item.cost,
//                       index: i,
//                     );
//                   },
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
