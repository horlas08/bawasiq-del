import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

enum ChangeStockState {
  initial,
  loaded,
  loading,
  empty,
  error,
}

class ProductStockUpdateProvider extends ChangeNotifier {
  ChangeStockState changeStockState = ChangeStockState.initial;
  String message = '';

  updateProductStockProvider(
      {required Map<String, dynamic> params,
      required BuildContext context}) async {
    changeStockState = ChangeStockState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> response = {};

      response =
          await getUpdateProductStockApi(context: context, params: params);

      if (response[ApiAndParams.status].toString() == "1") {
        changeStockState = ChangeStockState.loaded;
        notifyListeners();
      } else {
        changeStockState = ChangeStockState.empty;
        notifyListeners();
      }
      showMessage(context, response[ApiAndParams.message].toString(), response[ApiAndParams.status].toString() == "1" ? MessageType.success : MessageType.error);
    }catch (e) {
      message = e.toString();
      showMessage(context, message, MessageType.error);
      changeStockState = ChangeStockState.error;
      notifyListeners();
    }
  }
}
