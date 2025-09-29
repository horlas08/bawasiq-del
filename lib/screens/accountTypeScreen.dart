import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class AccountTypeScreen extends StatefulWidget {
  AccountTypeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountTypeScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<AccountTypeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: [
      PositionedDirectional(
        bottom: 0,
        start: 0,
        end: 0,
        top: 0,
        child: Image.asset(
          Constant.getAssetsPath(0, "bg.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      PositionedDirectional(
        bottom: 0,
        start: 0,
        end: 0,
        top: 0,
        child: Image.asset(
          Constant.getAssetsPath(0, "bg_overlay.png"),
          fit: BoxFit.fill,
        ),
      ),
      PositionedDirectional(
        bottom: 0,
        start: 0,
        end: 0,
        top: 0,
        child: Padding(
          padding: EdgeInsetsDirectional.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getSizedBox(height: 30),
              CustomTextLabel(
                jsonKey: loginTypePageTitleLabel,
                softWrap: true,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.w500),
              ),
              getSizedBox(
                height: 10,
              ),
              CustomTextLabel(
                jsonKey: loginTypePageDescriptionLabel,
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.w300),
              ),
              Spacer(),
              CustomTextLabel(
                jsonKey: loginAsLabel,
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.w400),
              ),
              getSizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: gradientBtnWidget(
                      context,
                      10,
                      otherWidgets: CustomTextLabel(
                        jsonKey: sellerLabel,
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                color: ColorsRes.appColorWhite,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      ),
                      callback: () {
                        Constant.session.setData(
                            SessionManager.keyUserType, "seller", false);
                        Navigator.pushNamed(context, loginScreen);
                      },
                    ),
                  ),
                  getSizedBox(width: 10),
                  Expanded(
                    child: gradientBtnWidget(
                      context,
                      10,
                      otherWidgets: CustomTextLabel(
                        jsonKey: deliveryBoyLabel,
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                  color: ColorsRes.appColorWhite,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500),
                            ),
                      ),
                      callback: () {
                        Constant.session.setData(SessionManager.keyUserType,
                            "delivery_boy", false);
    
                        Navigator.pushNamed(context, loginScreen);
                      },
                    ),
                  ),
                ],
              ),
              getSizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    ],
        );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
