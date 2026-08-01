import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/transaction_controller.dart';
import 'package:laundary_app/data/models/transaction.dart';

class ClientHistoryController extends GetxController {
  final String clientId;

  ClientHistoryController({required this.clientId});

  /// Reactively filters, sorts, and delivers transactions for this client.
  /// It listens automatically to the root TransactionController data layer.
  List<LaundryTransaction> get clientTransactions {
    final filtered =
        TransactionController.instance.transactions
            .map((t) => t.value)
            .where((t) => t.client?.id == clientId)
            .toList();

    // Sort descending by date (Newest transactions appear first)
    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  /// Optional Helper: Easily fetch total lifetime spent by this client
  int get totalLifetimeSpent {
    return clientTransactions
        .where(
          (t) => t.type == "removed",
        ) // assuming 'removed' means spent/deducted
        .fold(0, (sum, t) => sum + t.amount);
  }

  /// Optional Helper: Check if the client has any records at all
  bool get hasNoHistory => clientTransactions.isEmpty;
}
