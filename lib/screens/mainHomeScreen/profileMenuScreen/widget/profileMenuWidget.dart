import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

profileMenuWidget({required var profileMenus}) {
  return ListView.separated(
      padding: EdgeInsetsDirectional.only(end: 10, start: 10),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          color: ColorsRes.grey,
        );
      },
      itemCount: profileMenus.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            profileMenus[index]['clickFunction'](context);
          },
          contentPadding: EdgeInsets.zero,
          leading: Container(
            decoration: DesignConfig.boxDecoration(
                ColorsRes.appColorLightHalfTransparent, 5),
            padding: EdgeInsets.all(5),
            child: defaultImg(
                image: profileMenus[index]['icon'],
                iconColor: ColorsRes.appColor,
                height: 20,
                width: 20),
          ),
          title: Text(
            profileMenus[index]['label'],
            style: Theme.of(context).textTheme.bodyMedium!.merge(
                  TextStyle(
                    letterSpacing: 0.5,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
          ),
          trailing: Icon(
            Icons.navigate_next,
            color: ColorsRes.subTitleTextColor,
          ),
        );
      });
}
