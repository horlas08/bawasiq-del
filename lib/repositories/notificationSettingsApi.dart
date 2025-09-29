import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getNotificationSettingsRepository(
    {required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiNotificationSettings,
      params: params,
      isPost: false);

  return json.decode(response);
}

Future<Map<String, dynamic>> updateNotificationSettingsRepository(
    {required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiNotificationSettingsUpdate,
      params: params,
      isPost: true);

  return json.decode(response);
}
