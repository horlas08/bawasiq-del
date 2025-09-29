import 'package:flutter/material.dart';
import 'package:project/helper/utils/apiAndParams.dart';
import 'package:project/helper/utils/constant.dart';
import 'package:project/helper/utils/generalMethods.dart';
import 'package:project/models/cashCollection.dart';
import 'package:project/repositories/cashCollectionApi.dart';

enum CashCollectionState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class CashCollectionProvider extends ChangeNotifier {
  CashCollectionState cashCollectionState = CashCollectionState.initial;
  String message = '';
  List<CashCollectionData> cashCollection = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  String cashInHand = '';
  String cashCollected = '';

  /* getCashCollectionProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      cashCollectionState = CashCollectionState.loading;
    } else {
      cashCollectionState = CashCollectionState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getCashCollectionApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());
        List<CashCollectionData> tempWalletHistories = (getData['data']['transactions'] as List)
            .map((e) => CashCollectionData.fromJson(Map.from(e)))
            .toList();

        cashInHand = getData['data']['cash_in_hand'].toString();
        cashCollected = getData['data']['cash_collected'].toString();

        cashCollection.addAll(tempWalletHistories);
        hasMoreData = totalData > cashCollection.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        if (totalData > 0) {
          cashCollectionState = CashCollectionState.loaded;
          notifyListeners();
        } else {
          cashCollectionState = CashCollectionState.empty;
          notifyListeners();
        }
      } else {
        cashCollectionState = CashCollectionState.error;
        notifyListeners();
      }
    }catch (e) {
      message = e.toString();
      cashCollectionState = CashCollectionState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  } */
 getCashCollectionProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    try {
      if (offset == 0) {
        cashCollectionState = CashCollectionState.loading;
        cashCollection = []; // Replace instead of clear
        notifyListeners();
      } else {
        cashCollectionState = CashCollectionState.loadingMore;
        notifyListeners();
      }

      params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData = (await getCashCollectionApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());
        List<CashCollectionData> tempCollections =
            (getData['data']['transactions'] as List).map((e) => CashCollectionData.fromJson(Map.from(e))).toList();

        cashInHand = getData['data']['cash_in_hand'].toString();
        cashCollected = getData['data']['cash_collected'].toString();

        if (offset == 0) {
          cashCollection = tempCollections; // Replace for new search
        } else {
          cashCollection.addAll(tempCollections); // Append for pagination
        }

        hasMoreData = totalData > cashCollection.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        cashCollectionState = totalData > 0 ? CashCollectionState.loaded : CashCollectionState.empty;
      } else {
        cashCollectionState = CashCollectionState.error;
      }
      notifyListeners();
    } catch (e) {
      message = e.toString();
      cashCollectionState = CashCollectionState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }
}
