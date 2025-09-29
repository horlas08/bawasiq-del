import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/brand.dart';
import 'package:project/models/countries.dart';
import 'package:project/models/measurementUnit.dart';
import 'package:project/models/productDetail.dart';
import 'package:project/models/productList.dart';
import 'package:project/models/tax.dart';
import 'package:project/provider/geminiProvider.dart';
import 'package:project/provider/productDeleteProvider.dart';
import 'package:project/screens/addUpdateProductScreen/widget/stepperCounter.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class ProductAddScreen extends StatefulWidget {
  final String productId;
  final String from;

  ProductAddScreen({Key? key, required this.productId, required this.from}) : super(key: key);

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

enum Returnable { no, yes }

enum Cancellable { no, yes }

enum IsCodAllowed { no, yes }

enum ProductPackType { packet, loose }

enum ProductStockType { limited, unlimited }

class _ProductAddScreenState extends State<ProductAddScreen> {
  ProductListItem? product = null;

  PageController pageController = PageController();
  int currentPage = 0;
  late bool isLoading = false, _useCustomPrompt = false;
  String selectedProductMainImage = "";
  String htmlDescription = "";
  QuillEditorController quillController = QuillEditorController();
  List<String> selectedProductOtherImages = [];

  TextEditingController edtProductName = TextEditingController();
  TextEditingController edtProductFssaiNumber = TextEditingController();
  TextEditingController edtProductManufacturer = TextEditingController();
  TextEditingController edtProductTagsAdd = TextEditingController();
  TextEditingController edtMetaTitle = TextEditingController();
  TextEditingController edtMetaKeywords = TextEditingController();
  TextEditingController edtSchemaMarkup = TextEditingController();
  TextEditingController edtMetaDescription = TextEditingController();
  TextEditingController edtCustomAiPrompt = TextEditingController();
  TextEditingController edtBarcode = TextEditingController();

  String productTax = "";
  String productTaxId = "";

  String productBrand = "";
  String productBrandId = "";

  String productMadeIn = "";
  String productMadeInId = "";

  String productCategory = "";
  String productCategoryId = "";

  String productType = "";

  Returnable returnable = Returnable.no;
  TextEditingController edtProductReturnDays = TextEditingController();

  Cancellable cancellable = Cancellable.no;

  String productCancellableStatus = "";
  String productCancellableStatusId = "";

  TextEditingController edtProductTotalAllowedQuantity = TextEditingController();

  IsCodAllowed isCodAllowed = IsCodAllowed.no;

  ProductPackType productPackType = ProductPackType.packet;

  ProductStockType productStockType = ProductStockType.limited;

  TextEditingController edtProductStock = TextEditingController();

  String productMainUnit = "";
  String productMainUnitId = "";

  String productMainStockStatus = "";

  List<TextEditingController> edtProductVariantMeasurement = [];
  List<TextEditingController> edtProductVariantStock = [];
  List<TextEditingController> edtProductVariantPrice = [];
  List<TextEditingController> edtProductVariantDiscountedPrice = [];

  List<String> productVariantUnit = [];
  List<String> productVariantUnitId = [];

  List<String> productVariantStockStatus = [];
  List<String> productVariantStockStatusId = [];

  int variantsLength = 1;

  // Only for edit product params
  String productId = "";
  List<String> variantIds = [];
  String productMainImage = "";
  List<ProductDetailImages> productOtherImages = [];
  List<String> productDeletedOtherImages = [];

  List<ProductDetailVariants> variantsList = [];

