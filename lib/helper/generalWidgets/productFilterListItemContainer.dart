import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/filterProducts.dart';

class ProductFilterListItemContainer extends StatefulWidget {
  final FilterProductsDataProducts product;
  final VoidCallback deleteVoidCallBack;
  final VoidCallback editVoidCallBack;

  const ProductFilterListItemContainer(
      {Key? key,
      required this.product,
      required this.deleteVoidCallBack,
      required this.editVoidCallBack})
      : super(key: key);

  @override
  State<ProductFilterListItemContainer> createState() => _State();
}

class _State extends State<ProductFilterListItemContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FilterProductsDataProducts product = widget.product;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          bottom: 5, start: 10, end: 10, top: 5),
      child: Container(
        decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: Constant.borderRadius10,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: setNetworkImg(
                    boxFit: BoxFit.fill,
                    image: product.image.toString(),
                    height: 125,
                    width: 125,
                  ),
                ),
                if (product.isUnlimitedStock == "0" &&
                    (product.status.toString() == "0" ||
                        product.stock.toString() == "0"))
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
                PositionedDirectional(
                  bottom: 5,
                  end: 5,
                  child: Column(
                    children: [
                      if (product.indicator == 1)
                        defaultImg(
                            height: 24, width: 24, image: AppAssets.vegIndicatorIcon),
                      if (product.indicator == 2)
                        defaultImg(
                          height: 24,
                          width: 24,
                          image: AppAssets.nonVegIndicatorIcon,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getSizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
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
                        getSizedBox(width: 10),
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
                        getSizedBox(width: 10),
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
                      ],
                    ),
                    getSizedBox(
                      height: 10,
                    ),
                    Column(
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
                                            .product.discountedPrice
                                            .toString()) !=
                                        0
                                    ? widget.product.discountedPrice
                                        .toString()
                                        .currency
                                    : widget.product.price.toString().currency,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ColorsRes.appColor,
                                    fontWeight: FontWeight.w500),
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
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationThickness: 2),
                                      text: double.parse(widget
                                                  .product.discountedPrice
                                                  .toString()) !=
                                              0
                                          ? widget.product.price
                                              .toString()
                                              .currency
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
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin:
                                            EdgeInsetsDirectional.only(end: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: Constant.borderRadius5,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          alignment:
                                              AlignmentDirectional.center,
                                          height: 35,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomTextLabel(
                                                text:
                                                    "${product.measurement} ${product.stockUnit}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      ColorsRes.mainTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomTextLabel(
                                        text:
                                            "${getTranslatedValue(context, stockLabel)} : ${product.isUnlimitedStock == "1" ? getTranslatedValue(context, unlimitedLabel) : product.stock}${product.isUnlimitedStock == "1" ? "" : " ${product.stockUnit}"}",
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
