import 'package:flutter/material.dart';
import 'package:project/helper/utils/apiAndParams.dart';
import 'package:project/helper/utils/constant.dart';
import 'package:project/helper/utils/generalMethods.dart';
import 'package:project/models/walletHistory.dart';
import 'package:project/repositories/walletHistoryApi.dart';

enum WalletHistoryState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class WalletHistoryProvider extends ChangeNotifier {
  WalletHistoryState walletHistoryState = WalletHistoryState.initial;
  String message = '';
  late WalletHistory walletHistoryData;
  List<WalletHistoryData> walletHistories = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getWalletHistoryProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      walletHistoryState = WalletHistoryState.loading;
    } else {
      walletHistoryState = WalletHistoryState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getWalletHistoryApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());
        List<WalletHistoryData> tempWalletHistories = (getData['data'] as List)
            .map((e) => WalletHistoryData.fromJson(Map.from(e)))
            .toList();

        walletHistories.addAll(tempWalletHistories);
        hasMoreData = totalData > walletHistories.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        if (totalData > 0) {
          walletHistoryState = WalletHistoryState.loaded;
          notifyListeners();
        } else {
          walletHistoryState = WalletHistoryState.empty;
          notifyListeners();
        }
      } else {
        walletHistoryState = WalletHistoryState.error;
        notifyListeners();
      }
    }catch (e) {
      message = e.toString();
      walletHistoryState = WalletHistoryState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }
}
