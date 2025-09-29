import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

Future productBulkOperationApi({
  required Map<String, File> filesMap,
  required BuildContext context,
  required bool isUpload,
}) async {
  try {
    var response = await sendApiMultiPartRequest(
        apiName: isUpload == true ? ApiAndParams.apiProductBulkUpload : ApiAndParams.apiProductBulkUpdate, params: {}, filesMap: filesMap);

    return /* json.decode( */response/* ) */;
  } catch (e) {
    rethrow;
  }
}

Future productDownloadProductDataExcelApi({required String from}) async {
  var response = await sendApiRequest(
      apiName: from == "upload" ? ApiAndParams.apiDownloadSampleProductFile : ApiAndParams.apiDownloadProductDataExcel,
      params: {},
      isPost: false,
      isRequestedForInvoice: true);

  return await response;
}
