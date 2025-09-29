import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

Future getRatingsList(
    {required BuildContext context,
    required Map<String, String> params}) async {
  try {
    var response = await sendApiRequest(
      apiName: ApiAndParams.apiProductsRatings,
      params: params,
      isPost: false,
    );
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
