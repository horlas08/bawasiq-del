import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getOrderDetailRepository(
    {required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiOrderById, params: params, isPost: false);

  return json.decode(response);
}
