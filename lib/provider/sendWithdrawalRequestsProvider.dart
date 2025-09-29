import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/withdrawalRequestsApi.dart';

enum SendWithdrawalRequestsState {
  initial,
  loading,
  loaded,
  error,
}

class SendWithdrawalRequestsProvider extends ChangeNotifier {
  SendWithdrawalRequestsState sendWithdrawalRequestsState =
      SendWithdrawalRequestsState.initial;
  String message = '';
  bool sendingRequest = false;

  Future sendWithdrawalRequestProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    sendWithdrawalRequestsState = SendWithdrawalRequestsState.loading;
    sendingRequest = true;
    notifyListeners();

    try {
      Map<String, dynamic> getData =
          (await sendWithdrawalRequestsApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        sendWithdrawalRequestsState = SendWithdrawalRequestsState.loaded;
        notifyListeners();
        return true;
      } else {
        sendWithdrawalRequestsState = SendWithdrawalRequestsState.error;
        notifyListeners();
        return false;
      }
    }catch (e) {
      message = e.toString();
      sendWithdrawalRequestsState = SendWithdrawalRequestsState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return false;
    }
  }
}
