import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class BottomSheetMultipleCategorySelectionWidget extends StatefulWidget {
  BottomSheetMultipleCategorySelectionWidget({
    super.key,
  });

  @override
  State<BottomSheetMultipleCategorySelectionWidget> createState() =>
      _BottomSheetMultipleCategorySelectionWidgetState();
}

class _BottomSheetMultipleCategorySelectionWidgetState
    extends State<BottomSheetMultipleCategorySelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
              start: Constant.paddingOrMargin10,
              end: Constant.paddingOrMargin10),
          child: CustomTextLabel(
            jsonKey: selectCategoriesLabel,
            softWrap: true,
            style: TextStyle(fontSize: 20, color: ColorsRes.mainTextColor),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsetsDirectional.only(
                  start: Constant.paddingOrMargin10,
                  end: Constant.paddingOrMargin10,
                  top: Constant.paddingOrMargin10,
                  bottom: Constant.paddingOrMargin10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<CategoryListProvider>(
                    builder: (context, categoryListProvider, _) {
                      if (!categoryListProvider.startedApiCalling) {
                        categoryListProvider.categoryState =
                            CategoryState.loading;
                        categoryListProvider
                            .getCategoryApiProviderForRegistration(
                                context: context);
                        categoryListProvider.startedApiCalling =
                            !categoryListProvider.startedApiCalling;
                      }
                      return categoryListProvider.categoryState ==
                              CategoryState.loaded
                          ? GridView.builder(
                              itemCount: categoryListProvider.categories.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                CategoryData category =
                                    categoryListProvider.categories[index];

                                categoryListProvider.subCategoriesList[
                                        categoryListProvider
                                                .selectedCategoryIdsList[
                                            categoryListProvider
                                                    .selectedCategoryIdsList
                                                    .length -
                                                1]] =
                                    categoryListProvider.categories;

                                return CategoryItemContainer(
                                  category: category,
                                  voidCallBack: () {
                                    categoryListProvider
                                        .addOrRemoveCategoryFromSelection(
                                            category.id.toString(),
                                            category.name.toString());
                                  },
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.8,
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                            )
                          : categoryListProvider.categoryState ==
                                  CategoryState.loading
                              ? getCategoryShimmer(
                                  context: context,
                                  count: 24,
                                  padding: EdgeInsets.zero,
                                )
                              : SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer<CategoryListProvider>(
          builder: (context, categoryListProvider, child) {
            return Padding(
              padding: EdgeInsetsDirectional.only(start: 10, end: 10),
              child: gradientBtnWidget(
                context,
                10,
                title: getTranslatedValue(context, doneLabel),
                callback: () {
                  Navigator.pop(context, {
                    "ids": categoryListProvider.selectedCategories
                        .toString()
                        .replaceAll("]", "")
                        .replaceAll(" ", "")
                        .replaceAll("[", ""),
                    "names": categoryListProvider.selectedCategoriesNames
                        .toString()
                        .replaceAll("]", "")
                        .replaceAll(" ", "")
                        .replaceAll("[", "")
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }
}