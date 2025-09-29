import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/tax.dart';
import 'package:project/repositories/taxApi.dart';

enum TaxesState {
  initial,
  loading,
  loaded,
  error,
}

class TaxProvider extends ChangeNotifier {
  String message = '';
  TaxesState taxesState = TaxesState.initial;
  late Tax tax;

  getTaxes({
    required BuildContext context,
  }) async {
    taxesState = TaxesState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getData =
          (await getTaxApi(params: {}, context: context));

      if (getData[ApiAndParams.status].toString() == "1") {
        tax = Tax.fromJson(getData);

        taxesState = TaxesState.loaded;
        notifyListeners();
      } else {
        taxesState = TaxesState.error;
        notifyListeners();
        showMessage(
            context, getData[ApiAndParams.message], MessageType.warning);
      }
    }catch (e) {
      message = e.toString();
      taxesState = TaxesState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }
}
