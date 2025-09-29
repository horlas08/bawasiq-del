import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/productBulkOperationsApi.dart';

enum ProductBulkOperationsState {
  initial,
  loading,
  loaded,
  error,
}

enum ProductSampleFileState {
  initial,
  loading,
  loaded,
  error,
}

class ProductBulkOperationsProvider extends ChangeNotifier {
  ProductBulkOperationsState productBulkOperationsState = ProductBulkOperationsState.initial;

  ProductSampleFileState productSampleFileState = ProductSampleFileState.initial;

  String message = '';
  late Uint8List sampleFileData;

  Future<Uint8List?> getProductDownloadExcel({required BuildContext context, required String from}) async {
    productSampleFileState = ProductSampleFileState.loading;
    notifyListeners();

    try {
      sampleFileData = await productDownloadProductDataExcelApi(from: from);

      productSampleFileState = ProductSampleFileState.loaded;
      notifyListeners();

      return sampleFileData;
    }catch (e) {
      message = e.toString();
      productSampleFileState = ProductSampleFileState.error;
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
      return null;
    }
  }

  Future productBulkOperation({
    required BuildContext context,
    required String fileParamsFilesPath,
    required bool isUpload,
  }) async {
    try {
      productBulkOperationsState = ProductBulkOperationsState.loading;
      notifyListeners();

      /* Map<String, dynamic> */dynamic bulkUploadData = await productBulkOperationApi(
        context: context,
        isUpload: isUpload,
        filesMap: {
          ApiAndParams.file: File(fileParamsFilesPath),
        },
      );

      if (bulkUploadData[ApiAndParams.status].toString() == "1") {
        productBulkOperationsState = ProductBulkOperationsState.loaded;
        notifyListeners();
        return true;
      } else {
        productBulkOperationsState = ProductBulkOperationsState.error;
        // showMessage(context, bulkUploadData[ApiAndParams.message], MessageType.warning);
        notifyListeners();
        return false;
      }
    }catch (e) {
      message = e.toString();
      productBulkOperationsState = ProductBulkOperationsState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return false;
    }
  }
}
