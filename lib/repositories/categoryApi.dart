import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getCategoryListRepository(
    {required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: /* ApiAndParams.apiMainCategories */ ApiAndParams.apiSellerCategoriesList, params: params, isPost: false);

  return json.decode(response);
}

Future<Map<String, dynamic>> getMainCategoryListRepository() async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiCategories,
      params: {ApiAndParams.sellerId: Constant.session.getData("id")},
      isPost: false);

  return json.decode(response);
}
