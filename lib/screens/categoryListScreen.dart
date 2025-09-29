import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class CategoryListScreen extends StatefulWidget {
  final String? from;

  CategoryListScreen({Key? key, this.from}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //fetch categoryList from api
    Future.delayed(Duration.zero).then((value) {
      Map<String, String> params = {};
      if (context.read<CategoryListProvider>().selectedCategoryIdsList[context
                  .read<CategoryListProvider>()
                  .selectedCategoryIdsList
                  .length -
              1] !=
          "0") {
        params[ApiAndParams.categoryId] =
            context.read<CategoryListProvider>().selectedCategoryIdsList[context
                    .read<CategoryListProvider>()
                    .selectedCategoryIdsList
                    .length -
                1];
      } else {
        params[ApiAndParams.categoryId] = "0";
      }
      //params[ApiAndParams.sellerId] = Constant.session.getData("id");
      params[ApiAndParams.search] = searchController.text.toString();

      context
          .read<CategoryListProvider>()
          .getCategoryApiProvider(context: context, params: params);

      searchController.addListener(() {
        Map<String, String> params = {};
        if (context.read<CategoryListProvider>().selectedCategoryIdsList[context
                    .read<CategoryListProvider>()
                    .selectedCategoryIdsList
                    .length -
                1] !=
            "0") {
          params[ApiAndParams.categoryId] = context
              .read<CategoryListProvider>()
              .selectedCategoryIdsList[context
                  .read<CategoryListProvider>()
                  .selectedCategoryIdsList
                  .length -
              1];
        } else {
          params[ApiAndParams.categoryId] = "0";
        }

        params[ApiAndParams.search] = searchController.text.toString();
        //params[ApiAndParams.sellerId] = Constant.session.getData("id");
        context
            .read<CategoryListProvider>()
            .getCategoryApiProvider(context: context, params: params);
      });
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: titleCategoriesLabel,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: setRefreshIndicator(
        refreshCallback: () {
          Map<String, String> params = {};
          //params[ApiAndParams.sellerId] = Constant.session.getData("id");
          params[ApiAndParams.categoryId] = context
              .read<CategoryListProvider>()
              .selectedCategoryIdsList[context
                  .read<CategoryListProvider>()
                  .selectedCategoryIdsList
                  .length -
              1];

          params[ApiAndParams.search] = searchController.text.toString();
          return context
              .read<CategoryListProvider>()
              .getCategoryApiProvider(context: context, params: params);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                child: editBoxWidget(
                  maxlines: 1,
                  context: context,
                  edtController: searchController,
                  validationFunction: (value)=> optionalFieldValidation("",  ""),
                  label: getTranslatedValue(context, searchLabel),
                  hint: getTranslatedValue(context, searchLabel),
                  bgcolor: Theme.of(context).cardColor,
                  inputType: TextInputType.text,
                  tailIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: ColorsRes.mainTextColor,
                          ),
                        )
                      : null,
                ),
              ),
              subCategorySequenceWidget(),
              categoryWidget(),
            ],
          ),
        ),
      ),
    );
  }

  //categoryList ui
  categoryWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<CategoryListProvider>(
            builder: (context, categoryListProvider, _) {
          return categoryListProvider.categoryState == CategoryState.loaded
              ? Card(
                  color: Theme.of(context).cardColor,
                  surfaceTintColor: ColorsRes.appColorTransparent,
                  elevation: 0,
                  margin: EdgeInsets.symmetric(
                      horizontal: Constant.paddingOrMargin10,
                      vertical: Constant.paddingOrMargin10),
                  child: GridView.builder(
                    itemCount: categoryListProvider.categories.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: Constant.paddingOrMargin10,
                        vertical: Constant.paddingOrMargin10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      CategoryData category =
                          categoryListProvider.categories[index];

                      categoryListProvider.subCategoriesList[
                          categoryListProvider.selectedCategoryIdsList[
                              categoryListProvider
                                      .selectedCategoryIdsList.length -
                                  1]] = categoryListProvider.categories;

                      return CategoryItemContainer(
                          category: category,
                          voidCallBack: () {
                            if (category.hasChild == true) {
                              context
                                  .read<CategoryListProvider>()
                                  .selectedCategoryIdsList
                                  .add(
                                    category.id.toString(),
                                  );
                              context
                                  .read<CategoryListProvider>()
                                  .selectedCategoryNamesList
                                  .add(category.name ?? "");

                              Map<String, String> params = {};
                              // params[ApiAndParams.sellerId] = Constant.session.getData("id");
                              params[ApiAndParams.categoryId] = context
                                  .read<CategoryListProvider>()
                                  .selectedCategoryIdsList[context
                                      .read<CategoryListProvider>()
                                      .selectedCategoryIdsList
                                      .length -
                                  1];

                              params[ApiAndParams.search] =
                                  searchController.text.toString();
                              context
                                  .read<CategoryListProvider>()
                                  .getCategoryApiProvider(
                                      context: context, params: params);

                              setState(() {});
                            } else if (widget.from != null &&
                                widget.from == "product_add") {
                              Navigator.pop(context, category);
                            }
                          });
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.8,
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                  ),
                )
              : categoryListProvider.categoryState == CategoryState.loading
                  ? getCategoryShimmer(context: context, count: 9)
                  : SizedBox.shrink();
        }),
      ],
    );
  }

  //category index widget
  subCategorySequenceWidget() {
    return Consumer<CategoryListProvider>(
        builder: (context, categoryListProvider, _) {
      return categoryListProvider.selectedCategoryIdsList.length > 1
          ? Container(
              margin: EdgeInsets.all(Constant.paddingOrMargin10),
              padding: EdgeInsets.all(Constant.paddingOrMargin10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: 5,
                spacing: 5,
                children: List.generate(
                    categoryListProvider.selectedCategoryIdsList.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      if (categoryListProvider.selectedCategoryIdsList.length !=
                          index) {
                        categoryListProvider.setCategoryData(index);
                      }
                    },
                    child: CustomTextLabel(
                        text:
                            "${categoryListProvider.selectedCategoryNamesList[index]}${categoryListProvider.selectedCategoryNamesList.length == (index + 1) ? "" : " > "}"),
                  );
                }),
              ),
            )
          : SizedBox.shrink();
    });
  }
}