  List<TagsData> selectedTags = [];
  File? mainImage;
  List<File>? otherImage;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      callApi();
    });
    super.initState();
  }

  callApi() {
    if (widget.productId.isEmpty) {
      addNewVariant();
    } else {
      context
          .read<AddUpdateProductProvider>()
          .productById(params: {"product_id": widget.productId.checkNullString()}, context: context).then((value) {
        if (value is ProductDetail) {
          ProductDetailData productDetailData = value.data!;
          variantsLength = productDetailData.variants?.length ?? 0;

          selectedTags = productDetailData.tags ?? [];

          for (ProductDetailVariants variant in productDetailData.variants ?? []) {
            addExistVariant(variant: variant);
          }

          productMainImage = productDetailData.imageUrl?.checkNullString() ?? "";
          htmlDescription = productDetailData.description?.checkNullString().replaceAll(RegExp(r'^```html\n|```$'), '') ?? "";
          for (ProductDetailImages otherImage in productDetailData.images ?? []) {
            productOtherImages.add(otherImage);
          }

          if (widget.from == "duplicate") {
            productOtherImages.clear();
            productMainImage = "";
          }

          edtProductName = TextEditingController(text: productDetailData.name?.checkNullString() ?? "");
          edtProductFssaiNumber = TextEditingController(text: productDetailData.fssaiLicNo.toString().checkNullString());
          edtProductManufacturer = TextEditingController(text: productDetailData.manufacturer?.checkNullString() ?? "");
          edtMetaTitle = TextEditingController(text: productDetailData.metaTitle?.checkNullString() ?? "");
          edtMetaKeywords = TextEditingController(text: productDetailData.metaKeywords.toString().checkNullString());
          edtSchemaMarkup = TextEditingController(text: productDetailData.schemaMarkup?.checkNullString() ?? "");
          edtMetaDescription = TextEditingController(text: productDetailData.metaDescription?.checkNullString() ?? "");
          edtBarcode = TextEditingController(text: productDetailData.barcode?.checkNullString() ?? "");

          productTax = productDetailData.tax?.title?.checkNullString() ?? "";
          productTaxId = productDetailData.tax?.id?.checkNullString() ?? "";

          productBrand = productDetailData.brand?.name ?? "";
          productBrandId = productDetailData.brand?.id?.checkNullString() ?? "";

          productMadeIn = productDetailData.madeInCountry?.name?.checkNullString() ?? "";
          productMadeInId = productDetailData.madeIn?.checkNullString() ?? "";

          productCategory = productDetailData.category?.name?.checkNullString() ?? "";
          productCategoryId = productDetailData.categoryId?.checkNullString() ?? "";

          productType = productDetailData.indicator?.checkNullString() == "1"
              ? "Veg"
              : productDetailData.indicator?.checkNullString() == "2"
                  ? "Non Veg"
                  : "None";

          returnable = productDetailData.returnStatus?.checkNullString() == "0" ? Returnable.no : Returnable.yes;
          edtProductReturnDays = TextEditingController(text: productDetailData.returnDays?.checkNullString());

          cancellable = productDetailData.cancelableStatus?.checkNullString() == "0" ? Cancellable.no : Cancellable.yes;

          productCancellableStatusId = productDetailData.tillStatus?.checkNullString() ?? "";

          switch (productDetailData.tillStatus?.checkNullString() ?? "") {
            case '1':
              productCancellableStatus = getTranslatedValue(context, orderStatusDisplayNamesAwaitingLabel);
              break;
            case '2':
              productCancellableStatus = getTranslatedValue(context, orderStatusDisplayNamesReceivedLabel);
              break;
            case '3':
              productCancellableStatus = getTranslatedValue(context, orderStatusDisplayNamesProcessedLabel);
              break;
            case '4':
              productCancellableStatus = getTranslatedValue(context, orderStatusDisplayNamesShippedLabel);
              break;
            case '5':
              productCancellableStatus = getTranslatedValue(context, orderStatusDisplayNamesOutForDeliveryLabel);
              break;
            case '6':
              productCancellableStatus = getTranslatedValue(context, orderStatusDisplayNamesDeliveredLabel);
              break;
            case '7':
              productCancellableStatus = getTranslatedValue(context, orderStatusDisplayNamesCancelledLabel);
              break;
            case '8':
              productCancellableStatus = getTranslatedValue(context, orderStatusDisplayNamesReturnedLabel);
              break;
            default:
              "";
          }

          edtProductTotalAllowedQuantity = TextEditingController(text: productDetailData.totalAllowedQuantity.toString().checkNullString());

          isCodAllowed = productDetailData.codAllowed.toString().checkNullString() == "0" ? IsCodAllowed.no : IsCodAllowed.yes;

          productPackType = productDetailData.type.toString().checkNullString() == "packet" ? ProductPackType.packet : ProductPackType.loose;

          productStockType =
              productDetailData.isUnlimitedStock.toString().checkNullString() == "0" ? ProductStockType.limited : ProductStockType.unlimited;

          edtProductStock = TextEditingController(text: productPackType == ProductPackType.loose ? productDetailData.variants?.first.stock : "0");

          productMainUnit =
              productPackType == ProductPackType.loose ? productDetailData.variants?.first.unit?.shortCode.toString().checkNullString() ?? "" : "";
          productMainUnitId =
              productPackType == ProductPackType.loose ? productDetailData.variants?.first.unit?.id.toString().checkNullString() ?? "" : "";

          productMainStockStatus = productDetailData.status == "1"
              ? context.read<ProductStockStatusProvider>().productStockStatus[0]
              : context.read<ProductStockStatusProvider>().productStockStatus[1];
          setState(() {});
        }
      });
    }
  }

  // Helper function to build the tag ID string
  String _buildTagIdString(List<TagsData> selectedTags) {
    List<String> tagIdStrings = selectedTags.map((tag) {
      return tag.id != null ? tag.id.toString() : tag.name!;
    }).toList();
    return tagIdStrings.join(',');
  }

  void addNewVariant({Variants? variant}) {
    edtProductVariantMeasurement.add(TextEditingController());
    edtProductVariantStock.add(TextEditingController());
    edtProductVariantPrice.add(TextEditingController());
    edtProductVariantDiscountedPrice.add(TextEditingController());
    productVariantUnit.add("");
    productVariantUnitId.add("");
    productVariantStockStatus.add("");
    productVariantStockStatusId.add("");
    context.read<AddUpdateProductProvider>().updateProductDataLoadingState();
    variantsList.add(ProductDetailVariants());
    setState(() {});
  }

  void removeVariant(int index) {
    variantsList.removeAt(index);
    edtProductVariantMeasurement.removeAt(index);
    edtProductVariantStock.removeAt(index);
    edtProductVariantPrice.removeAt(index);
    edtProductVariantDiscountedPrice.removeAt(index);
    productVariantUnit.removeAt(index);
    productVariantUnitId.removeAt(index);
    productVariantStockStatus.removeAt(index);
    productVariantStockStatusId.removeAt(index);
  }

  void addExistVariant({ProductDetailVariants? variant}) {
    variantIds.add(variant?.id?.toString() ?? "");
    edtProductVariantMeasurement.add(TextEditingController(text: variant?.measurement.toString()));
    edtProductVariantStock.add(TextEditingController(text: variant?.stock.toString()));
    edtProductVariantPrice.add(TextEditingController(text: variant?.price.toString()));
    edtProductVariantDiscountedPrice.add(TextEditingController(text: variant?.discountedPrice.toString()));
    productVariantUnit.add(variant?.unit?.shortCode?.toString() ?? "");
    productVariantStockStatus.add(variant?.status.toString() == "1" ? "Available" : "Sold-out");
    productVariantStockStatusId.add(variant?.status.toString() ?? "0");

    productVariantUnitId.add(variant?.stockUnitId.toString() ?? "0");

    variantsList.add(variant!);
  }

  backendApiProcess() async {
    List<String> measurement = [];
    List<String> price = [];
    List<String> discountedPrice = [];
    List<String> stock = [];
    List<String> stockUnitId = [];
    List<String> stockStatus = [];

    String type = productPackType == ProductPackType.packet ? "packet" : "loose";

    Map<String, String> params = {};

    if (widget.productId.isNotEmpty || widget.from != "duplicate") {
      params[ApiAndParams.id] = widget.productId;
    }

    for (int index = 0; index < variantsLength; index++) {
      if (variantsList[index].id != null) {
        params["variant_id[$index]"] = variantIds[index].toString();
      } else {
        params["variant_id[$index]"] = "0";
      }
      params["${type}_measurement[$index]"] = edtProductVariantMeasurement[index].text.toString();
      params["${type}_price[$index]"] = edtProductVariantPrice[index].text.toString();
      if (type == "packet") {
        params["discounted_price[$index]"] = edtProductVariantDiscountedPrice[index].text.toString();
      } else {
        params["${type}_discounted_price[$index]"] = edtProductVariantDiscountedPrice[index].text.toString();
      }
      if (type == "packet") {
        params["${type}_stock[$index]"] = productStockType == ProductStockType.unlimited ? "1" : edtProductVariantStock[index].text.toString();
        params["${type}_stock_unit_id[$index]"] = productVariantUnitId[index];
        params["${type}_status[$index]"] = productVariantStockStatus[index].toLowerCase() == "available" ? "1" : "0";
      }

      measurement.add(edtProductVariantMeasurement[index].text.toString());
      price.add(edtProductVariantPrice[index].text.toString());
      discountedPrice
          .add(edtProductVariantDiscountedPrice[index].text.toString().isEmpty ? "0" : edtProductVariantDiscountedPrice[index].text.toString());
      stock.add(productStockType == ProductStockType.unlimited ? "0" : edtProductVariantStock[index].text.toString());
      stockUnitId.add(productVariantUnitId[index]);
      stockStatus.add(productVariantStockStatus[index].toLowerCase() == "available" ? "1" : "0");
    }

    params["name"] = "${edtProductName.text.toString()}";
    params["tag_ids"] = _buildTagIdString(selectedTags);
    params["tax_id"] = productTaxId.isEmpty ? "0" : productTaxId;
    params["brand_id"] = productBrandId.isEmpty ? "0" : productBrandId;
    params["description"] = htmlDescription;
    params["type"] = productPackType == ProductPackType.packet ? "packet" : "loose";
    params["seller_id"] = Constant.session.getData("user_id");
    params["is_unlimited_stock"] = productStockType == ProductStockType.unlimited ? "1" : "0";
    params["fssai_lic_no"] = edtProductFssaiNumber.text.toString();
    params["meta_title"] = edtMetaTitle.text.toString();
    params["meta_keywords"] = edtMetaKeywords.text.toString();
    params["schema_markup"] = edtSchemaMarkup.text.toString();
    params["meta_description"] = edtMetaDescription.text.toString();
    params["barcode"] = edtBarcode.text.toString();

    if (type == "loose") {
      params["loose_stock"] = productStockType == ProductStockType.unlimited ? "0" : edtProductStock.text.toString();
      params["loose_stock_unit_id"] = productMainUnitId.toString();
      params["status"] = productMainStockStatus.toLowerCase() == "available" ? "1" : "0";
    }
    params["category_id"] = productCategoryId;
    params["product_type"] = productType.toLowerCase() == "none"
        ? "0"
        : productType.toLowerCase() == "veg"
            ? "1"
            : "2";
    params["manufacturer"] = edtProductManufacturer.text.toString();
    params["made_in"] = productMadeInId;
    params["shipping_type"] = "undefined";
    params["pincode_ids_exc"] = "undefined";
    params["return_status"] = returnable == Returnable.yes ? "1" : "0";
    params["return_days"] = returnable == Returnable.yes ? edtProductReturnDays.text.toString() : "0";
    params["cancelable_status"] = cancellable == Cancellable.yes ? "1" : "0";
    params["till_status"] = (cancellable == Cancellable.no && productCancellableStatusId.isEmpty) ? "0" : productCancellableStatusId;
    ;
    params["cod_allowed_status"] = isCodAllowed == IsCodAllowed.yes ? "1" : "0";
    params["max_allowed_quantity"] = edtProductTotalAllowedQuantity.text.toString();
    params["tax_included_in_price"] = "0";
    params["deleteImageIds"] = "${productDeletedOtherImages.toString()}";

    Map<String, File> filesMap = {};

    if (selectedProductMainImage.isNotEmpty) {
      filesMap["image"] = File(selectedProductMainImage);
    }

    if (selectedProductOtherImages.isNotEmpty) {
      for (int i = 0; i < selectedProductOtherImages.length; i++) {
        filesMap["other_images[$i]"] = File(selectedProductOtherImages[i]);
      }
    }

    await context
        .read<AddUpdateProductProvider>()
        .addOrUpdateProducts(
          params: params,
          filesMap: filesMap,
          context: context,
          isAdd: (widget.productId.isEmpty || widget.from == "duplicate"),
          mainImage: mainImage,
          otherImage: otherImage ?? [],
        )
        .then((value) async {
      if (value != null) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddUpdateProductProvider>(
      builder: (context, addUpdateProductProvider, child) {
        return Scaffold(
          appBar: getAppBar(
            context: context,
            title: CustomTextLabel(
              jsonKey: (widget.productId.isEmpty || widget.from == "duplicate") ? "title_add_products" : "title_update_products",
              style: TextStyle(color: ColorsRes.mainTextColor),
            ),
          ),
          bottomNavigationBar: (addUpdateProductProvider.sellerGetProductByIdState == SellerGetProductByIdState.loaded &&
                  addUpdateProductProvider.tagsState == TagsState.loaded)
              ? Row(
                  children: [
                    Expanded(
                      child: CustomShimmer(
                        height: 40,
                        width: context.width,
                        borderRadius: 10,
                        margin: EdgeInsetsDirectional.only(start: 10),
                      ),
                    ),
                    Expanded(
                      child: CustomShimmer(
                        height: 40,
                        width: context.width,
                        borderRadius: 10,
                        margin: EdgeInsetsDirectional.only(start: 10, end: 10),
                      ),
                    ),
                    Expanded(
                      child: CustomShimmer(
                        height: 40,
                        width: context.width,
                        borderRadius: 10,
                        margin: EdgeInsetsDirectional.only(end: 10),
                      ),
                    ),
                  ],
                )
              : Container(
                  constraints: BoxConstraints(
                    maxHeight: 60,
                  ),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child: StepperCounter(
                    firstCounterText: backLabel,
                    firstItemVoidCallback: () {
                      if (currentPage == 0) {
                        Navigator.pop(context);
                      } else {
                        currentPage--;
                        pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      }
                    },
                    secondCounterText: "${currentPage + 1}/4",
                    thirdCounterText: currentPage == 3
                        ? (widget.productId.isEmpty || widget.from == "duplicate")
                            ? addProductLabel
                            : updateProductLabel
                        : "next",
                    thirdItemVoidCallback: () => pageChangeValidation(currentPage),
                  ),
                ),
          body: addUpdateProductProvider.sellerGetProductByIdState == SellerGetProductByIdState.loading
              ? Container(
                  child: CustomShimmer(
                    width: context.width,
                    height: context.height,
                    margin: EdgeInsetsDirectional.all(10),
                    borderRadius: 10,
                  ),
                )
              : addUpdateProductProvider.sellerGetProductByIdState == SellerGetProductByIdState.loaded
                  ? PageView(
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        currentPage = value;
                        setState(
                          () {},
                        );
                      },
                      controller: pageController,
                      children: [
                        // 2. Product images screen
                        Container(
                          padding: EdgeInsetsDirectional.all(15),
                          alignment: Alignment.center,
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: [
                                productInfoWidgets(),
                              ],
                            ),
                          ),
                        ),
                        // 2. Product images screen
                        Container(
                          padding: EdgeInsetsDirectional.all(15),
                          alignment: Alignment.center,
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: [
                                productImagesSelectionWidgets(),
                              ],
                            ),
                          ),
                        ),
                        // 2. Product images screen
                        Container(
                          padding: EdgeInsetsDirectional.all(15),
                          alignment: Alignment.center,
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: [
                                productVariantsWidgets(),
                              ],
                            ),
                          ),
                        ),
                        // 4. Product other settings screen
                        Container(
                          padding: EdgeInsetsDirectional.all(15),
                          alignment: Alignment.center,
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: [
                                productOtherSettingsWidgets(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : DefaultBlankItemMessageScreen(
                      height: context.height,
                      image: "something_went_wrong",
                      title: getTranslatedValue(context, oopsErrorLabel),
                      description: getTranslatedValue(context, oopsErrorMessageLabel),
                      buttonTitle: getTranslatedValue(context, tryAgainLabel),
                      callback: () async {
                        await callApi();
                      },
                    ),
        );
      },
    );
  }

