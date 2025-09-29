import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

/* Future addOrUpdateProductApi(
    {required Map<String, String> params,
    required Map<String, File> filesMap,
    required BuildContext context,
    required bool isAdd,
    File? mainImage,
    List<File>? otherImage}) async {
  try {
    // var response = {};

    if (filesMap.isNotEmpty) {
      return json.decode(await sendApiMultiPartRequest(
        apiName: isAdd ? ApiAndParams.apiAddProduct : ApiAndParams.apiUpdateProduct,
        params: params,
        filesMap: filesMap,
      ));
    } else {
      return json.decode(await sendApiRequest(
        apiName: isAdd ? ApiAndParams.apiAddProduct : ApiAndParams.apiUpdateProduct,
        params: params,
        isPost: true,
      ));
    }

    // return response;
  } catch (e) {
    print("getResult:$e");
    rethrow;
  }
} */
Future<dynamic> addOrUpdateProductApi({
  required Map<String, String> params,
  required Map<String, File> filesMap,
  required BuildContext context,
  required bool isAdd,
  File? mainImage,
  List<File>? otherImage,
}) async {
  try {
    dynamic response;

    if (filesMap.isNotEmpty) {
      response = await sendApiMultiPartRequest(
        apiName: isAdd ? ApiAndParams.apiAddProduct : ApiAndParams.apiUpdateProduct,
        params: params,
        filesMap: filesMap,
      );
    } else {
      response = await sendApiRequest(
        apiName: isAdd ? ApiAndParams.apiAddProduct : ApiAndParams.apiUpdateProduct,
        params: params,
        isPost: true,
      );
    }

    // Decode only if it's a String
    if (response is String) {
      return json.decode(response);
    } else if (response is Map) {
      return response; // Already decoded
    } else {
      throw Exception("Unsupported response type: ${response.runtimeType}");
    }
  } catch (e) {
    print("getResult: $e");
    rethrow;
  }
}


Future deleteProductApi({
  required Map<String, String> params,
  required BuildContext context,
}) async {
  try {
    var response = await sendApiRequest(
      apiName: ApiAndParams.apiDeleteProduct,
      params: params,
      isPost: true,
    );

    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}

Future getProductById({
  required Map<String, String> params,
  required BuildContext context,
}) async {
  try {
    var response = await sendApiRequest(
      apiName: ApiAndParams.apiGetProductProductById,
      params: params,
      isPost: false,
    );

    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}

Future getTagsApi({
  required Map<String, String> params,
  required BuildContext context,
}) async {
  try {
    var response = await sendApiRequest(
      apiName: ApiAndParams.apiGetTags,
      params: params,
      isPost: false,
    );

    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
