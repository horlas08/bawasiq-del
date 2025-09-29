import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

enum DeliveryBoyOrdersState {
  initial,
  loading,
  silentLoading,
  loaded,
  empty,
  loadingMore,
  error,
}

class DeliveryBoyOrdersProvider extends ChangeNotifier {
  String message = '';
  DeliveryBoyOrdersState ordersState = DeliveryBoyOrdersState.initial;

  late DeliveryBoyOrder deliveryBoyOrder;
  List<DeliveryBoyOrdersListItem> deliveryBoyOrdersList = [];

  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  int selectedStatus = 0;

  Future getDeliveryBoyOrders({
    required Map<String, String> params,
    required BuildContext context,
    required bool silentLoading,
  }) async {
    if (!silentLoading) {
      if (offset == 0) {
        ordersState = DeliveryBoyOrdersState.loading;
        // Clear the list when starting a new search or filter
        deliveryBoyOrdersList.clear();
      } else {
        ordersState = DeliveryBoyOrdersState.loadingMore;
      }
      notifyListeners();
    }

    params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
    params[ApiAndParams.offset] = offset.toString();
    params[ApiAndParams.status] = selectedStatus.toString();

    try {
      Map<String, dynamic> response = await getOrdersRepository(context: context, params: params);

      if (response[ApiAndParams.status].toString() == "1") {
        deliveryBoyOrder = DeliveryBoyOrder.fromJson(response);
        totalData = int.parse(deliveryBoyOrder.total.toString());

        if (totalData > 0) {
          List<DeliveryBoyOrdersListItem> tempOrders = deliveryBoyOrder.data?.orders ?? [];

          // Don't use addAll for new searches (offset = 0)
          if (offset == 0) {
            deliveryBoyOrdersList = tempOrders;
          } else {
            deliveryBoyOrdersList.addAll(tempOrders);
          }

          hasMoreData = totalData > deliveryBoyOrdersList.length;
          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }

          ordersState = DeliveryBoyOrdersState.loaded;
          notifyListeners();
        } else {
          ordersState = DeliveryBoyOrdersState.empty;
          notifyListeners();
        }
      }
    } catch (e) {
      message = e.toString();
      showMessage(context, message, MessageType.error);
      ordersState = DeliveryBoyOrdersState.error;
      notifyListeners();
    }
  }

  Future<bool> changeDeliveryBoyOrderSelectedStatus(int index) async {
    if (selectedStatus.toString() != index.toString()) {
      selectedStatus = index;
      notifyListeners();
      offset = 0;
      deliveryBoyOrdersList = [];
      return true;
    } else {
      return false;
    }
  }
}
