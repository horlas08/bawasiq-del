import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> updateDeliveryBoyLatLongApi(
    {required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiManageDeliveryBoysLatLong,
    params: params,
    isPost: true,
  );

  return json.decode(response);
}
