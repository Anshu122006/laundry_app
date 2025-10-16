import 'package:laundary_app/data/models/order.dart';

class StatusHelper {
  static String getMessageTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return "ORDER PLACED";
      case OrderStatus.picked:
        return "ORDER PICKED";
      case OrderStatus.washing:
        return "WASHING...";
      case OrderStatus.ready:
        return "ORDER READY";
      case OrderStatus.delivered:
        return "ORDER DELIVERED";
      case OrderStatus.cancelled:
        return "ORDER CANCELLED";
    }
  }

  static String getMessageSubtitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return "Please kindly wait, we are still\nprocessing your order";
      case OrderStatus.picked:
        return "Our agent has picked your order\nplease stand by";
      case OrderStatus.washing:
        return "Your order is washing, it would be\nready soon";
      case OrderStatus.ready:
        return "Your order is ready, Our agent will\ndeliver it soon";
      case OrderStatus.delivered:
        return "Your order was delivered\nsuccessfully";
      case OrderStatus.cancelled:
        return "Your order was cancelled, check contacts\nif you had any issue";
    }
  } 

  static String getStatusImage(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return "assets/illustrations/order_placed.png";
      case OrderStatus.picked:
        return "assets/illustrations/order_picked.png";
      case OrderStatus.washing:
        return "assets/illustrations/order_washing.png";
      case OrderStatus.ready:
        return "assets/illustrations/order_ready.png";
      case OrderStatus.delivered:
        return "assets/illustrations/order_delivered.png";
      case OrderStatus.cancelled:
        return "assets/illustrations/order_cancelled.png";
    }
  }   
}
