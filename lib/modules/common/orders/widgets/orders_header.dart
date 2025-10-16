import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/modules/common/orders/controller/orders_controller.dart';
import 'package:laundary_app/shared/edges/bottom_inward_curved.dart';
import 'package:laundary_app/shared/widgets/searchbar.dart';

class OrderListHeader {
  static List<Widget> getHeader(BuildContext context) {
    final controller = Get.find<OrderListController>();
    bool isClient = AuthController.instance.userType.value == UserType.client;
    final topPadding = MediaQuery.of(context).padding.top;
    final double topHeight = CDeviceHelper.getScreenHeight() * 0.08;
    final double bottomHeight =
        CDeviceHelper.getScreenHeight() * (isClient ? 0.09 : 0.18);

    return <Widget>[
      SliverAppBar(
        automaticallyImplyLeading: false,
        pinned: true,
        expandedHeight: topHeight + bottomHeight,
        flexibleSpace: SizedBox(
          height: topHeight + topPadding,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: CColors.primaryColor)),
              Positioned(
                top: 45,
                left: 25,
                child: Text(
                  'Orders',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: CColors.secondaryColor,
                  ),
                ),
              ),
              if (!isClient) Positioned(top: 42, right: 20, child: SortBy()),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(bottomHeight),
          child: ClipPath(
            clipper: CBottomInwardCurvedEdge(),
            child: Container(
              height: bottomHeight,
              color: CColors.primaryColor,
              child: Column(
                children: [
                  if (!isClient) SizedBox(height: 20),
                  if (!isClient)
                    CSearchbar(
                      onChanged:
                          (value) => controller.searchQuery.value = value,
                      labelText: "Search for orders",
                    ),
                  SizedBox(height: 5),
                  TabBar(
                    isScrollable: true,
                    indicatorColor: CColors.white,
                    tabs: [
                      Tab(text: 'Placed'),
                      Tab(text: 'Picked'),
                      Tab(text: 'Delivered'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }
}

class SortBy extends StatelessWidget {
  const SortBy({super.key});

  static const sortOptions = ['name', 'room', 'phone'];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderListController>();

    return Row(
      children: [
        const SizedBox(width: 20),
        Text("Sort By: "),
        Obx(
          () => DropdownButton<String>(
            elevation: 3,
            underline: const SizedBox(),
            value:
                sortOptions.contains(controller.sortBy.value)
                    ? controller.sortBy.value
                    : sortOptions.first,
            onChanged: (value) {
              if (value != null) {
                controller.sortBy.value = value;
              }
            },
            items:
                sortOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(
                      option[0].toUpperCase() +
                          option.substring(1),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
