import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getBrandApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiBrands,
    params: params,
    isPost: false,
  );

  Map<String, dynamic> mainData = await json.decode(response);

  return mainData;
}
