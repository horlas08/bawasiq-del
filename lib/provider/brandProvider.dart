import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/brand.dart';
import 'package:project/repositories/brandApi.dart';

enum BrandState {
  initial,
  loading,
  loadingMore,
  loaded,
  error,
}

class BrandProvider extends ChangeNotifier {
  String message = '';
  BrandState brandState = BrandState.initial;
  late Brand brand;
  List<BrandData> brands = [];

  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getBrand({
    required BuildContext context,
  }) async {
    try {
      if (brands.length > 0) {
        brandState = BrandState.loadingMore;
        notifyListeners();
      } else {
        brandState = BrandState.loading;
        notifyListeners();
      }

      Map<String, String> params = {};
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getBrandApi(params: params, context: context));

      if (getData[ApiAndParams.status].toString() == "1") {
        brand = Brand.fromJson(getData);
        List<BrandData> tempBrands = brand.data ?? [];

        totalData = int.parse(brand.total.toString());
        brands.addAll(tempBrands);

        hasMoreData = totalData > brands.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        brandState = BrandState.loaded;
        notifyListeners();
      } else {
        brandState = BrandState.error;
        notifyListeners();
        showMessage(context, getData[ApiAndParams.message], MessageType.error);
      }
    }catch (e) {
      message = e.toString();
      brandState = BrandState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }
}
