import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/helper/generalWidgets/customCheckbox.dart';
import 'package:project/helper/utils/generalImports.dart';

class PermissionHandlerBottomSheet extends StatefulWidget {
  final String titleJsonKey;
  final String messageJsonKey;
  final String sessionKeyForAskNeverShowAgain;

  const PermissionHandlerBottomSheet({
    super.key,
    required this.titleJsonKey,
    required this.messageJsonKey,
    required this.sessionKeyForAskNeverShowAgain,
  });

  @override
  State<PermissionHandlerBottomSheet> createState() =>
      _PermissionHandlerBottomSheetState();
}

class _PermissionHandlerBottomSheetState
    extends State<PermissionHandlerBottomSheet> {
  bool isNeverShowAgainChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(15), topStart: Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getSizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: CustomTextLabel(
              jsonKey: widget.titleJsonKey,
              style: TextStyle(color: ColorsRes.mainTextColor, fontSize: 20),
            ),
          ),
          getSizedBox(height: 10),
          CustomTextLabel(
            jsonKey: widget.messageJsonKey,
            style: TextStyle(color: ColorsRes.mainTextColor, fontSize: 18),
          ),
          getSizedBox(height: 10),
          GestureDetector(
            onTap: () {
              isNeverShowAgainChecked = !isNeverShowAgainChecked;
              setState(() {});
            },
            child: Row(
              children: [
                CustomCheckbox(
                  visualDensity: VisualDensity.compact,
                  value: isNeverShowAgainChecked,
                  onChanged: (value) {
                    isNeverShowAgainChecked = !isNeverShowAgainChecked;
                    setState(() {});
                  },
                ),
                CustomTextLabel(
                  jsonKey: neverAskAgainLabel,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ],
            ),
          ),
          getSizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: gradientBtnWidget(
                  context,
                  10,
                  callback: () {
                    Constant.session.setBoolData(
                        widget.sessionKeyForAskNeverShowAgain,
                        isNeverShowAgainChecked,
                        false);

                    Navigator.pop(context);
                  },
                  title: getTranslatedValue(context, closeLabel),
                ),
              ),
              getSizedBox(width: 10),
              Expanded(
                child: gradientBtnWidget(
                  context,
                  10,
                  callback: () {
                    if (!isNeverShowAgainChecked) {
                      openAppSettings();
                    }
                  },
                  title: getTranslatedValue(context, goToSettingLabel),
                  color2: isNeverShowAgainChecked
                      ? ColorsRes.grey
                      : ColorsRes.gradient2,
                  color1: isNeverShowAgainChecked
                      ? ColorsRes.grey
                      : ColorsRes.gradient1,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
