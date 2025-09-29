import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/liveOrderTrackingApi.dart';

enum LiveOrderTrackingState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class LiveOrderTrackingProvider extends ChangeNotifier {
  LiveOrderTrackingState liveOrderTrackingState =
      LiveOrderTrackingState.initial;
  String message = '';

  double deliveryBoyLatitude = 0;
  double deliveryBoyLongitude = 0;

  Future updateDeliveryBoyLatLongProvider(
      {required Map<String, String> params,
      required BuildContext context}) async {
    if (deliveryBoyLatitude == 0 && deliveryBoyLongitude == 0) {
      liveOrderTrackingState = LiveOrderTrackingState.loading;
      notifyListeners();
    }

    try {
      Map<String, dynamic> data =
          await updateDeliveryBoyLatLongApi(params: params);
      if (data[ApiAndParams.status].toString() == "1") {
        deliveryBoyLatitude =
            params[ApiAndParams.latitude].toString().toDouble ?? 0.0;
        deliveryBoyLongitude =
            params[ApiAndParams.longitude].toString().toDouble ?? 0.0;

        liveOrderTrackingState = LiveOrderTrackingState.loaded;
        notifyListeners();
      } else {
        liveOrderTrackingState = LiveOrderTrackingState.error;
        notifyListeners();
      }
    }catch (e) {
      message = e.toString();
      liveOrderTrackingState = LiveOrderTrackingState.error;
      notifyListeners();
    }
  }
}
