import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

getOrderStatusContainer({
  required BuildContext context,
  required String svgIconName,
  required String title,
  required bool isActive,
}) {
  return Container(
    height: 45,
    decoration: BoxDecoration(
      color: isActive ? ColorsRes.appColor : Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsetsDirectional.only(start: 10, bottom: 10, top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getSizedBox(width: 10),
        defaultImg(
            image: svgIconName,
            iconColor:
                isActive ? ColorsRes.appColorWhite : ColorsRes.mainTextColor,
            width: 20,
            height: 20),
        getSizedBox(width: 10),
        CustomTextLabel(
          text: title,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              color:
                  isActive ? ColorsRes.appColorWhite : ColorsRes.mainTextColor,
              fontWeight: FontWeight.w400),
        ),
        getSizedBox(width: 10),
      ],
    ),
  );
}
