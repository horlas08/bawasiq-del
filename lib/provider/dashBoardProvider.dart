import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/sellerDashBoard.dart';

enum DashboardState { initial, loading, loaded, error }

class DashboardProvider extends ChangeNotifier {
  DashboardState dashboardState = DashboardState.initial;
  late SellerDashBoard sellerDashBoard;
  late DeliveryBoyDashBoard deliveryBashBoard;
  double maxSaleLimit = 0.0;

  Future dashboardApiProvider(
      Map<String, String> params, BuildContext context) async {
    try {
      dashboardState = DashboardState.loading;
      notifyListeners();

      Map<String, dynamic> dashboardApiResponse =
          await getDashboardRepository(params: params);

      if (dashboardApiResponse[ApiAndParams.status].toString() == "1") {
        if (Constant.session.isSeller()) {
          sellerDashBoard = SellerDashBoard.fromJson(dashboardApiResponse);
          for (int i = 0; i < sellerDashBoard.data!.weeklySales!.length; i++) {
            WeeklySales weeklySale = sellerDashBoard.data!.weeklySales![i];
            if (i == 0) {
              maxSaleLimit = double.parse(weeklySale.totalSale!);
            } else if (maxSaleLimit.ceil() >
                double.parse(weeklySale.totalSale!).ceil()) {
              maxSaleLimit = double.parse(weeklySale.totalSale!);
            }
          }
          dashboardState = DashboardState.loaded;
          notifyListeners();
          return sellerDashBoard;
        } else {
          deliveryBashBoard =
              DeliveryBoyDashBoard.fromJson(dashboardApiResponse);
          dashboardState = DashboardState.loaded;
          notifyListeners();
          return deliveryBashBoard;
        }
      } else {
        showMessage(context, dashboardApiResponse[ApiAndParams.message],
            MessageType.warning);
        dashboardState = DashboardState.error;
        notifyListeners();
      }
    }catch (e) {
      showMessage(context, e.toString(), MessageType.error);
      dashboardState = DashboardState.error;
      notifyListeners();
    }
  }
}
