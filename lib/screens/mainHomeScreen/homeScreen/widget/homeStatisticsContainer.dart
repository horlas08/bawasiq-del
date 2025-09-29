import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

Widget getStatisticsContainer(
    {required BuildContext context,
    required String svgIconName,
    required Color bgColor,
    required String title,
    required String itemCount,
    VoidCallback? voidCallback}) {
  return GestureDetector(
    onTap: voidCallback ?? () {},
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: ColorsRes.appColorWhite,
            radius: 35,
            child: defaultImg(
              image: svgIconName,
              iconColor: bgColor,
              width: 30,
              height: 30,
            ),
          ),
          getSizedBox(height: 15),
          TweenAnimationBuilder<double>(
            duration: Duration(seconds: Constant.animationDuration),
            tween: Tween<double>(
              begin: 0,
              end: double.parse(itemCount.toString().replaceAll(',', '')),
            ),
            builder: (context, value, child) => CustomTextLabel(
              text: value.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: ColorsRes.appColorWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          getSizedBox(height: 5),
          CustomTextLabel(
            text: title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: ColorsRes.appColorWhite,
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
            maxLines: 1,
          ),
        ],
      ),
    ),
  );
}
