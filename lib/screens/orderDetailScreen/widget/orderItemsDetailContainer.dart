import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/orderDetail.dart';

getOrderItemDetailsContainer(
    {required BuildContext context, OrderItems? orderItem}) {
  double price = double.parse(orderItem?.price ?? "0.0");
  double? discountedPrice = double.parse(orderItem?.discountedPrice ?? "0.0");
  return Container(
    padding: EdgeInsets.all(Constant.paddingOrMargin10),
    margin: EdgeInsetsDirectional.only(
      bottom: Constant.paddingOrMargin10,
    ),
    decoration: DesignConfig.boxDecoration(
      Theme.of(context).cardColor,
      10,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextLabel(
          text: "${orderItem?.productName} (${orderItem?.variantName})",
          softWrap: true,
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontSize: 15,
          ),
        ),
        getSizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: setNetworkImg(
                  image: orderItem?.image.toString() ?? "",
                  width: context.width * 0.22,
                  height: context.width * 0.22,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
            getSizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  getOrderDetailContainer(
                      title: getTranslatedValue(context, quantityLabel),
                      value: orderItem?.quantity.toString() ?? "1"),
                  getSizedBox(
                    height: 5,
                  ),
                  getOrderDetailContainer(
                    title: getTranslatedValue(context, priceLabel),
                    value: getCurrencyFormat(discountedPrice.compareTo(0.0) == 0
                        ? price
                        : discountedPrice),
                  ),
                  getSizedBox(
                    height: 5,
                  ),
                  getOrderDetailContainer(
                    title: getTranslatedValue(context, taxLabel),
                    value: "${getCurrencyFormat(
                      (double.parse(orderItem?.taxAmount ?? "0.0")) *
                          (double.parse(orderItem?.quantity ?? "1")),
                    )} (Qty x ${orderItem?.taxPercentage ?? 0.0}% Tax)",
                  ),
                  getSizedBox(
                    height: 5,
                  ),
                  getOrderDetailContainer(
                    title: getTranslatedValue(context, subtotalLabel),
                    value: getCurrencyFormat(
                        double.parse(orderItem?.subTotal ?? "0.0")),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}
