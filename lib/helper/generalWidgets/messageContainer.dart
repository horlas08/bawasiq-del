import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/helper/utils/toastAnimation.dart';

Widget MessageContainer({
  required BuildContext context,
  required String text,
  required MessageType type,
}) {
  return Material(color: Constant.session.getBoolData(SessionManager.isDarkTheme)
              ? ColorsRes.bgColorDark: ColorsRes.bgColorLight,
    child: ToastAnimation(
      delay: Constant.messageDisplayDuration,
      child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            // using gradient to apply one side dark color in container
            gradient: LinearGradient(
              stops: const [0.02, 0.02],
              colors: [
                messageColors[type]!,
                messageColors[type]!.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: messageColors[type]!.withValues(alpha: 0.5),
            ),
          ),
          width: context.width,
          constraints: BoxConstraints(minHeight: 50),
          child: Row(
            children: [
              getSizedBox(width: 15),
              messageIcon[type]!,
              SizedBox(
                width: context.width - 90,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextLabel(
                    text: text,
                    softWrap: true,
                    style: TextStyle(
                      color: messageColors[type],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              getSizedBox(width: 10),
            ],
          )),
    ),
  );
}