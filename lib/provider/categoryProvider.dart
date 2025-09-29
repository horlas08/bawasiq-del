import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

enum CategoryState {
  initial,
  loading,
  loaded,
  error,
}

class CategoryListProvider extends ChangeNotifier {
  CategoryState categoryState = CategoryState.initial;
  String message = '';
  List<CategoryData> categories = [];
  Map<String, List<CategoryData>> subCategoriesList = {};
  List<String> selectedCategoryIdsList = ["0"];
  List<String> selectedCategoryNamesList = ["All"];
  String currentSelectedCategoryId = "0";
  bool startedApiCalling = false;
  List<String> selectedCategories = [];
  List<String> selectedCategoriesNames = [];

  getCategoryApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    categoryState = CategoryState.loading;
    notifyListeners();
    try {
      var getCategoryData = await getCategoryListRepository(params: params);

      if (getCategoryData[ApiAndParams.status].toString() == "1") {
        Category category = Category.fromJson(getCategoryData);
        categories = category.data ?? [];

        categoryState = CategoryState.loaded;
        notifyListeners();
      } else {
        categoryState = CategoryState.error;
        showMessage(
            context, getCategoryData[ApiAndParams.message], MessageType.error);
        notifyListeners();
      }
    }catch (e) {
      message = e.toString();
      categoryState = CategoryState.error;
      notifyListeners();
    }
  }

  setCategoryList(List<CategoryData> categoriesList) {
    categories = categoriesList;
    notifyListeners();
  }

  setCategoryData(int index) {
    currentSelectedCategoryId = selectedCategoryIdsList[index];
    setCategoryList(subCategoriesList["$index"] as List<CategoryData>);

    if (index == 0) {
      selectedCategoryIdsList.clear();
      selectedCategoryNamesList.clear();
      selectedCategoryIdsList = ["0"];
      selectedCategoryNamesList = ["All"];
      currentSelectedCategoryId = "0";
    } else {
      selectedCategoryIdsList.removeRange(
          index, selectedCategoryIdsList.length - 1);
      selectedCategoryNamesList.removeRange(
          index, selectedCategoryNamesList.length - 1);
    }

    notifyListeners();
  }

  getCategoryApiProviderForRegistration({required BuildContext context}) async {
    try {
      var getCategoryData = await getMainCategoryListRepository();
      if (getCategoryData[ApiAndParams.status].toString() == "1") {
        Category category = Category.fromJson(getCategoryData);
        categories = category.data ?? [];
        categoryState = CategoryState.loaded;
        notifyListeners();
      } else {
        categoryState = CategoryState.error;
        Navigator.pop(context);
        showMessage(context, getCategoryData[ApiAndParams.message],
            MessageType.warning);
        notifyListeners();
      }
    }catch (e) {
      message = e.toString();
      Navigator.pop(context);
      categoryState = CategoryState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
    }
  }

  addOrRemoveCategoryFromSelection(String id, String name) {
    if (selectedCategories.contains(id)) {
      selectedCategories.remove(id);
      selectedCategoriesNames.remove(name);
    } else {
      selectedCategories.add(id);
      selectedCategoriesNames.add(name);
    }
    notifyListeners();
  }
}
