import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/orderDetail.dart';

enum OrderDetailState {
  initial,
  loading,
  silentLoading,
  loaded,
  error,
}

class OrderDetailProvider extends ChangeNotifier {
  String message = '';
  OrderDetailState orderDetailState = OrderDetailState.initial;
  late OrderDetail orderDetail;

  Future getOrderDetail({
    required String orderId,
    required BuildContext context,
  }) async {
    if (orderDetailState == OrderDetailState.loaded) {
      orderDetailState = OrderDetailState.silentLoading;
      notifyListeners();
    } else {
      orderDetailState = OrderDetailState.loading;
      notifyListeners();
    }

    try {
      Map<String, String> params = {};
      params[ApiAndParams.orderId] = orderId;

      Map<String, dynamic> getData =
          (await getOrderDetailRepository(params: params));
      if (getData[ApiAndParams.status].toString() == "1") {
        orderDetail = OrderDetail.fromJson(getData);

        orderDetailState = OrderDetailState.loaded;
        notifyListeners();
      } else {
        orderDetailState = OrderDetailState.error;
        notifyListeners();
        showMessage(
            context, getData[ApiAndParams.message], MessageType.warning);
      }
    }catch (e) {
      message = e.toString();
      orderDetailState = OrderDetailState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }
}
