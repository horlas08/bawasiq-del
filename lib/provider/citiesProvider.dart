import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/cities.dart';
import 'package:project/repositories/citiesApi.dart';

enum CityState {
  initial,
  loading,
  loadingMore,
  loaded,
  error,
}

class CityProvider extends ChangeNotifier {
  String message = '';
  CityState cityState = CityState.initial;
  late City city;

  List<Cities> cities = [];

  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getCity({required BuildContext context}) async {
    try {
      if (cities.length > 0) {
        cityState = CityState.loadingMore;
        notifyListeners();
      } else {
        cityState = CityState.loading;
        notifyListeners();
      }

      Map<String, String> params = {};
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getCitiesApi(params: params, context: context));

      if (getData[ApiAndParams.status].toString() == "1") {
        city = City.fromJson(getData);

        totalData = int.parse(city.total.toString());

        List<Cities> tempCityList = city.data?.cities ?? [];

        cities.addAll(tempCityList);

        hasMoreData = totalData > cities.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        cityState = CityState.loaded;
        notifyListeners();
      } else {
        cityState = CityState.error;
        notifyListeners();
        showMessage(
            context, getData[ApiAndParams.message], MessageType.warning);
      }
    }catch (e) {
      message = e.toString();
      cityState = CityState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }
}
