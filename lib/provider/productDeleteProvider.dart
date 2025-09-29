import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/addProductApi.dart';

enum SellerDeleteProductState {
  initial,
  loading,
  loaded,
  error,
}

class DeleteProductProvider extends ChangeNotifier {
  SellerDeleteProductState sellerProductDeleteState =
      SellerDeleteProductState.initial;
  String message = '';

  Future deleteProducts({
    required Map<String, String> params,
    required BuildContext context,
    required from,
  }) async {
    try {
      var getResult = await deleteProductApi(
        context: context,
        params: params,
      );
      if (from == "update_product") {
        showMessage(
            context, getResult[ApiAndParams.message], MessageType.warning);
      }

      if (getResult[ApiAndParams.status].toString() == "1") {
        sellerProductDeleteState = SellerDeleteProductState.loaded;
        notifyListeners();
        return true;
      } else {
        sellerProductDeleteState = SellerDeleteProductState.error;
        notifyListeners();
        return null;
      }
    }catch (e) {
      message = e.toString();
      sellerProductDeleteState = SellerDeleteProductState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return null;
    }
  }
}
