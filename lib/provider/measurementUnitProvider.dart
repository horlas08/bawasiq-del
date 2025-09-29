import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/measurementUnit.dart';
import 'package:project/repositories/measurementUnitApi.dart';

enum MeasurementUnitsState {
  initial,
  loading,
  loadingMore,
  loaded,
  error,
}

class MeasurementUnitsProvider extends ChangeNotifier {
  String message = '';
  MeasurementUnitsState measurementUnitState = MeasurementUnitsState.initial;
  late Units units;
  List<MeasurementUnitData> measurementUnits = [];

  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getMeasurementUnits({
    required BuildContext context,
  }) async {
    try {
      if (measurementUnits.length > 0) {
        measurementUnitState = MeasurementUnitsState.loadingMore;
        notifyListeners();
      } else {
        measurementUnitState = MeasurementUnitsState.loading;
        notifyListeners();
      }

      Map<String, String> params = {};
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getUnitsApi(params: params, context: context));

      if (getData[ApiAndParams.status].toString() == "1") {
        units = Units.fromJson(getData);
        List<MeasurementUnitData> tempMeasurementUnits = units.data ?? [];

        totalData = int.parse(units.total.toString());
        measurementUnits.addAll(tempMeasurementUnits);

        hasMoreData = totalData > measurementUnits.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        measurementUnitState = MeasurementUnitsState.loaded;
        notifyListeners();
      } else {
        measurementUnitState = MeasurementUnitsState.error;
        notifyListeners();
        showMessage(
            context, getData[ApiAndParams.message], MessageType.warning);
      }
    }catch (e) {
      message = e.toString();
      measurementUnitState = MeasurementUnitsState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }
}
