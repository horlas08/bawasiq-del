import 'package:flutter/material.dart';
import 'package:project/helper/utils/apiAndParams.dart';
import 'package:project/helper/utils/constant.dart';
import 'package:project/helper/utils/generalMethods.dart';
import 'package:project/models/fundTransfer.dart';
import 'package:project/repositories/fundTransferApi.dart';

enum FundTransferState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class FundTransferProvider extends ChangeNotifier {
  FundTransferState fundTransferState = FundTransferState.initial;
  String message = '';
  List<FundTransferData> fundTransfer = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  String cashInHand = '';
  String cashCollected = '';

  /* getFundTransferProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      fundTransferState = FundTransferState.loading;
    } else {
      fundTransferState = FundTransferState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getFundTransfernApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());
        List<FundTransferData> tempWalletHistories = (getData['data'] as List)
            .map((e) => FundTransferData.fromJson(Map.from(e)))
            .toList();

        fundTransfer.addAll(tempWalletHistories);
        hasMoreData = totalData > fundTransfer.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        if (totalData > 0) {
          fundTransferState = FundTransferState.loaded;
          notifyListeners();
        } else {
          fundTransferState = FundTransferState.empty;
          notifyListeners();
        }
      } else {
        fundTransferState = FundTransferState.error;
        notifyListeners();
      }
    }catch (e) {
      message = e.toString();
      fundTransferState = FundTransferState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  } */
 getFundTransferProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    try {
      if (offset == 0) {
        fundTransferState = FundTransferState.loading;
        fundTransfer = []; // Replace instead of clear()
        notifyListeners();
      } else {
        fundTransferState = FundTransferState.loadingMore;
        notifyListeners();
      }

      params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData = (await getFundTransfernApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());
        List<FundTransferData> tempWalletHistories = (getData['data'] as List).map((e) => FundTransferData.fromJson(Map.from(e))).toList();

        if (offset == 0) {
          fundTransfer = tempWalletHistories; // Replace for new search
        } else {
          fundTransfer.addAll(tempWalletHistories); // Append for pagination
        }

        hasMoreData = totalData > fundTransfer.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        fundTransferState = totalData > 0 ? FundTransferState.loaded : FundTransferState.empty;
        notifyListeners();
      } else {
        fundTransferState = FundTransferState.error;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      message = e.toString();
      fundTransferState = FundTransferState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }
}