// 1. PRODUCT INFO SCREEN
  Widget productInfoWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomTitleTextLabel(
              jsonKey: productNameLabel,
            ),
            requiredFieldSign(),
          ],
        ),
        getSizedBox(
          height: 5,
        ),
        editBoxWidget(
          maxlines: 1,
          context: context,
          edtController: edtProductName,
          validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterProductNameLabel)),
          label: getTranslatedValue(context, productNameLabel),
          hint: getTranslatedValue(context, productNameHintLabel),
          bgcolor: Theme.of(context).cardColor,
          inputType: TextInputType.text,
        ),
        getSizedBox(
          height: 15,
        ),
        //for seo
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomTitleTextLabel(
                  jsonKey: schemaMarkupLabel,
                ),
                toolTipSign()
              ],
            ),
            getSizedBox(
              height: 5,
            ),
            editBoxWidget(
              maxlines: 1,
              context: context,
              edtController: edtSchemaMarkup,
              validationFunction: (value)=> optionalFieldValidation("",  ""),
              label: getTranslatedValue(context, schemaMarkupLabel),
              hint: getTranslatedValue(context, schemaMarkupHintLabel),
              bgcolor: Theme.of(context).cardColor,
              inputType: TextInputType.text,
            ),
            getSizedBox(
              height: 15,
            ),
            CustomTitleTextLabel(
              jsonKey: metaKeywordsLabel,
            ),
            getSizedBox(
              height: 5,
            ),
            editBoxWidget(
              maxlines: 1,
              context: context,
              edtController: edtMetaKeywords,
              validationFunction: (value)=> optionalFieldValidation("",  ""),
              label: getTranslatedValue(context, metaKeywordsLabel),
              hint: getTranslatedValue(context, metaKeywordsHintLabel),
              bgcolor: Theme.of(context).cardColor,
              inputType: TextInputType.text,
            ),
            getSizedBox(
              height: 15,
            ),
            CustomTitleTextLabel(
              jsonKey: metaTitleLabel,
            ),
            getSizedBox(
              height: 5,
            ),
            editBoxWidget(
              maxlines: 1,
              context: context,
              edtController: edtMetaTitle,
              validationFunction: (value)=> optionalFieldValidation("",  ""),
              label: getTranslatedValue(context, metaTitleLabel),
              hint: getTranslatedValue(context, metaTitleHintLabel),
              bgcolor: Theme.of(context).cardColor,
              inputType: TextInputType.text,
            ),
            getSizedBox(
              height: 15,
            ),
            CustomTitleTextLabel(
              jsonKey: metaDescriptionLabel,
            ),
            getSizedBox(
              height: 5,
            ),
            editBoxWidget(
              maxlines: 1,
              context: context,
              edtController: edtMetaDescription,
              validationFunction: (value)=> optionalFieldValidation("",  ""),
              label: getTranslatedValue(context, metaDescriptionLabel),
              hint: getTranslatedValue(context, metaDescriptionHintLabel),
              bgcolor: Theme.of(context).cardColor,
              inputType: TextInputType.text,
            ),
            getSizedBox(
              height: 15,
            ),
            CustomTitleTextLabel(
              jsonKey: barcodeLabel,
            ),
            getSizedBox(
              height: 5,
            ),
            editBoxWidget(
              maxlines: 1,
              context: context,
              edtController: edtBarcode,
              validationFunction: (value)=> optionalFieldValidation("",  ""),
              label: getTranslatedValue(context, barcodeLabel),
              hint: getTranslatedValue(context, barcodeHintLabel),
              bgcolor: Theme.of(context).cardColor,
              inputType: TextInputType.text,
            ),
            getSizedBox(
              height: 15,
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ItemSelectionWidget(
                labelJsonKey: productTaxLabel,
                labelJsonKeyHint: productTaxHintLabel,
                selectedValue: productTax,
                selectedValueId: productTaxId,
                voidCallback: () {
                  Navigator.pushNamed(context, taxesListScreen).then(
                    (value) {
                      if (value is TaxesData) {
                        productTax = "${value.title} (${value.percentage}%)";
                        productTaxId = "${value.id}";
                      }
                      setState(() {});
                    },
                  );
                },
                voidCallbackForClearField: () {
                  productTax = "";
                  productTaxId = "";
                  setState(() {});
                },
              ),
            ),
            getSizedBox(width: 10),
            Expanded(
              child: ItemSelectionWidget(
                labelJsonKey: productBrandLabel,
                labelJsonKeyHint: productBrandHintLabel,
                selectedValue: productBrand,
                selectedValueId: productBrandId,
                voidCallback: () {
                  Navigator.pushNamed(context, brandListScreen).then(
                    (value) {
                      if (value is BrandData) {
                        productBrand = "${value.name}";
                        productBrandId = "${value.id}";
                      }
                      setState(() {});
                    },
                  );
                },
                voidCallbackForClearField: () {
                  productBrand = "";
                  productBrandId = "";
                  setState(() {});
                },
              ),
            )
          ],
        ),
        getSizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ItemSelectionWidget(
                labelJsonKey: productMadeInLabel,
                labelJsonKeyHint: productMadeInHintLabel,
                selectedValue: productMadeIn,
                selectedValueId: productMadeInId,
                voidCallback: () {
                  Navigator.pushNamed(context, countriesListScreen).then(
                    (value) {
                      if (value is CountriesData) {
                        productMadeIn = "${value.name}";
                        productMadeInId = "${value.id}";
                        setState(() {});
                      }
                    },
                  );
                },
                voidCallbackForClearField: () {
                  productMadeIn = "";
                  productMadeInId = "";
                  setState(() {});
                },
              ),
            ),
            getSizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTitleTextLabel(
                    jsonKey: productFssaiNumberLabel,
                  ),
                  getSizedBox(
                    height: 5,
                  ),
                  editBoxWidget(
                    maxlines: 1,
                    context: context,
                    edtController: edtProductFssaiNumber,
                    validationFunction: (value)=> optionalFieldValidation("",  ""),
                    label: getTranslatedValue(context, productFssaiNumberLabel),
                    hint: getTranslatedValue(context, productFssaiNumberHintLabel),
                    bgcolor: Theme.of(context).cardColor,
                    inputType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CustomNumberTextInputFormatter()],
                  ),
                ],
              ),
            )
          ],
        ),
        getSizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ItemSelectionWidget(
                labelJsonKey: productCategoryLabel,
                labelJsonKeyHint: productCategoryHintLabel,
                selectedValue: productCategory,
                selectedValueId: productCategoryId,
                isFieldRequired: true,
                voidCallback: () {
                  Navigator.pushNamed(context, categoryListScreen, arguments: "product_add").then(
                    (value) {
                      if (value is CategoryData) {
                        productCategory = "${value.name}";
                        productCategoryId = "${value.id}";
                        setState(() {});
                      }
                    },
                  );
                },
              ),
            ),
            getSizedBox(width: 10),
            Expanded(
              child: ItemSelectionWidget(
                labelJsonKey: productTypeLabel,
                labelJsonKeyHint: productTypeHintLabel,
                selectedValue: productType,
                selectedValueId: "0",
                voidCallback: () {
                  Navigator.pushNamed(context, productTypeScreen).then(
                    (value) {
                      if (value is String) {
                        productType = "${value}";
                        setState(() {});
                      }
                    },
                  );
                },
                voidCallbackForClearField: () {
                  productType = "";
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        getSizedBox(
          height: 15,
        ),
        CustomTitleTextLabel(
          jsonKey: productTagsLabel,
        ),
        getSizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      selectedTags.length,
                      (index) {
                        return Container(
                          padding: EdgeInsetsDirectional.only(start: 10, end: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorsRes.appColor,
                          ),
                          child: Row(
                            children: [
                              CustomTextLabel(
                                text: selectedTags[index].name!,
                                style: TextStyle(
                                  color: ColorsRes.appColorWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, tagsListScreen, arguments: selectedTags).then(
                    (value) {
                      if (value is List<TagsData>) {
                        selectedTags.clear();
                        selectedTags = value;
                      }
                      print("");
                      setState(() {});
                    },
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: ColorsRes.appColor,
                ),
              ),
            ],
          ),
        ),
        getSizedBox(
          height: 15,
        ),
        CustomTitleTextLabel(
          jsonKey: productManufacturerLabel,
        ),
        getSizedBox(
          height: 5,
        ),
        editBoxWidget(
          maxlines: 1,
          context: context,
          edtController: edtProductManufacturer,
          validationFunction: (value)=> optionalFieldValidation("",  ""),
          label: getTranslatedValue(context, productManufacturerLabel),
          hint: getTranslatedValue(context, productManufacturerHintLabel),
          bgcolor: Theme.of(context).cardColor,
          inputType: TextInputType.text,
        ),
        getSizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTitleTextLabel(
                      jsonKey: customPromptLabel,
                    ),
            ),
            Switch(inactiveTrackColor: ColorsRes.grey,
            activeTrackColor: ColorsRes.appColor,
              value: _useCustomPrompt,
              onChanged: (val) {
                setState(() {
                  _useCustomPrompt = val;
                });
              },
            ),
          ],
        ),
        getSizedBox(
          height: 10,
        ),
        if (_useCustomPrompt)
          editBoxWidget(
            maxlines: 1,
            context: context,
            edtController: edtCustomAiPrompt,
            validationFunction: (value)=> optionalFieldValidation("",  ""),
            label: getTranslatedValue(context, customPromptLabel),
            hint: getTranslatedValue(context, enterCustomAiPromptLabel),
            bgcolor: Theme.of(context).cardColor,
            inputType: TextInputType.text,
          ),
        SizedBox(height: (_useCustomPrompt)?20:5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  CustomTitleTextLabel(
                    jsonKey: productDescriptionLabel,
                  ),
                  requiredFieldSign(),
                ],
              ),
            ),
            Consumer<GeminiDescriptionProvider>(
              builder: (context, geminiDescriptionProvider, _) {
                return GestureDetector(
                  onTap: geminiDescriptionProvider.state == GeminiGenerationState.loading
                      ? null
                      : () async {
                        if(Constant.demoMode=="1"){
                          showMessage(context, getTranslatedValue(context, demoModeMessageLabel), MessageType.error);
                        }else{
                          if (edtProductName.text.trim().isEmpty) {
                            showMessage(context, getTranslatedValue(context, productNameValidationMessageLabel), MessageType.error);
                            return;
                          }
                          if (_useCustomPrompt && edtCustomAiPrompt.text.trim().isEmpty) {
                            showMessage(context, getTranslatedValue(context, customPromptMessageLabel), MessageType.error);
                            return;
                          }/* 
                          if (Constant.textGenKey.isEmpty) {
                            showMessage(context, getTranslatedValue(context, apiKeyMissingLabel), MessageType.error);
                            return;
                          } */

                          String content = _useCustomPrompt
                              ? '${Constant.customPromptMessage} ${edtCustomAiPrompt.text}'
                              : Constant.defaultPromptMessage(edtProductName.text.trim()).replaceAll('{productName}', edtProductName.text.trim());

                          await geminiDescriptionProvider
                              .generateDescription(content, context)
                              .then((onValue) {
                            if (geminiDescriptionProvider.state == GeminiGenerationState.loaded) {
                              setState(() {
                                htmlDescription = geminiDescriptionProvider.description.replaceAll(RegExp(r'^```html\n|```$'), '');
                                quillController.setText(htmlDescription);
                              });
                            } else {
                              showMessage(context, geminiDescriptionProvider.message, MessageType.error);
                            }
                          });
                          }
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsRes.appColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: geminiDescriptionProvider.state == GeminiGenerationState.loading
                        ? CustomTextLabel(
                            jsonKey: loadingLabel,
                            style: TextStyle(
                              color: ColorsRes.appColorWhite,
                            ),
                          )
                        : CustomTextLabel(
                            jsonKey: generateDescriptionWithAiLabel,
                            style: TextStyle(
                              color: ColorsRes.appColorWhite,
                            ),
                          ),
                    padding: EdgeInsetsDirectional.only(
                      top: 5,
                      bottom: 5,
                      start: 20,
                      end: 20,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        getSizedBox(
          height: 20,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width,
            minHeight: 65,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsetsDirectional.all(10),
                child: QuillHtmlEditor(
                  text: htmlDescription.isEmpty ? getTranslatedValue(context, descriptionGoesHereLabel) : htmlDescription,
                  hintText: getTranslatedValue(context, descriptionGoesHereLabel),
                  isEnabled: false,
                  ensureVisible: false,
                  minHeight: 10,
                  autoFocus: false,
                  textStyle: TextStyle(color: ColorsRes.mainTextColor),
                  hintTextStyle: TextStyle(color: ColorsRes.subTitleTextColor),
                  hintTextAlign: TextAlign.start,
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  hintTextPadding: const EdgeInsets.only(left: 20),
                  backgroundColor: Theme.of(context).cardColor,
                  inputAction: InputAction.newline,
                  loadingBuilder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorsRes.appColor,
                      ),
                    );
                  },
                  controller: quillController,
                ),
              ),
              PositionedDirectional(
                top: 0,
                end: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, htmlEditorScreen, arguments: htmlDescription).then(
                      (value) {
                        if (value != null) {
                          htmlDescription = value.toString().replaceAll(RegExp(r'^```html\n|```$'), '');
                          setState(
                            () {},
                          );
                        }
                      },
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: ColorsRes.appColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

// 2. PRODUCT IMAGE SCREEN
  Widget productImagesSelectionWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//Product Main Image
        Row(
          children: [
            CustomTitleTextLabel(
              jsonKey: productMainImageLabel,
            ),
            requiredFieldSign(),
          ],
        ),
        getSizedBox(
          height: 10,
        ),
        Row(
          children: [
            if (selectedProductMainImage.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorsRes.subTitleTextColor,
                    ),
                    color: Theme.of(context).cardColor),
                height: 105,
                width: 105,
                child: Center(
                  child: imgWidget(fileName: selectedProductMainImage, height: 90, width: 90),
                ),
              ),
            if (selectedProductMainImage.isEmpty && productMainImage.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorsRes.subTitleTextColor,
                    ),
                    color: Theme.of(context).cardColor),
                height: 105,
                width: 105,
                child: Center(
                  child: ClipRRect(
                    borderRadius: Constant.borderRadius10,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: setNetworkImg(
                      image: productMainImage.toString(),
                      width: 90,
                      height: 90,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            if (selectedProductMainImage.isNotEmpty || productMainImage.isNotEmpty) getSizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  hasStoragePermissionGiven().then((value) async {
                    if (value) {
// Single file path
                      /* FilePicker.platform
                          .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ["jpg", "jpeg", "png"],
                              allowMultiple: false,
                              allowCompression: true,
                              lockParentWindow: true)
                          .then(
                        (value) {
                          selectedProductMainImage =
                              value!.paths.first.toString();
                          setState(
                            () {},
                          );
                        },
                      ); */
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png'],
                      );

                      if (result != null && result.files.single.path != null) {
                        File pickedFile = File(result.files.single.path!);
                        print("Selected file path: ${pickedFile.path}");

                        // Check if file exists
                        if (!await pickedFile.exists()) {
                          print("File does not exist: ${pickedFile.path}");
                          return;
                        }

                        // Move file to a persistent location
                        File? savedFile = await saveFileToLocalStorage(pickedFile);

                        // Set state if valid
                        setState(() {
                          mainImage = savedFile;
                          selectedProductMainImage = savedFile!.path.toString();
                        });

                        print("File ready for upload: ${savedFile!.path}");
                      } else {
                        print("No file selected");
                      }
                    }
                  });
                },
                child: DottedBorder(
                  /* dashPattern: [5],
                  strokeWidth: 2,
                  strokeCap: StrokeCap.round,
                  color: ColorsRes.subTitleTextColor,
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect, */
                  options: RoundedRectDottedBorderOptions(
                    dashPattern: [5],
                    strokeWidth: 2,
                    radius: Radius.circular(10),
                    color: ColorsRes.subTitleTextColor,
                    // padding: EdgeInsets.all(16),
                  ),
                  child: Container(
                    height: 100,
                    color: ColorsRes.appColorTransparent,
                    padding: EdgeInsetsDirectional.all(10),
                    child: Center(
                      child: Column(
                        children: [
                          defaultImg(
                            image: AppAssets.uploadIcon,
                            iconColor: ColorsRes.subTitleTextColor,
                            height: 40,
                            width: 40,
                          ),
                          CustomTextLabel(
                            jsonKey: uploadImageHereLabel,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ColorsRes.subTitleTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        getSizedBox(
          height: 20,
        ),
//Product Other Image
        CustomTitleTextLabel(
          jsonKey: productOtherImagesLabel,
        ),
        getSizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
            hasStoragePermissionGiven().then((value) async {
              if (value) {
                // Single file path
                /* FilePicker.platform
                    .pickFiles(
                  allowMultiple: true,
                  allowCompression: true,
                  type: FileType.custom,
                  allowedExtensions: ["jpg", "jpeg", "png"],
                  lockParentWindow: true,
                )
                    .then(
                  (value) {
                    for (int i = 0; i < value!.files.length; i++) {
                      selectedProductOtherImages
                          .add(value.files[i].path.toString());
                    }
                    setState(
                      () {},
                    );
                  },
                ); */
                // Multiple file path
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg', 'png'],
                  allowMultiple: true, // Allow multiple selection
                );

                if (result != null) {
                  List<File> pickedFiles = result.paths.where((path) => path != null).map((path) => File(path!)).toList();

                  // Check if all files exist
                  for (var file in pickedFiles) {
                    if (!await file.exists()) {
                      print("File does not exist: ${file.path}");
                      return;
                    }
                  }

                  // Optionally save files to a persistent location
                  List<File> savedFiles = [];
                  for (var file in pickedFiles) {
                    File? savedFile = await saveFileToLocalStorage(file);
                    if (savedFile != null) {
                      savedFiles.add(savedFile);
                    }
                  }

                  // Update state
                  setState(() {
                    otherImage = savedFiles;
                    selectedProductOtherImages = savedFiles.map((file) => file.path).toList();
                  });

                  print("Selected files ready for upload:");
                  for (var file in otherImage!) {
                    print(file.path);
                  }
                } else {
                  print("No files selected");
                }
              }
            });
          },
          child: DottedBorder(
            /* dashPattern: [5],
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
            color: ColorsRes.subTitleTextColor,
            radius: Radius.circular(10),
            borderType: BorderType.RRect, */
            options: RoundedRectDottedBorderOptions(
              dashPattern: [5],
              strokeWidth: 2,
              radius: Radius.circular(10),
              color: ColorsRes.subTitleTextColor,
              // padding: EdgeInsets.all(16),
            ),
            child: Container(
              height: 100,
              color: ColorsRes.appColorTransparent,
              padding: EdgeInsetsDirectional.all(10),
              child: Center(
                child: Column(
                  children: [
                    defaultImg(
                      image: AppAssets.uploadIcon,
                      iconColor: ColorsRes.subTitleTextColor,
                      height: 40,
                      width: 40,
                    ),
                    CustomTextLabel(
                      jsonKey: uploadImagesHereLabel,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorsRes.subTitleTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (selectedProductOtherImages.isNotEmpty || productOtherImages.isNotEmpty)
          getSizedBox(
            height: 15,
          ),
        if (selectedProductOtherImages.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) => Wrap(
              runSpacing: 15,
              spacing: constraints.maxWidth * 0.05,
              children: List.generate(
                selectedProductOtherImages.length,
                (index) => Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorsRes.subTitleTextColor,
                          ),
                          color: Theme.of(context).cardColor),
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxWidth * 0.3,
                      child: Center(
                        child: imgWidget(fileName: selectedProductOtherImages[index], width: 105, height: 105),
                      ),
                    ),
                    PositionedDirectional(
                      end: -10,
                      top: -10,
                      child: IconButton(
                        onPressed: () {
                          selectedProductOtherImages.removeAt(index);
                          setState(() {});
                        },
                        icon: CircleAvatar(
                          backgroundColor: ColorsRes.appColorRed,
                          maxRadius: 10,
                          child: Icon(
                            Icons.close_rounded,
                            color: ColorsRes.appColorWhite,
                            size: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        if (selectedProductOtherImages.isEmpty && productOtherImages.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) => Wrap(
              runSpacing: 15,
              spacing: constraints.maxWidth * 0.05,
              children: List.generate(
                productOtherImages.length,
                (index) => Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorsRes.subTitleTextColor,
                          ),
                          color: Theme.of(context).cardColor),
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxWidth * 0.3,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: Constant.borderRadius10,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: setNetworkImg(
                            image: productOtherImages[index].imageUrl.toString(),
                            width: 110,
                            height: 110,
                            boxFit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      end: -10,
                      top: -10,
                      child: IconButton(
                        onPressed: () {
                          productDeletedOtherImages.add(productOtherImages[index].id.toString());
                          productOtherImages.removeAt(index);
                          setState(() {});
                        },
                        icon: CircleAvatar(
                          backgroundColor: ColorsRes.appColorRed,
                          maxRadius: 10,
                          child: Icon(
                            Icons.close_rounded,
                            color: ColorsRes.appColorWhite,
                            size: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget ItemSelectionWidget({
    required String labelJsonKey,
    required String labelJsonKeyHint,
    required VoidCallback voidCallback,
    required String selectedValue,
    required String selectedValueId,
    bool? titleRequired = true,
    bool? isFieldRequired,
    VoidCallback? voidCallbackForClearField,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleRequired == true)
          Row(
            children: [
              CustomTitleTextLabel(
                jsonKey: labelJsonKey,
              ),
              if (isFieldRequired == true) requiredFieldSign(),
            ],
          ),
        if (titleRequired == true)
          getSizedBox(
            height: 5,
          ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 10),
                  child: CustomTextLabel(
                    text: (selectedValue.isNotEmpty && selectedValueId.isNotEmpty) ? selectedValue : getTranslatedValue(context, labelJsonKeyHint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selectedValue.isNotEmpty ? ColorsRes.mainTextColor : ColorsRes.subTitleTextColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                onPressed: voidCallback,
                icon: Icon(
                  Icons.edit_rounded,
                  color: ColorsRes.subTitleTextColor,
                  size: 20,
                ),
              ),
              if (isFieldRequired != true)
                IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: voidCallbackForClearField ?? () {},
                  icon: Icon(
                    Icons.clear,
                    color: ColorsRes.subTitleTextColor,
                    size: 20,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

// 3. PRODUCT VARIANTS SCREEN
  Widget productVariantsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTitleTextLabel(
          jsonKey: productPackTypeLabel,
        ),
        getSizedBox(
          height: 5,
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    productPackType = ProductPackType.packet;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Radio<ProductPackType>(
                          value: productPackType,
                          groupValue: ProductPackType.packet,
                          onChanged: (value) {
                            productPackType = ProductPackType.packet;
                            setState(() {});
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: CustomTextLabel(
                          jsonKey: productPackTypePacketLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    productPackType = ProductPackType.loose;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Radio<ProductPackType>(
                          value: productPackType,
                          groupValue: ProductPackType.loose,
                          onChanged: (value) {
                            productPackType = ProductPackType.loose;
                            setState(() {});
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: CustomTextLabel(
                          jsonKey: productPackTypeLooseLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        getSizedBox(height: 15),
        CustomTitleTextLabel(
          jsonKey: productStockTypeLabel,
        ),
        getSizedBox(
          height: 5,
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    productStockType = ProductStockType.limited;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Radio<ProductStockType>(
                          value: productStockType,
                          groupValue: ProductStockType.limited,
                          onChanged: (value) {
                            productStockType = ProductStockType.limited;
                            setState(() {});
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: CustomTextLabel(
                          jsonKey: productStockTypeLimitedLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    productStockType = ProductStockType.unlimited;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Radio<ProductStockType>(
                          value: productStockType,
                          groupValue: ProductStockType.unlimited,
                          onChanged: (value) {
                            productStockType = ProductStockType.unlimited;
                            setState(() {});
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: CustomTextLabel(
                          jsonKey: productStockTypeUnlimitedLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        getSizedBox(
          height: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            variantsLength,
            (index) {
              return Container(
                margin: EdgeInsetsDirectional.only(bottom: 15),
                padding: EdgeInsetsDirectional.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsRes.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomTitleTextLabel(
                                    jsonKey: productMeasurementLabel,
                                  ),
                                  requiredFieldSign(),
                                ],
                              ),
                              getSizedBox(
                                height: 5,
                              ),
                              editBoxWidget(
                                maxlines: 1,
                                context: context,
                                edtController: edtProductVariantMeasurement[index],
                                validationFunction: (value)=> optionalFieldValidation(value!,  getTranslatedValue(context, enterProductMeasurementLabel)),
                                label: getTranslatedValue(context, productMeasurementLabel),
                                hint: getTranslatedValue(context, productMeasurementHintLabel),
                                bgcolor: Theme.of(context).cardColor,
                                inputType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (productPackType == ProductPackType.packet && productStockType == ProductStockType.limited)
                          getSizedBox(
                            width: 10,
                          ),
                        if (productPackType == ProductPackType.packet && productStockType == ProductStockType.limited)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomTitleTextLabel(
                                      jsonKey: productStockLabel,
                                    ),
                                    requiredFieldSign(),
                                  ],
                                ),
                                getSizedBox(
                                  height: 5,
                                ),
                                editBoxWidget(
                                  maxlines: 1,
                                  context: context,
                                  edtController: edtProductVariantStock[index],
                                  validationFunction: (value)=> optionalFieldValidation(value!,  getTranslatedValue(context, enterProductStockLabel)),
                                  label: getTranslatedValue(context, productStockLabel),
                                  hint: getTranslatedValue(context, productStockHintLabel),
                                  bgcolor: Theme.of(context).cardColor,
                                  inputType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, CustomNumberTextInputFormatter()],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    getSizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomTitleTextLabel(
                                    jsonKey: productPriceLabel,
                                  ),
                                  requiredFieldSign(),
                                ],
                              ),
                              getSizedBox(
                                height: 5,
                              ),
                              editBoxWidget(
                                maxlines: 1,
                                context: context,
                                edtController: edtProductVariantPrice[index],
                                validationFunction: (value)=> optionalFieldValidation(value!,  getTranslatedValue(context, enterProductPriceLabel)),
                                label: getTranslatedValue(context, productPriceLabel),
                                hint: getTranslatedValue(context, productPriceHintLabel),
                                bgcolor: Theme.of(context).cardColor,
                                inputType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        getSizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTitleTextLabel(
                                jsonKey: productDiscountPriceLabel,
                              ),
                              getSizedBox(
                                height: 5,
                              ),
                              editBoxWidget(
                                maxlines: 1,
                                context: context,
                                edtController: edtProductVariantDiscountedPrice[index],
                                validationFunction: (value)=> optionalFieldValidation("",  ""),
                                label: getTranslatedValue(context, productDiscountPriceLabel),
                                hint: getTranslatedValue(context, productDiscountPriceHintLabel),
                                bgcolor: Theme.of(context).cardColor,
                                inputType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d*'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    getSizedBox(
                      height: 15,
                    ),
                    if (productPackType == ProductPackType.packet)
                      Row(
                        children: [
                          Expanded(
                            child: ItemSelectionWidget(
                              labelJsonKey: measurementUnitsLabel,
                              labelJsonKeyHint: measurementUnitsHintLabel,
                              voidCallback: () {
                                Navigator.pushNamed(context, measurementUnitListScreen).then(
                                  (value) {
                                    if (value is MeasurementUnitData) {
                                      productVariantUnit[index] = "${value.shortCode}";
                                      productVariantUnitId[index] = "${value.id}";
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                              selectedValue: productVariantUnit[index],
                              selectedValueId: productVariantUnitId[index],
                              isFieldRequired: true,
                            ),
                          ),
                          getSizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ItemSelectionWidget(
                              labelJsonKey: productStockStatusLabel,
                              labelJsonKeyHint: productStockStatusHintLabel,
                              voidCallback: () {
                                Navigator.pushNamed(context, productStockStatusScreen).then(
                                  (value) {
                                    if (value is String) {
                                      productVariantStockStatus[index] = "${value}";
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                              selectedValue: productVariantStockStatus[index],
                              selectedValueId: "0",
                              isFieldRequired: true,
                            ),
                          ),
                        ],
                      ),
                    getSizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        if (variantsLength != 1)
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: CustomTextLabel(
                                      jsonKey: deleteVariantLabel,
                                    ),
                                    backgroundColor: Theme.of(context).cardColor,
                                    surfaceTintColor: ColorsRes.appColorTransparent,
                                    content: CustomTextLabel(
                                      jsonKey: areYouSureYouWantToDeleteVariantMessageLabel,
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
                                          style: TextStyle(color: ColorsRes.subTitleTextColor, fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      getSizedBox(width: 10),
                                      ChangeNotifierProvider(
                                        create: (context) => DeleteProductProvider(),
                                        child: Consumer<DeleteProductProvider>(
                                          builder: (context, deleteProductProvider, child) {
                                            return GestureDetector(
                                              onTap: () async {
                                                /* await deleteProductProvider.deleteProducts(
                                                    params: {"id": variantsList[index].id.toString()}, context: context, from: "update_product").then(
                                                  (value) {
                                                    if (value != null) {
                                                      Navigator.pop(context);
                                                      removeVariant(index);
                                                      variantsLength--;
                                                      setState(() {});
                                                    }
                                                  },
                                                ); */
                                                if (widget.from == "update") {
                                                  await deleteProductProvider.deleteProducts(
                                                    params: {"id": variantsList[index].id.toString()},
                                                    context: context,
                                                    from: "update_product",
                                                  ).then((value) {
                                                    if (value != null) {
                                                      Navigator.pop(context);
                                                      removeVariant(index);
                                                      variantsLength--;
                                                      setState(() {});
                                                    }
                                                  });
                                                } else {
                                                  Navigator.pop(context);
                                                  removeVariant(index);
                                                  variantsLength--;
                                                  setState(() {});
                                                }
                                              },
                                              child: deleteProductProvider.sellerProductDeleteState == SellerDeleteProductState.loading
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
                              decoration: BoxDecoration(
                                color: ColorsRes.appColorRed,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_forever_rounded,
                                    weight: 5,
                                    color: ColorsRes.appColorWhite,
                                    size: 20,
                                  ),
                                  getSizedBox(width: 5),
                                  CustomTextLabel(
                                    jsonKey: removeLabel,
                                    style: TextStyle(
                                      color: ColorsRes.appColorWhite,
                                    ),
                                  ),
                                ],
                              ),
                              padding: EdgeInsetsDirectional.only(
                                top: 5,
                                bottom: 5,
                                start: 20,
                                end: 20,
                              ),
                            ),
                          ),
                        if (variantsLength != 1)
                          getSizedBox(
                            width: 10,
                          ),
                        if (variantsLength - 1 == index)
                          GestureDetector(
                            onTap: () {
                              addNewVariant();
                              variantsLength++;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorsRes.appColorGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_rounded,
                                    weight: 5,
                                    color: ColorsRes.appColorWhite,
                                    size: 20,
                                  ),
                                  getSizedBox(width: 5),
                                  CustomTextLabel(
                                    jsonKey: addLabel,
                                    style: TextStyle(
                                      color: ColorsRes.appColorWhite,
                                    ),
                                  ),
                                ],
                              ),
                              padding: EdgeInsetsDirectional.only(
                                top: 5,
                                bottom: 5,
                                start: 20,
                                end: 20,
                              ),
                            ),
                          ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        getSizedBox(
          height: 15,
        ),
        if (productPackType == ProductPackType.loose && productStockType == ProductStockType.limited)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomTextLabel(
                    jsonKey: productStockLabel,
                  ),
                  requiredFieldSign(),
                ],
              ),
              getSizedBox(
                height: 5,
              ),
              editBoxWidget(
                maxlines: 1,
                context: context,
                edtController: edtProductStock,
                validationFunction: (value)=> optionalFieldValidation(value!,  getTranslatedValue(context, enterProductStockLabel)),
                label: getTranslatedValue(context, productStockLabel),
                hint: getTranslatedValue(context, productStockHintLabel),
                bgcolor: Theme.of(context).cardColor,
                inputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, CustomNumberTextInputFormatter()],
              ),
            ],
          ),
        if (productPackType == ProductPackType.loose)
          getSizedBox(
            height: 15,
          ),
        if (productPackType == ProductPackType.loose)
          Row(
            children: [
              Expanded(
                child: ItemSelectionWidget(
                  labelJsonKey: productUnitLabel,
                  labelJsonKeyHint: productUnitHintLabel,
                  voidCallback: () {
                    Navigator.pushNamed(context, measurementUnitListScreen).then(
                      (value) {
                        if (value is MeasurementUnitData) {
                          productMainUnit = "${value.shortCode}";
                          productMainUnitId = "${value.id}";
                          setState(() {});
                        }
                      },
                    );
                  },
                  selectedValue: productMainUnit,
                  selectedValueId: productMainUnitId,
                  isFieldRequired: true,
                ),
              ),
              getSizedBox(
                width: 10,
              ),
              Expanded(
                child: ItemSelectionWidget(
                  labelJsonKey: productStockStatusLabel,
                  labelJsonKeyHint: productStockStatusHintLabel,
                  voidCallback: () {
                    Navigator.pushNamed(context, productStockStatusScreen).then(
                      (value) {
                        if (value is String) {
                          productMainStockStatus = "${value}";
                          setState(() {});
                        }
                      },
                    );
                  },
                  selectedValue: productMainStockStatus,
                  selectedValueId: "0",
                  isFieldRequired: true,
                ),
              ),
            ],
          ),
      ],
    );
  }

// 4. PRODUCT OTHER SETTING SCREEN VALIDATION
  Widget productOtherSettingsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTitleTextLabel(
          jsonKey: isReturnableLabel,
        ),
        getSizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        returnable = Returnable.no;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Radio<Returnable>(
                            value: returnable,
                            groupValue: Returnable.no,
                            onChanged: (value) {
                              returnable = Returnable.no;
                              setState(() {});
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                          CustomTextLabel(
                            jsonKey: noLabel,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        returnable = Returnable.yes;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Radio<Returnable>(
                            value: returnable,
                            groupValue: Returnable.yes,
                            onChanged: (value) {
                              returnable = Returnable.yes;
                              setState(() {});
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                          CustomTextLabel(
                            jsonKey: yesLabel,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            getSizedBox(width: 10),
            Expanded(
              child: editBoxWidget(
                maxlines: 1,
                context: context,
                isEditable: returnable == Returnable.yes,
                edtController: edtProductReturnDays,
                validationFunction: (value)=> optionalFieldValidation(value!,  getTranslatedValue(context, enterReturnDaysLabel)),
                label: getTranslatedValue(context, returnDaysLabel),
                hint: getTranslatedValue(context, returnDaysHintLabel),
                bgcolor: Theme.of(context).cardColor,
                inputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, CustomNumberTextInputFormatter()],
              ),
            )
          ],
        ),
        getSizedBox(
          height: 15,
        ),
        CustomTitleTextLabel(
          jsonKey: isCancellableLabel,
        ),
        getSizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        cancellable = Cancellable.no;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Radio<Cancellable>(
                            value: cancellable,
                            groupValue: Cancellable.no,
                            onChanged: (value) {
                              cancellable = Cancellable.no;
                              setState(() {});
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                          CustomTextLabel(
                            jsonKey: noLabel,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cancellable = Cancellable.yes;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Radio<Cancellable>(
                            value: cancellable,
                            groupValue: Cancellable.yes,
                            onChanged: (value) {
                              cancellable = Cancellable.yes;
                              setState(() {});
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                          CustomTextLabel(
                            jsonKey: yesLabel,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            getSizedBox(width: 10),
            Expanded(
              child: ItemSelectionWidget(
                labelJsonKey: tillWhichStatusLabel,
                labelJsonKeyHint: tillWhichStatusHintLabel,
                selectedValue: productCancellableStatus,
                selectedValueId: productCancellableStatusId,
                titleRequired: false,
                isFieldRequired: true,
                voidCallback: () {
                  if (cancellable == Cancellable.yes) {
                    Navigator.pushNamed(context, statusesListScreen).then(
                      (value) {
                        if (value is OrderStatusesData) {
                          productCancellableStatus = "${value.status}";
                          productCancellableStatusId = "${value.id}";
                          setState(() {});
                        }
                      },
                    );
                  } else {
                    showMessage(context, getTranslatedValue(context, selectCancellableYesFirstLabel), MessageType.error);
                  }
                },
              ),
            ),
          ],
        ),
        getSizedBox(
          height: 15,
        ),
        CustomTitleTextLabel(
          jsonKey: totalAllowedQuantityLabel,
        ),
        getSizedBox(
          height: 5,
        ),
        editBoxWidget(
          maxlines: 1,
          context: context,
          edtController: edtProductTotalAllowedQuantity,
          validationFunction: (value)=> optionalFieldValidation(value!,  getTranslatedValue(context, enterTotalAllowedQuantityLabel)),
          label: getTranslatedValue(context, totalAllowedQuantityLabel),
          hint: getTranslatedValue(context, totalAllowedQuantityHintLabel),
          bgcolor: Theme.of(context).cardColor,
          inputType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, CustomNumberTextInputFormatter()],
        ),
        getSizedBox(
          height: 15,
        ),
        CustomTitleTextLabel(
          jsonKey: isCodAllowLabel,
        ),
        getSizedBox(
          height: 5,
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  isCodAllowed = IsCodAllowed.no;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Radio<IsCodAllowed>(
                      value: isCodAllowed,
                      groupValue: IsCodAllowed.no,
                      onChanged: (value) {
                        isCodAllowed = IsCodAllowed.no;
                        setState(() {});
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    CustomTextLabel(
                      jsonKey: noLabel,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  isCodAllowed = IsCodAllowed.yes;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Radio<IsCodAllowed>(
                      value: isCodAllowed,
                      groupValue: IsCodAllowed.yes,
                      onChanged: (value) {
                        isCodAllowed = IsCodAllowed.yes;
                        setState(() {});
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    CustomTextLabel(
                      jsonKey: yesLabel,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pageChangeValidation(int currentPage) {
    switch (currentPage) {
      case 0:
        // 1. PRODUCT INFO SCREEN VALIDATION
        productInfoValidation();
      case 1:
        // 2. PRODUCT IMAGE SCREEN VALIDATION
        productImageValidation();
      case 2:
        // 3. PRODUCT VARIANT SCREEN VALIDATION
        productVariantValidation();
      case 3:
        // 4. PRODUCT OTHER SETTING SCREEN VALIDATION
        productOtherSettingsValidation();
      default:
        showMessage(context, somethingWentWrongLabel, MessageType.error);
    }
  }

  // 1. PRODUCT INFO SCREEN VALIDATION
  void productInfoValidation() async {
    try {
      if (edtProductName.text.isEmpty) {
        showMessage(context, getTranslatedValue(context, productNameValidationMessageLabel), MessageType.error);
      } else if (productCategory.isEmpty) {
        showMessage(context, getTranslatedValue(context, productCategoryValidationMessageLabel), MessageType.error);
      } else if (htmlDescription.isEmpty) {
        showMessage(context, getTranslatedValue(context, productDescriptionValidationMessageLabel), MessageType.error);
      } else if (edtProductFssaiNumber.text.isNotEmpty && edtProductFssaiNumber.text.length != 14) {
        showMessage(context, getTranslatedValue(context, productFssaiValidationMessageLabel), MessageType.error);
      } else {
        currentPage++;
        pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    } catch (e) {
      showMessage(context, e.toString(), MessageType.error);
    }
  }

  // 2. PRODUCT IMAGE SCREEN VALIDATION
  void productImageValidation() async {
    try {
      if (selectedProductMainImage.isEmpty && (widget.productId.isEmpty || widget.from == "duplicate")) {
        showMessage(context, getTranslatedValue(context, productMainImageValidationMessageLabel), MessageType.error);
      } else {
        currentPage++;
        pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    } catch (e) {
      showMessage(context, e.toString(), MessageType.error);
    }
  }

  // 3. PRODUCT VARIANTS SCREEN VALIDATION
  void productVariantValidation() async {
    try {
      await allVariantFieldsValidation().then((value) {
        if (value == true) {
          if (productPackType == ProductPackType.loose && productStockType == ProductStockType.limited && edtProductStock.text.isEmpty) {
            showMessage(context, getTranslatedValue(context, stockEmptyValidationMessageLabel), MessageType.error);
          } else if (productPackType == ProductPackType.loose && productMainUnitId.isEmpty) {
            showMessage(context, getTranslatedValue(context, measurementUnitValidationMessageLabel), MessageType.error);
          } else if (productPackType == ProductPackType.loose && productMainStockStatus.isEmpty) {
            showMessage(context, getTranslatedValue(context, stockStatusValidationMessageLabel), MessageType.error);
          } else {
            currentPage++;
            pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.ease);
          }
        }
      });
    } catch (e) {
      showMessage(context, e.toString(), MessageType.error);
    }
  }

  Future<bool> allVariantFieldsValidation() async {
    for (int index = 0; index < variantsLength; index++) {
      if (edtProductVariantMeasurement[index].text.isEmpty) {
        showMessage(
            context,
            "${getTranslatedValue(context, inVariantLabel)} ${index + 1} ${getTranslatedValue(context, variantMeasurementEmptyValidationMessageLabel)}",
            MessageType.error);
        return false;
      } else if (edtProductVariantMeasurement[index].text.toDouble! <= 0.0) {
        showMessage(
            context,
            "${getTranslatedValue(context, inVariantLabel)} ${index + 1} ${getTranslatedValue(context, variantMeasurementZeroValidationMessageLabel)}",
            MessageType.error);
        return false;
      } else if (productPackType == ProductPackType.packet &&
          productStockType == ProductStockType.limited &&
          edtProductVariantStock[index].text.isEmpty) {
        showMessage(
            context,
            "${getTranslatedValue(context, inVariantLabel)} ${index + 1} ${getTranslatedValue(context, variantStockZeroValidationMessageLabel)}",
            MessageType.error);
        return false;
      } else if (productPackType == ProductPackType.packet &&
          productStockType == ProductStockType.limited &&
          edtProductVariantStock[index].text.toDouble! <= 0.0) {
        showMessage(
            context,
            "${getTranslatedValue(context, inVariantLabel)} ${index + 1} ${getTranslatedValue(context, variantStockEmptyValidationMessageLabel)}",
            MessageType.error);
        return false;
      } else if (edtProductVariantPrice[index].text.isEmpty) {
        showMessage(
            context,
            "${getTranslatedValue(context, inVariantLabel)} ${index + 1} ${getTranslatedValue(context, variantPriceEmptyValidationMessageLabel)}",
            MessageType.error);
        return false;
      } else if (edtProductVariantPrice[index].text.toDouble! <= 0.0) {
        showMessage(
            context, "${getTranslatedValue(context, inVariantLabel)} ${index + 1} $variantPriceEmptyValidationMessageLabel", MessageType.error);
        return false;
      } else if (edtProductVariantDiscountedPrice[index].text.isNotEmpty &&
          (edtProductVariantDiscountedPrice[index].text.toString().toDouble! >= edtProductVariantPrice[index].text.toString().toDouble!)) {
        showMessage(
            context,
            "${getTranslatedValue(context, inVariantLabel)} ${index + 1} ${getTranslatedValue(context, variantDiscountedPriceAndPriceValidationMessageLabel)}",
            MessageType.error);
        return false;
      } else if (productPackType == ProductPackType.packet && productVariantUnitId[index].isEmpty) {
        showMessage(
            context,
            "${getTranslatedValue(context, inVariantLabel)} ${index + 1} ${getTranslatedValue(context, variantMeasurementUnitEmptyValidationMessageLabel)}",
            MessageType.error);
        return false;
      } else if (productPackType == ProductPackType.packet && productVariantStockStatus[index].isEmpty) {
        showMessage(
            context,
            "${getTranslatedValue(context, inVariantLabel)} ${index + 1} ${getTranslatedValue(context, variantStockStatusEmptyValidationMessageLabel)}",
            MessageType.error);
        return false;
      }
    }
    return true;
  }

  // 4. PRODUCT IMAGE SCREEN VALIDATION
  void productOtherSettingsValidation() async {
    try {
      if (cancellable == Cancellable.yes && productCancellableStatusId.isEmpty) {
        showMessage(context, getTranslatedValue(context, productCancelableStatusSelectionValidationMessageLabel), MessageType.error);
      } else if (returnable == Returnable.yes && edtProductReturnDays.text.isEmpty) {
        showMessage(context, getTranslatedValue(context, productReturnableStatusSelectionValidationMessageLabel), MessageType.error);
      } else {
        backendApiProcess();
      }
    } catch (e) {
      showMessage(context, e.toString(), MessageType.error);
    }
  }

  imgWidget({required String fileName, double? height, double? width}) {
    return GestureDetector(
      onTap: () {
        try {
          OpenFilex.open(fileName);
        } catch (e) {
          showMessage(context, e.toString(), MessageType.error);
        }
      },
      child: fileName.split(".").last == "pdf"
          ? Center(
              child: defaultImg(
                image: AppAssets.pdfIcon,
                height: 50,
                width: 50,
              ),
            )
          : ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.file(
                File(fileName),
                width: width ?? 90,
                height: height ?? 90,
                fit: BoxFit.fill,
              ),
            ),
    );
  }

  Widget requiredFieldSign() {
    return CustomTextLabel(
      text: " * ",
      style: TextStyle(color: ColorsRes.appColorRed, fontWeight: FontWeight.bold),
    );
  }

  Widget toolTipSign() {
    return Tooltip(
      message: getTranslatedValue(context, schemaMarkupInfoLabel),
      child: Icon(Icons.info, color: ColorsRes.mainTextColor.withValues(alpha: 0.8)),
    );
  }

  Widget CustomTitleTextLabel({required String jsonKey}) {
    return CustomTextLabel(
      jsonKey: jsonKey,
      style: TextStyle(
        color: ColorsRes.mainTextColor.withValues(alpha: 0.8),
      ),
    );
  }
}
