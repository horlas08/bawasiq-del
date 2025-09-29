import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

Widget getOrderDetailContainer({
  required String title,
  required String value,
  int? titleFlex,
  int? valueFlex,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  final hasFlex = titleFlex != null && valueFlex != null;

  return Row(
    crossAxisAlignment: crossAxisAlignment,
    children: [
      if (hasFlex)
        Expanded(
          flex: titleFlex,
          child: CustomTextLabel(
            text: title,
            softWrap: true,
            style: TextStyle(color: ColorsRes.grey),
          ),
        )
      else
        CustomTextLabel(
          text: title,
          softWrap: true,
          style: TextStyle(color: ColorsRes.grey),
        ),
      getSizedBox(width: 10),
      Expanded(
        flex: hasFlex ? valueFlex : 1,
        child: CustomTextLabel(
          text: value,
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
    ],
  );
}
