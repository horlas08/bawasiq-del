import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

enum StockManagementState {
  initial,
  loaded,
  loading,
  loadingMore,
  empty,
  error,
}

class ProductStockManagementProvider extends ChangeNotifier {
  StockManagementState stockManagementState = StockManagementState.initial;
  String message = '';
  late ProductsStockManagement productsStockManagement;
  List<ProductsStockManagementData> productsStockManagementData = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getProductVariantsProvider(
      {required Map<String, dynamic> params,
      required BuildContext context}) async {
    if (offset == 0) {
      stockManagementState = StockManagementState.loading;
    } else {
      stockManagementState = StockManagementState.loadingMore;
    }
    notifyListeners();

    params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
    params[ApiAndParams.offset] = offset.toString();

    try {
      Map<String, dynamic> response = {};

      response = await getProductVariantsApi(context: context, params: params);

      if (response[ApiAndParams.status].toString() == "1") {
        productsStockManagement = ProductsStockManagement.fromJson(response);

        totalData = int.parse(productsStockManagement.total.toString());

        if (totalData > 0) {
          productsStockManagementData
              .addAll(productsStockManagement.data ?? []);

          hasMoreData = totalData > productsStockManagementData.length;

          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }
          stockManagementState = StockManagementState.loaded;
          notifyListeners();
        } else {
          stockManagementState = StockManagementState.empty;
          notifyListeners();
        }
      } else {
        message = "Something went wrong";
        showMessage(context, message, MessageType.error);
        stockManagementState = StockManagementState.empty;
        notifyListeners();
      }
    }catch (e) {
      message = e.toString();
      showMessage(context, message, MessageType.error);
      stockManagementState = StockManagementState.error;
      notifyListeners();
    }
  }
}
