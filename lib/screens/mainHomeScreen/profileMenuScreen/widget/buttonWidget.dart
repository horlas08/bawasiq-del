import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

buttonWidget(var icon, String lbl,
    {required Function onClickAction, required BuildContext context}) {
  return Card(
    color: Theme.of(context).cardColor,
    surfaceTintColor: ColorsRes.appColorTransparent,
    margin: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin3),
    elevation: 0,
    child: InkWell(
      splashColor: ColorsRes.appColorLight,
      onTap: () {
        onClickAction();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 8),
          Card(
            shape: DesignConfig.setRoundedBorder(8),
            color: ColorsRes.appColorLightHalfTransparent,
            surfaceTintColor: ColorsRes.appColorTransparent,
            elevation: 0,
            child: Padding(padding: EdgeInsets.all(5), child: icon),
          ),
          SizedBox(height: 5),
          CustomTextLabel(text: lbl),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}
