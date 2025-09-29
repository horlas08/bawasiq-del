import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

enum SellerOrdersState {
  initial,
  loading,
  silentLoading,
  loaded,
  empty,
  loadingMore,
  error,
}

class SellerOrdersProvider extends ChangeNotifier {
  String message = '';
  SellerOrdersState ordersState = SellerOrdersState.initial;

  late SellerOrder sellerOrder;
  List<SellerOrdersListItem> sellerOrdersList = [];

  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  int selectedStatus = 0;

  Future getSellerOrders({
    required Map<String, String> params,
    required BuildContext context,
    bool? silentLoading,
  }) async {
    if (offset == 0) {
      ordersState = SellerOrdersState.loading;
    } else {
      ordersState = SellerOrdersState.loadingMore;
    }
    notifyListeners();

    params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
    params[ApiAndParams.offset] = offset.toString();

    params[ApiAndParams.status] = selectedStatus.toString();
    try {
      Map<String, dynamic> response = {};

      response = await getOrdersRepository(context: context, params: params);

      if (response[ApiAndParams.status].toString() == "1") {
        sellerOrder = SellerOrder.fromJson(response);

        totalData = int.parse(sellerOrder.total.toString());

        if (totalData > 0) {
          List<SellerOrdersListItem> tempOrders =
              sellerOrder.data?.orders ?? [];

          sellerOrdersList.addAll(tempOrders);

          hasMoreData = totalData > sellerOrdersList.length;

          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }
          ordersState = SellerOrdersState.loaded;
          notifyListeners();
        } else {
          ordersState = SellerOrdersState.empty;
          notifyListeners();
        }
      }
    }catch (e) {
      message = e.toString();
      showMessage(context, message, MessageType.error);
      ordersState = SellerOrdersState.error;
      notifyListeners();
    }
  }

  Future<bool> changeSellerOrderSelectedStatus(int index) async {
    if (selectedStatus.toString() != index.toString()) {
      selectedStatus = index;
      notifyListeners();
      offset = 0;
      sellerOrdersList = [];
      return true;
    } else {
      return false;
    }
  }
}
