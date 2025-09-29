import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/helper/utils/generalImports.dart';

class ProductStockItemContainer extends StatefulWidget {
  final ProductsStockManagementData product;

  const ProductStockItemContainer({super.key, required this.product});

  @override
  State<ProductStockItemContainer> createState() =>
      _ProductStockItemContainerState();
}

class _ProductStockItemContainerState extends State<ProductStockItemContainer> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  bool editable = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.product.stock);
    focusNode = FocusNode(); // No skipTraversal
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsetsDirectional.only(bottom: 10, start: 10, end: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: setNetworkImg(
                  image: widget.product.imageUrl.toString(),
                  height: 80,
                  width: 80,
                  boxFit: BoxFit.cover,
                ),
              ),
              getSizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextLabel(
                      text:
                          "${widget.product.name.toString()} (${widget.product.type.toString().toLowerCase() == "packet" ? getTranslatedValue(context, productPackTypePacketLabel) : getTranslatedValue(context, productPackTypeLooseLabel)})",
                      softWrap: true,
                      style: TextStyle(
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    CustomTextLabel(
                      text:
                          "${widget.product.measurement.toString()} ${widget.product.shortCode.toString()}",
                      softWrap: true,
                      style: TextStyle(
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    getSizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            style: TextStyle(
                              color: editable
                                  ? ColorsRes.mainTextColor
                                  : ColorsRes.subTitleTextColor,
                            ),
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsetsDirectional.only(
                                  start: 10, end: 10, top: 3, bottom: 3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: ColorsRes.grey.withValues(alpha: 0.5),
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: ColorsRes.grey.withValues(alpha: 0.5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: ColorsRes.appColor,
                                ),
                              ),
                              isCollapsed: true,
                              enabled: editable,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CustomNumberTextInputFormatter(),
                            ],
                          ),
                        ),
                        getSizedBox(width: 10),
                        Consumer<ProductStockUpdateProvider>(
                          builder: (_, productStockUpdateProvider, __) {
                            return GestureDetector(
                              onTap: () {
                                editable = !editable;
                                if (editable) {
                                  Future.delayed(Duration(milliseconds: 50),
                                      () {
                                    FocusScope.of(context)
                                        .requestFocus(focusNode);
                                  });
                                } else {
                                  focusNode
                                      .unfocus(); // Unfocus if no longer editable
                                }
                                if (!editable) {
                                  if (textEditingController.text.length > 9) {
                                    showMessage(
                                        context,
                                        stockCannotBeMoreThan9DigitsLabel,
                                        MessageType.error);
                                    textEditingController.text =
                                        widget.product.stock.toString();
                                  } else {
                                    productStockUpdateProvider
                                        .updateProductStockProvider(
                                      context: context,
                                      params: {
                                        ApiAndParams.id: widget
                                            .product.productVariantId
                                            .toString(),
                                        ApiAndParams.stock:
                                            textEditingController.text
                                                .toString(),
                                      },
                                    );
                                  }
                                }
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ColorsRes.appColorLightHalfTransparent,
                                ),
                                padding: EdgeInsets.all(5),
                                child: !editable
                                    ? productStockUpdateProvider
                                                .changeStockState ==
                                            ChangeStockState.loading
                                        ? Container(
                                            padding: EdgeInsets.all(5),
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: ColorsRes.appColor,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Icon(
                                            Icons.edit_rounded,
                                            color: ColorsRes.appColor,
                                            size: 20,
                                          )
                                    : Icon(
                                        Icons.check,
                                        color: ColorsRes.appColor,
                                        size: 20,
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}