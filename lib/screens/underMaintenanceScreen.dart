import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class UnderMaintenanceScreen extends StatelessWidget {
  const UnderMaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Center(
          child: Container(
            decoration:
                DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                    padding: EdgeInsets.all(20),
                    height: context.height * 0.4,
                    child: defaultImg(image: AppAssets.underMaintenanceIcon)),
                getSizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: CustomTextLabel(
                    jsonKey: appUnderMaintenanceLabel,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w500,
                        ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (Constant.appMaintenanceModeRemark.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: CustomTextLabel(
                      text: Constant.appMaintenanceModeRemark,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
