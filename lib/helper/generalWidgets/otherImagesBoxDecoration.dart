import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

getOtherImagesBoxDecoration({bool? isActive}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border(
      left: BorderSide(
        width: 0.5,
        color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
      ),
      bottom: BorderSide(
        width: 0.5,
        color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
      ),
      top: BorderSide(
        width: 0.5,
        color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
      ),
      right: BorderSide(
        width: 0.5,
        color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
      ),
    ),
  );
}
