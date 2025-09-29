import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

Future updateUserApiRepository({
  required Map<String, dynamic> params,
  required String from,
  required Map<String, File> filesMap,
}) async {
  try {
    var apiName = from.isEmpty
        ? "${Constant.hostUrl}api/${Constant.session.isSeller() ? "sellers" : "delivery_boys"}/${ApiAndParams.apiUpdateUser}"
        : ApiAndParams.apiRegisterUser;

    if (filesMap.isEmpty) {
      return jsonDecode(await sendApiRequest(
        apiName: apiName,
        params: params,
        isPost: true,
      ));
    } else {
      return await sendApiMultiPartRequest(
        apiName: apiName,
        params: params,
        filesMap: filesMap,
      );
    }
  } catch (e) {
    print(">>>>> ${e.toString()}");
    rethrow;
  }
}

Future<Map<String, dynamic>> getLoginRepository({required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiLogin,
    params: params,
    isPost: true,
  );

  return json.decode(response);
}

Future<Map<String, dynamic>> getProfileApi({required BuildContext context, required String id}) async {
  var response = await sendApiRequest(
    apiName: "${Constant.hostUrl}api/${Constant.session.isSeller() ? "sellers" : "delivery_boys"}/${ApiAndParams.apiEditProfile}/$id",
    params: {},
    isPost: false,
  );

  return await json.decode(response);
}

Future<Map<String, dynamic>> deleteUserAccount({required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: Constant.session.isSeller() ? ApiAndParams.apiSellerDeleteAccount : ApiAndParams.apiDeliveryBoyDeleteAccount,
    params: params,
    isPost: false,
  );

  return json.decode(response);
}

Future<Map<String, dynamic>> updateSellerStatus({required BuildContext context, required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiUpdateSellerStatus,
    params: params,
    isPost: true,
  );

  return json.decode(response);
}

Future<Map<String, dynamic>> getSellerStatus({required BuildContext context}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiGetSellerStatus,
    params: {},
    isPost: true,
  );

  return json.decode(response);
}
