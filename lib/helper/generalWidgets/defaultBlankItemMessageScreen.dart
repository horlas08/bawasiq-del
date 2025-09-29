import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class DefaultBlankItemMessageScreen extends StatelessWidget {
  final String image, title, description;
  final Function? callback;
  final String? buttonTitle;
  final double? height;

  const DefaultBlankItemMessageScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      this.callback,
      this.buttonTitle,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.only(bottom: 50),
          decoration: ShapeDecoration(
            color: ColorsRes.defaultPageInnerCircle,
            shape: CircleBorder(
              side: BorderSide(
                  width: 20, color: ColorsRes.defaultPageOuterCircle),
            ),
          ),
          child: Center(
            child: defaultImg(
              image: image,
              width: context.width * 0.25,
              height: context.width * 0.25,
            ),
          ),
        ),
        CustomTextLabel(
          jsonKey: title,
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall!.merge(
                TextStyle(
                  color: ColorsRes.appColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
        ),
        SizedBox(height: Constant.paddingOrMargin10),
        CustomTextLabel(
          jsonKey: description,
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.merge(
                TextStyle(
                  letterSpacing: 0.5,
                  color: ColorsRes.mainTextColor,
                ),
              ),
        ),
        if (callback != null && buttonTitle != null) const SizedBox(height: 20),
        if (callback != null && buttonTitle != null)
          GestureDetector(
            onTap: () {
              callback!();
            },
            child: Container(
              decoration: DesignConfig.boxDecoration(ColorsRes.appColor, 10),
              padding: const EdgeInsets.all(10),
              child: CustomTextLabel(
                jsonKey: buttonTitle,
                softWrap: true,
                style: TextStyle(
                  color: ColorsRes.appColorWhite,
                ),
              ),
            ),
          )
      ],
    );
  }
}
