import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getCitiesApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiCities,
    params: params,
    isPost: false,
  );

  return json.decode(response);
}
