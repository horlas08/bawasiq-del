import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/filterProducts.dart';
import 'package:project/models/productList.dart';

enum ProductState {
  initial,
  loaded,
  loading,
  loadingMore,
  empty,
  error,
}

class ProductListProvider extends ChangeNotifier {
  ProductState productState = ProductState.initial;
  String message = '';
  late ProductList productList;
  List<ProductListItem> products = [];
  late FilterProducts filterProduct;
  List<FilterProductsDataProducts> filterProductsData = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getProductListProvider(
      {required Map<String, dynamic> params,
      required BuildContext context}) async {
    if (offset == 0) {
      productState = ProductState.loading;
    } else {
      productState = ProductState.loadingMore;
    }
    notifyListeners();

    params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
    params[ApiAndParams.offset] = offset.toString();

    try {
      Map<String, dynamic> response = {};
      if (params[ApiAndParams.type] == "all") {
        response = await getProductListApi(context: context, params: params);

        if (response[ApiAndParams.status].toString() == "1") {
          productList = ProductList.fromJson(response);

          totalData = int.parse(productList.total.toString());

          if (totalData > 0) {
            products.addAll(productList.data ?? []);

            hasMoreData = totalData > products.length;

            if (hasMoreData) {
              offset += Constant.defaultDataLoadLimitAtOnce;
            }
            productState = ProductState.loaded;
            notifyListeners();
          } else {
            productState = ProductState.empty;
            notifyListeners();
          }
        }
      } else {
        response =
            await getProductFilterByListApi(context: context, params: params);

        if (response[ApiAndParams.status].toString() == "1") {
          filterProduct = FilterProducts.fromJson(response);

          totalData = int.parse(filterProduct.total.toString());

          if (totalData > 0) {
            filterProductsData.addAll(filterProduct.data?.products ?? []);

            hasMoreData = totalData > filterProductsData.length;

            if (hasMoreData) {
              offset += Constant.defaultDataLoadLimitAtOnce;
            }
            productState = ProductState.loaded;
            notifyListeners();
          } else {
            productState = ProductState.empty;
            notifyListeners();
          }
        } else {
          message = "Something went wrong";
          showMessage(context, message, MessageType.error);
          productState = ProductState.empty;
          notifyListeners();
        }
      }
    }catch (e) {
      message = e.toString();
      showMessage(context, message, MessageType.error);
      productState = ProductState.error;
      notifyListeners();
    }
  }
}
