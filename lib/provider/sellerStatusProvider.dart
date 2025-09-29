import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

enum SellerState {
  initial,
  loading,
  loaded,
  error,
}

class SellerStatusProvider extends ChangeNotifier {
  String message = '';
  SellerState sellerState = SellerState.initial;
  int selectedIndex = 0;

  getSellerStatusProvider({
    required BuildContext context,
  }) async {
    sellerState = SellerState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getData = (await getSellerStatus(context: context));

      if (getData[ApiAndParams.status].toString() == "1") {
        Map<String, dynamic> statusData = getData[ApiAndParams.data];

        selectedIndex =
            statusData[ApiAndParams.status].toString() == "1" ? 0 : 1;

        sellerState = SellerState.loaded;
        notifyListeners();
      } else {
        sellerState = SellerState.error;
        notifyListeners();
        showMessage(
            context, getData[ApiAndParams.message], MessageType.warning);
      }
    }catch (e) {
      message = e.toString();
      sellerState = SellerState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }

  updateSellerStatusProvider({
    required BuildContext context,
    required Map<String, String> params,
  }) async {
    try {
      sellerState = SellerState.loading;
      notifyListeners();

      Map<String, dynamic> getData =
          await updateSellerStatus(context: context, params: params);

      if (getData[ApiAndParams.status].toString() == "1") {
        getSellerStatusProvider(context: context);
        showMessage(
          context,
          getTranslatedValue(
              context,
              selectedIndex == 1
                  ? sellerActivatedMessageLabel
                  : sellerInactiveMessageLabel),
          MessageType.success,
        );

        sellerState = SellerState.loaded;
        notifyListeners();
      } else {
        sellerState = SellerState.error;
        notifyListeners();
        showMessage(
            context, getData[ApiAndParams.message], MessageType.warning);
        return false;
      }
    }catch (e) {
      message = e.toString();
      sellerState = SellerState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return false;
    }
  }
}
