import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/productList.dart';
import 'package:project/provider/selectedVariantItemProvider.dart';

class ProductListItemContainer extends StatefulWidget {
  final ProductListItem product;
  final VoidCallback deleteVoidCallBack;
  final VoidCallback editVoidCallBack;
  final VoidCallback duplicateVoidCallBack;

  const ProductListItemContainer(
      {Key? key, required this.product, required this.deleteVoidCallBack, required this.editVoidCallBack, required this.duplicateVoidCallBack})
      : super(key: key);

  @override
  State<ProductListItemContainer> createState() => _State();
}

class _State extends State<ProductListItemContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductListItem product = widget.product;
    List<Variants> variants = product.variants!;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: 10,
        start: 10,
        end: 10,
      ),
      child: variants.length > 0
          ? Container(
              alignment: AlignmentDirectional.center,
              decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: Constant.borderRadius10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: setNetworkImg(
                          boxFit: BoxFit.fill,
                          image: product.imageUrl.toString(),
                          height: 130,
                          width: 130,
                        ),
                      ),
                      if (product.variants?[0].status.toString() == "0" ||
                          product.variants?[0].isUnlimitedStock == "0" && product.variants?[0].stock.toString() == "0")
                        PositionedDirectional(
                          top: 0,
                          end: 0,
                          start: 0,
                          bottom: 0,
                          child: getOutOfStockWidget(
                            height: 125,
                            width: 125,
                            textSize: 15,
                            context: context,
                          ),
                        ),
                    ],
                  ),/* 
                  if (product.variants?[0].status.toString() == "0" ||
                      product.variants?[0].isUnlimitedStock == "0" && product.variants?[0].stock.toString() == "0")
                    PositionedDirectional(
                      top: 0,
                      end: 0,
                      start: 0,
                      bottom: 0,
                      child: getOutOfStockWidget(
                        height: 125,
                        width: 125,
                        textSize: 15,
                        context: context,
                      ),
                    ), */
                  /* PositionedDirectional(
                    bottom: 5,
                    end: 5,
                    child: Column(
                      children: [
                        if (product.indicator == 1) defaultImg(height: 24, width: 24, image: AppAssets.vegIndicatorIcon),
                        if (product.indicator == 2)
                          defaultImg(
                            height: 24,
                            width: 24,
                            image: AppAssets.nonVegIndicatorIcon,
                          ),
                      ],
                    ),
                  ), */
                  /* Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          if (product.indicator == "1") defaultImg(height: 15, width: 15, image: AppAssets.vegIndicatorIcon),
                          if (product.indicator == "2")
                            defaultImg(
                              height: 15,
                              width: 15,
                              image: AppAssets.nonVegIndicatorIcon,
                            ),
                        ],
                      ),
                    ),
                  ), */

                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 10, end: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getSizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5, top: /* 1 */0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      if (product.indicator == "1") defaultImg(height: 15, width: 15, image: AppAssets.vegIndicatorIcon),
                                      if (product.indicator == "2")
                                        defaultImg(
                                          height: 15,
                                          width: 15,
                                          image: AppAssets.nonVegIndicatorIcon,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CustomTextLabel(
                                  text: product.name.toString(),
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          getSizedBox(
                            height: 5,
                          ),
                          Consumer<SelectedVariantItemProvider>(
                            builder: (context, selectedVariantItemProvider, _) {
                              return widget.product.variants!.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(end: 5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              CustomTextLabel(
                                                text: double.parse(widget
                                                            .product.variants![selectedVariantItemProvider.getSelectedIndex()].discountedPrice
                                                            .toString()) !=
                                                        0
                                                    ? widget.product.variants![selectedVariantItemProvider.getSelectedIndex()].discountedPrice
                                                        .toString()
                                                        .currency
                                                    : widget.product.variants![selectedVariantItemProvider.getSelectedIndex()].price
                                                        .toString()
                                                        .currency,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 15, color: ColorsRes.appColor, fontWeight: FontWeight.w500),
                                              ),
                                              getSizedBox(width: 5),
                                              RichText(
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.clip,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorsRes.grey,
                                                          decoration: TextDecoration.lineThrough,
                                                          decorationThickness: 2),
                                                      text: double.parse(widget.product.variants![0].discountedPrice.toString()) != 0
                                                          ? widget.product.variants![0].price.toString().currency
                                                          : "",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        getSizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: widget.product.variants!.length > 1 ? widget.deleteVoidCallBack : () {},
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsetsDirectional.only(end: 10),
                                                        decoration: BoxDecoration(
                                                          borderRadius: Constant.borderRadius5,
                                                          color: Theme.of(context).scaffoldBackgroundColor,
                                                        ),
                                                        child: Container(
                                                          padding: widget.product.variants!.length > 1 ? EdgeInsets.zero : EdgeInsets.all(5),
                                                          alignment: AlignmentDirectional.center,
                                                          height: 35,
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              if (widget.product.variants!.length > 1) Spacer(),
                                                              Expanded(
                                                                child: CustomTextLabel(
                                                                  text:
                                                                      "${widget.product.variants![0].measurement} ${widget.product.variants![0].stockUnitName}",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: ColorsRes.mainTextColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              if (widget.product.variants!.length > 1) Spacer(),
                                                              if (widget.product.variants!.length > 1)
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                                                                  child: defaultImg(
                                                                    image: AppAssets.dropDownIcon,
                                                                    height: 10,
                                                                    width: 10,
                                                                    boxFit: BoxFit.cover,
                                                                    iconColor: ColorsRes.mainTextColor,
                                                                  ),
                                                                ),
                                                              if (widget.product.variants!.length > 1) Spacer(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextLabel(
                                                        text:
                                                            "${getTranslatedValue(context, stockLabel)} : ${widget.product.variants![0].isUnlimitedStock == "1" ? getTranslatedValue(context, unlimitedLabel) : widget.product.variants![0].stock}${widget.product.variants![0].isUnlimitedStock == "1" ? "" : " ${widget.product.variants![0].stockUnitName}"}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorsRes.mainTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                          getSizedBox(
                            height: 5,
                          ),
                          CustomTextLabel(
                            jsonKey: product.isApproved.toString() == "1" ? approvedLabel : notApprovedLabel,
                            style: TextStyle(
                              color: product.isApproved.toString() == "1" ? ColorsRes.appColorGreen : ColorsRes.appColorRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  getSizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      getSizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ratingAndReviewScreen, arguments: product.id.toString());
                        },
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 24,
                          width: 24,
                          padding: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: ColorsRes.appColorAmber,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.star,
                            color: ColorsRes.appColorWhite,
                            size: 17,
                          ),
                        ),
                      ),
                      getSizedBox(height: 5),
                      GestureDetector(
                        onTap: widget.editVoidCallBack,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 24,
                          width: 24,
                          padding: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: ColorsRes.appColorGreen,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: ColorsRes.appColorWhite,
                            size: 17,
                          ),
                        ),
                      ),
                      getSizedBox(height: 5),
                      GestureDetector(
                        onTap: widget.duplicateVoidCallBack,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 24,
                          width: 24,
                          padding: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: ColorsRes.appColorOrange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.copy,
                            color: ColorsRes.appColorWhite,
                            size: 17,
                          ),
                        ),
                      ),
                      getSizedBox(height: 5),
                      GestureDetector(
                        onTap: widget.deleteVoidCallBack,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 24,
                          width: 24,
                          padding: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: ColorsRes.appColorRed,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.delete_forever_rounded,
                            color: ColorsRes.appColorWhite,
                            size: 17,
                          ),
                        ),
                      ),
                      getSizedBox(height: 5),
                    ],
                  ),
                  getSizedBox(
                    width: 10,
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
