import 'package:project/helper/utils/generalImports.dart';

Future/* <Map<String, dynamic>> */ getAppSettingsRepository(
    {required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiAppSettings, params: params, isPost: false);

  return json.decode(response);
}
