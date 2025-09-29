import 'package:flutter/material.dart';
import 'package:project/helper/generalWidgets/productFilterListItemContainer.dart';
import 'package:project/helper/generalWidgets/productListItemContainer.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/filterProducts.dart';
import 'package:project/models/productList.dart';
import 'package:project/provider/productDeleteProvider.dart';
import 'package:project/provider/selectedVariantItemProvider.dart';

class ProductListScreen extends StatefulWidget {
  late final int currentFilterIndex;

  ProductListScreen({
    Key? key,
    required this.currentFilterIndex,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int currentAppliedFilter = 0;
  List lblSortingDisplayList = [
    "all_products",
    "low_stock_products",
    "sold_out_products",
    "packets_products",
    "loose_products",
  ];

  static List<String> productListSortTypes = [
    "all",
    "low_stock",
    "sold_out",
    "packet_products",
    "loose_products",
  ];

  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductListProvider>().hasMoreData &&
            context.read<ProductListProvider>().productState !=
                ProductState.loadingMore) {
          callApi(isReset: false);
        }
      }
    }
  }

  callApi({required bool isReset}) async {
    try {
      if (isReset) {
        context.read<ProductListProvider>().offset = 0;

        context.read<ProductListProvider>().products = [];
        context.read<ProductListProvider>().filterProductsData = [];
      }

      Map<String, String> params = {};

      if (searchController.text.trim().isNotEmpty) {
        params[ApiAndParams.filter] = searchController.text.toString();
        params[ApiAndParams.search] = searchController.text.toString();
      }

      params[ApiAndParams.type] = productListSortTypes[currentAppliedFilter];

      params["sort"] = "new";

      await context
          .read<ProductListProvider>()
          .getProductListProvider(context: context, params: params);
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      searchController.addListener(() {
        callApi(isReset: true);
      });

      currentAppliedFilter = widget.currentFilterIndex;
      scrollController.addListener(scrollListener);
      callApi(isReset: true);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: titleProductsLabel,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                shape:
                DesignConfig.setRoundedBorderSpecific(20, istop: true, isbtm: true),
                builder: (BuildContext context1) {
                  return Wrap(
                    children: [
                      Container(
                        decoration: DesignConfig.boxDecoration(
                            Theme.of(context).cardColor, 10),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                PositionedDirectional(
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: defaultImg(
                                        image: AppAssets.arrowBackIcon,
                                        iconColor: ColorsRes.mainTextColor,
                                        height: 15,
                                        width: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: CustomTextLabel(
                                    jsonKey: filterByLabel,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .merge(
                                      TextStyle(
                                        letterSpacing: 0.5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: ColorsRes.mainTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            getSizedBox(height: 10),
                            Column(
                              children: List.generate(
                                productListSortTypes.length,
                                    (index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      context
                                          .read<ProductListProvider>()
                                          .products = [];

                                      context
                                          .read<ProductListProvider>()
                                          .offset = 0;
                                      currentAppliedFilter = index;

                                      callApi(isReset: true);
                                    },
                                    child: Container(
                                      padding:
                                      EdgeInsetsDirectional.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          currentAppliedFilter == index
                                              ? Icon(
                                            Icons
                                                .radio_button_checked,
                                            color: ColorsRes.appColor,
                                          )
                                              : Icon(
                                            Icons.radio_button_off,
                                            color: ColorsRes.appColor,
                                          ),
                                          getSizedBox(width: 10),
                                          Expanded(
                                            child: CustomTextLabel(
                                              jsonKey:
                                              lblSortingDisplayList[
                                              index],
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .merge(
                                                TextStyle(
                                                  letterSpacing: 0.5,
                                                  fontSize: 16,
                                                  color: ColorsRes
                                                      .mainTextColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.filter_alt_outlined,
              color: ColorsRes.appColor,
              semanticLabel: getTranslatedValue(context, filterByLabel),
              size: 30,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, productAddUpdateScreen,
              arguments: ["", ""]).then(
            (value) {
              if (value != null) {
                callApi(isReset: true);
              }
            },
          );
        },
        shape: CircleBorder(),
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
      ),
      body: setRefreshIndicator(
        refreshCallback: () async {
          context.read<ProductListProvider>().offset = 0;
          context.read<ProductListProvider>().products = [];

          callApi(isReset: true);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
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
              getSizedBox(height: 10),
              productWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget productWidget() {
    return Consumer<ProductListProvider>(
      builder: (context, productListProvider, _) {
        if (productListProvider.productState == ProductState.initial ||
            productListProvider.productState == ProductState.loading) {
          return getProductListShimmer(context: context, isGrid: false);
        } else if (productListProvider.productState == ProductState.loaded ||
            productListProvider.productState == ProductState.loadingMore) {
          if (currentAppliedFilter == 0) {
            List<ProductListItem> products = productListProvider.products;
            return Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    products.length,
                    (productIndex) {
                      return ChangeNotifierProvider<
                          SelectedVariantItemProvider>(
                        create: (context) => SelectedVariantItemProvider(),
                        child: ProductListItemContainer(
                          product: products[productIndex],
                          editVoidCallBack: () {
                            Navigator.pushNamed(
                              context,
                              productAddUpdateScreen,
                              arguments: [
                                products[productIndex].id.toString(),
                                "update",
                              ],
                            ).then(
                              (value) {
                                if (value != null) {
                                  callApi(isReset: true);
                                }
                              },
                            );
                          },
                          deleteVoidCallBack: () async {
                            if (products[productIndex].variants!.length <= 1) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: CustomTextLabel(
                                      jsonKey: deleteProductLabel,
                                    ),
                                    backgroundColor:
                                        Theme.of(context).cardColor,
                                    surfaceTintColor: ColorsRes.appColorTransparent,
                                    content: CustomTextLabel(
                                      jsonKey:
                                          areYouSureYouWantToDeleteProductVariantLabel,
                                      style: TextStyle(
                                        color: ColorsRes.mainTextColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: CustomTextLabel(
                                          jsonKey: cancelLabel,
                                          softWrap: true,
                                          style: TextStyle(
                                              color:
                                                  ColorsRes.subTitleTextColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      getSizedBox(width: 10),
                                      ChangeNotifierProvider(
                                        create: (context) =>
                                            DeleteProductProvider(),
                                        child: Consumer<DeleteProductProvider>(
                                          builder: (context,
                                              deleteProductProvider, child) {
                                            return GestureDetector(
                                              onTap: () async {
                                                await deleteProductProvider
                                                    .deleteProducts(
                                                        params: {
                                                      "id":
                                                          products[productIndex]
                                                                  .variants?[0]
                                                                  .id
                                                                  .toString() ??
                                                              ""
                                                    },
                                                        context: context,
                                                        from:
                                                            "product_listing").then(
                                                  (value) {
                                                    if (value != null) {
                                                      Navigator.pop(context);
                                                      callApi(isReset: true);
                                                    }
                                                  },
                                                );
                                              },
                                              child: deleteProductProvider
                                                          .sellerProductDeleteState ==
                                                      SellerDeleteProductState
                                                          .loading
                                                  ? Container(
                                                      height: 24,
                                                      width: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            ColorsRes.appColor,
                                                      ),
                                                    )
                                                  : CustomTextLabel(
                                                      jsonKey: okLabel,
                                                      style: TextStyle(
                                                        color:
                                                            ColorsRes.appColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Theme.of(context).cardColor,
                                shape: DesignConfig.setRoundedBorderSpecific(20,
                                    istop: true),
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin15),
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 15, end: 15),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      Constant.borderRadius10,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  child: setNetworkImg(
                                                      boxFit: BoxFit.fill,
                                                      image:
                                                          products[productIndex]
                                                              .imageUrl
                                                              .toString(),
                                                      height: 70,
                                                      width: 70)),
                                              getSizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: CustomTextLabel(
                                                  text: products[productIndex]
                                                      .name
                                                      .toString(),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color:
                                                        ColorsRes.mainTextColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin15),
                                          child: ListView.separated(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: products[productIndex]
                                                    .variants
                                                    ?.length ??
                                                0,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          child: RichText(
                                                            maxLines: 2,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            // maxLines: 1,
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: ColorsRes
                                                                            .mainTextColor,
                                                                        decorationThickness:
                                                                            2),
                                                                    text:
                                                                        "${products[productIndex].variants?[index].measurement} ",
                                                                  ),
                                                                  WidgetSpan(
                                                                    child:
                                                                        CustomTextLabel(
                                                                      text: products[
                                                                              productIndex]
                                                                          .variants?[
                                                                              index]
                                                                          .stockUnitName
                                                                          .toString(),
                                                                      softWrap:
                                                                          true,
                                                                      //superscript is usually smaller in size
                                                                      // textScaleFactor: 0.7,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: ColorsRes
                                                                            .mainTextColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                      text: double.parse(products[productIndex].variants?[index].discountedPrice.toString() ?? "0.0") !=
                                                                              0
                                                                          ? " | "
                                                                          : "",
                                                                      style: TextStyle(
                                                                          color:
                                                                              ColorsRes.mainTextColor)),
                                                                  TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: ColorsRes
                                                                            .mainTextColor,
                                                                        decoration:
                                                                            TextDecoration
                                                                                .lineThrough,
                                                                        decorationThickness:
                                                                            2),
                                                                    text: double.parse(products[productIndex].variants?[index].discountedPrice.toString() ??
                                                                                "0.0") !=
                                                                            0
                                                                        ? products[productIndex].variants![index].price ??
                                                                            "0.0".currency
                                                                        : "0.0",
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                        CustomTextLabel(
                                                          text: double.parse(products[
                                                                          productIndex]
                                                                      .variants![
                                                                          index]
                                                                      .discountedPrice
                                                                      .toString()) !=
                                                                  0
                                                              ? products[
                                                                      productIndex]
                                                                  .variants![
                                                                      index]
                                                                  .discountedPrice
                                                                  .toString()
                                                                  .currency
                                                              : products[
                                                                      productIndex]
                                                                  .variants![
                                                                      index]
                                                                  .price
                                                                  .toString()
                                                                  .currency,
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color: ColorsRes
                                                                  .appColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: CustomTextLabel(
                                                      text:
                                                          "${getTranslatedValue(context, stockLabel)} : ${products[productIndex].variants![index].isUnlimitedStock == "1" ? getTranslatedValue(context, unlimitedLabel) : products[productIndex].variants![index].stock}${products[productIndex].variants![index].isUnlimitedStock == "1" ? "" : " ${products[productIndex].variants![index].stockUnitName}"}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: ColorsRes
                                                            .mainTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                  getSizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title:
                                                                CustomTextLabel(
                                                              jsonKey:
                                                                  "delete_product",
                                                            ),
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                            surfaceTintColor:
                                                                Colors
                                                                    .transparent,
                                                            content:
                                                                CustomTextLabel(
                                                              jsonKey:
                                                                  areYouSureYouWantToDeleteProductVariantLabel,
                                                              style: TextStyle(
                                                                color: ColorsRes
                                                                    .mainTextColor,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            actions: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    CustomTextLabel(
                                                                  jsonKey:
                                                                      "cancel",
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      color: ColorsRes
                                                                          .subTitleTextColor,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              getSizedBox(
                                                                  width: 10),
                                                              ChangeNotifierProvider(
                                                                create: (context) =>
                                                                    DeleteProductProvider(),
                                                                child: Consumer<
                                                                    DeleteProductProvider>(
                                                                  builder: (context,
                                                                      deleteProductProvider,
                                                                      child) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await deleteProductProvider.deleteProducts(
                                                                            params: {
                                                                              "id": products[productIndex].variants![index].id.toString()
                                                                            },
                                                                            context:
                                                                                context,
                                                                            from:
                                                                                "product_listing").then(
                                                                          (value) {
                                                                            if (value !=
                                                                                null) {
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                              callApi(isReset: true);
                                                                            }
                                                                          },
                                                                        );
                                                                      },
                                                                      child: deleteProductProvider.sellerProductDeleteState ==
                                                                              SellerDeleteProductState.loading
                                                                          ? Container(
                                                                              height: 24,
                                                                              width: 24,
                                                                              child: CircularProgressIndicator(
                                                                                color: ColorsRes.appColor,
                                                                              ),
                                                                            )
                                                                          : CustomTextLabel(
                                                                              jsonKey: okLabel,
                                                                              style: TextStyle(
                                                                                color: ColorsRes.appColor,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      height: 24,
                                                      width: 24,
                                                      padding:
                                                          EdgeInsets.all(2.5),
                                                      decoration: BoxDecoration(
                                                        color: ColorsRes.appColorRed,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .delete_forever_rounded,
                                                        color: ColorsRes.appColorWhite,
                                                        size: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 7),
                                                child: Divider(
                                                  color: ColorsRes.grey,
                                                  height: 5,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          duplicateVoidCallBack: () {
                            Navigator.pushNamed(
                              context,
                              productAddUpdateScreen,
                              arguments: [
                                products[productIndex].id.toString(),
                                "duplicate",
                              ],
                            ).then(
                              (value) {
                                if (value != null) {
                                  callApi(isReset: true);
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (productListProvider.productState ==
                    ProductState.loadingMore)
                  getProductItemShimmer(context: context, isGrid: false),
              ],
            );
          } else {
            List<FilterProductsDataProducts> products =
                productListProvider.filterProductsData;
            return Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    products.length,
                    (productIndex) {
                      return ProductFilterListItemContainer(
                        product: products[productIndex],
                        editVoidCallBack: () {
                          Navigator.pushNamed(
                            context,
                            productAddUpdateScreen,
                            arguments: [
                              products[productIndex].id.toString(),
                              "update",
                            ],
                          ).then(
                            (value) {
                              if (value != null) {
                                callApi(isReset: true);
                              }
                            },
                          );
                        },
                        deleteVoidCallBack: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: CustomTextLabel(
                                  jsonKey: deleteProductLabel,
                                ),
                                backgroundColor: Theme.of(context).cardColor,
                                surfaceTintColor: ColorsRes.appColorTransparent,
                                content: CustomTextLabel(
                                  jsonKey:
                                      areYouSureYouWantToDeleteProductVariantLabel,
                                  style: TextStyle(
                                    color: ColorsRes.mainTextColor,
                                    fontSize: 15,
                                  ),
                                ),
                                actions: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: CustomTextLabel(
                                      jsonKey: cancelLabel,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: ColorsRes.subTitleTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  getSizedBox(width: 10),
                                  ChangeNotifierProvider(
                                    create: (context) =>
                                        DeleteProductProvider(),
                                    child: Consumer<DeleteProductProvider>(
                                      builder: (context, deleteProductProvider,
                                          child) {
                                        return GestureDetector(
                                          onTap: () async {
                                            await deleteProductProvider
                                                .deleteProducts(
                                                    params: {
                                                  "id": products[productIndex]
                                                      .productVariantId
                                                      .toString()
                                                },
                                                    context: context,
                                                    from:
                                                        "product_listing").then(
                                              (value) {
                                                if (value != null) {
                                                  Navigator.pop(context);
                                                  callApi(isReset: true);
                                                }
                                              },
                                            );
                                          },
                                          child: deleteProductProvider
                                                      .sellerProductDeleteState ==
                                                  SellerDeleteProductState
                                                      .loading
                                              ? Container(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: ColorsRes.appColor,
                                                  ),
                                                )
                                              : CustomTextLabel(
                                                  jsonKey: okLabel,
                                                  style: TextStyle(
                                                    color: ColorsRes.appColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                if (productListProvider.productState ==
                    ProductState.loadingMore)
                  getProductItemShimmer(context: context, isGrid: false),
              ],
            );
          }
        } else if (productListProvider.productState == ProductState.empty) {
          return DefaultBlankItemMessageScreen(
            title: getTranslatedValue(context, emptyProductListMessageLabel),
            description:
                getTranslatedValue(context, emptyProductListDescriptionLabel),
            image: "no_product_icon",
          );
        } else {
          return DefaultBlankItemMessageScreen(
            title: getTranslatedValue(context, emptyProductListMessageLabel),
            description:
                getTranslatedValue(context, emptyProductListDescriptionLabel),
            image: "no_product_icon",
          );
        }
      },
    );
  }

  Future<List<List<String>>> getSizeListSizesAndIds(List sizeList) async {
    List<String> sizes = [];
    List<String> unitIds = [];

    for (int i = 0; i < sizeList.length; i++) {
      if (i % 2 == 0) {
        sizes.add(sizeList[i].toString().split("-")[0]);
      } else {
        unitIds.add(sizeList[i].toString().split("-")[1]);
      }
    }
    return [sizes, unitIds];
  }

  String getFiltersItemsList(List<String> param) {
    String ids = "";
    for (int i = 0; i < param.length; i++) {
      ids += "${param[i]}${i == (param.length - 1) ? "" : ","}";
    }
    return ids;
  }
}
