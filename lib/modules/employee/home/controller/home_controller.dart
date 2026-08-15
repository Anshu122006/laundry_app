import 'package:get/get.dart';
import 'package:laundary_app/core/utils/helpers/helpers.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/models/order.dart';

class EmployeeHomeController extends GetxController {
  // Computed values are driven reactively from OrderController.instance.orders
  
  List<Rx<LaundryOrder>> get recentOrders {
    List<Rx<LaundryOrder>> orders = OrderController.instance.orders
        .where((order) => CDateHelper.isToday(order.value.placedDate))
        .toList();
    orders.sort((a, b)=>b.value.placedDate.compareTo(a.value.placedDate));
    return orders;
  }

  int get placed => recentOrders.length;

  int get toPick {
    return OrderController.instance.orders
        .where((order) => order.value.status == OrderStatus.pending)
        .length;
  }

  int get toDeliver {
    return OrderController.instance.orders
        .where((order) => order.value.status == OrderStatus.ready)
        .length;
  }
}