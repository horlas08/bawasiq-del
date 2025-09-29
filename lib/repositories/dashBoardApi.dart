import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getDashboardRepository(
    {required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiDashboard, params: params, isPost: false);

  return json.decode(response);
}
