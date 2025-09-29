import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

enum ProductDeliveryBoysState {
  initial,
  loading,
  loaded,
  updating,
  loadingMore,
  error,
}

class DeliveryBoysProvider extends ChangeNotifier {
  ProductDeliveryBoysState deliveryBoysState = ProductDeliveryBoysState.initial;
  String message = '';
  late DeliveryBoys deliveryBoys;
  List<DeliveryBoysData> deliveryBoysList = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  String selectedDeliveryBoy = "0";

  getDeliveryBoys({
    required int selectedDeliveryBoyIndex,
    required BuildContext context,
    required String cityId,
  }) async {
    if (offset == 0) {
      deliveryBoysState = ProductDeliveryBoysState.loading;
      notifyListeners();
    } else {
      deliveryBoysState = ProductDeliveryBoysState.loadingMore;
      notifyListeners();
    }

    try {
      Map<String, String> params = {};
      selectedDeliveryBoy = selectedDeliveryBoyIndex.toString();
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();
      params[ApiAndParams.city_id] = cityId;

      Map<String, dynamic> getData =
          (await getDeliveryBoysRepository(params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        deliveryBoys = DeliveryBoys.fromJson(getData);
        totalData = getData[ApiAndParams.total];
        List<DeliveryBoysData> tempDeliveryBoys = deliveryBoys.data ?? [];

        deliveryBoysList.addAll(tempDeliveryBoys);
      }

      hasMoreData = totalData > deliveryBoysList.length;
      if (hasMoreData) {
        offset += Constant.defaultDataLoadLimitAtOnce;
      }

      deliveryBoysState = ProductDeliveryBoysState.loaded;
      notifyListeners();
    }catch (e) {
      message = e.toString();
      deliveryBoysState = ProductDeliveryBoysState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }

  Future updateOrdersDeliveryBoy({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    try {
      deliveryBoysState = ProductDeliveryBoysState.updating;
      notifyListeners();

      Map<String, dynamic> getUpdatedOrderData =
          await updateOrdersDeliveryBoyRepository(params: params);
      if (getUpdatedOrderData[ApiAndParams.status].toString() == "1") {
        deliveryBoysState = ProductDeliveryBoysState.loaded;
        notifyListeners();
        return true;
      } else {
        deliveryBoysState = ProductDeliveryBoysState.error;
        showMessage(context, getUpdatedOrderData[ApiAndParams.message],
            MessageType.warning);
        notifyListeners();
        return false;
      }
    }catch (e) {
      message = e.toString();
      deliveryBoysState = ProductDeliveryBoysState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return false;
    }
  }

  Future setSelectedIndex(String index) async {
    selectedDeliveryBoy = index;
    notifyListeners();
  }
}
