import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/productDetail.dart';
import 'package:project/repositories/addProductApi.dart';

enum SellerAddUpdateProductState {
  initial,
  loading,
  loaded,
  error,
}

enum SellerGetProductByIdState {
  initial,
  loading,
  loaded,
  error,
}

enum TagsState {
  initial,
  loading,
  loaded,
  error,
}

class AddUpdateProductProvider extends ChangeNotifier {
  SellerAddUpdateProductState sellerAddUpdateProductState = SellerAddUpdateProductState.loading;

  TagsState tagsState = TagsState.loading;
  late Tags tags;
  late List<TagsData> tagsData;
  SellerGetProductByIdState sellerGetProductByIdState = SellerGetProductByIdState.loading;
  String message = '';
  late ProductDetail productDetail;

  Future addOrUpdateProducts(
      {required Map<String, String> params,
      required Map<String, File> filesMap,
      required BuildContext context,
      required bool isAdd,
      File? mainImage,
      List<File>? otherImage}) async {
    try {
      sellerAddUpdateProductState = SellerAddUpdateProductState.loading;
      notifyListeners();
      var getResult = await addOrUpdateProductApi(
        context: context,
        isAdd: isAdd,
        params: params,
        filesMap: filesMap,
      );

      Map<String, dynamic> responseMap = getResult;

      if (responseMap[ApiAndParams.status].toString() == "1") {
        showMessage(context, responseMap[ApiAndParams.message], MessageType.success);
        sellerAddUpdateProductState = SellerAddUpdateProductState.loaded;
        notifyListeners();
        return true;
      } else {
        showMessage(context, responseMap[ApiAndParams.message], MessageType.warning);
        sellerAddUpdateProductState = SellerAddUpdateProductState.error;
        notifyListeners();
        return null;
      }
    }catch (e) {
      print("response:$e");
      message = e.toString();

      sellerAddUpdateProductState = SellerAddUpdateProductState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return null;
    }
  }

  Future productById({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    try {
      sellerGetProductByIdState = SellerGetProductByIdState.loading;
      notifyListeners();

      var getResult = await getProductById(
        context: context,
        params: params,
      );

      if (getResult[ApiAndParams.status].toString() == "1") {
        productDetail = ProductDetail.fromJson(getResult);

        sellerGetProductByIdState = SellerGetProductByIdState.loaded;
        notifyListeners();
        return productDetail;
      } else {
        sellerGetProductByIdState = SellerGetProductByIdState.error;
        notifyListeners();
        showMessage(context, getResult[ApiAndParams.message], MessageType.error);
        return null;
      }
    }catch (e) {
      message = e.toString();

      sellerGetProductByIdState = SellerGetProductByIdState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return null;
    }
  }

  updateProductDataLoadingState() {
    sellerGetProductByIdState = SellerGetProductByIdState.loaded;
    notifyListeners();
  }
}
