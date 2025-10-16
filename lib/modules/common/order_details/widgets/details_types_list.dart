// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:laundary_app/core/utils/device/device_utility.dart';
// import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';

// class ItemTypesList extends StatelessWidget {
//   const ItemTypesList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final controller = Get.find<OrderDetailsController>();
//       Map<String, int> types = controller.order.value.orderTypeCounts;
//       final sortedEntries =
//           types.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

//       final typeNames = sortedEntries.map((e) => e.key).toList();
//       final typeCounts = sortedEntries.map((e) => e.value).toList();

//       return ListView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: types.length,
//         itemBuilder:
//             (context, index) =>
//                 ItemTypeTile(name: typeNames[index], amount: typeCounts[index]),
//         // ItemTypeTile(name: "test", amount: 5),
//       );
//     });
//   }
// }

// class ItemTypeTile extends StatelessWidget {
//   const ItemTypeTile({super.key, required this.name, required this.amount});
//   final String name;
//   final int amount;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minWidth: CDeviceHelper.getScreenWidth() * 0.69,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 190,
//                 child: Text(
//                   name,
//                   style: Theme.of(context).textTheme.labelLarge,
//                 ),
//               ),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: amount.toString(),
//                       style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: " items",
//                       style: Theme.of(context).textTheme.labelSmall!.copyWith(
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
