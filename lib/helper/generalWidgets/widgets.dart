import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/helper/generalWidgets/expandableText.dart';
import 'package:project/helper/utils/generalImports.dart';

Widget gradientBtnWidget(
  BuildContext context,
  double borderRadius, {
  required Function callback,
  String title = "",
  EdgeInsetsDirectional padding = EdgeInsetsDirectional.zero,
  Widget? otherWidgets,
  double? height,
  Color? color1,
  Color? color2,
}) {
  return GestureDetector(
    onTap: () {
      callback();
    },
    child: Container(
      padding: padding,
      height: height ?? 45,
      alignment: Alignment.center,
      decoration: DesignConfig.boxGradient(borderRadius, color1: color1, color2: color2),
      child: otherWidgets ??= CustomTextLabel(
        text: title,
        softWrap: true,
        style: Theme.of(context).textTheme.titleMedium!.merge(
              TextStyle(
                color: ColorsRes.appColorWhite,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
    ),
  );
}

Widget defaultImg({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? requiredRTL = true,
}) {
  return Padding(
    padding: padding ?? const EdgeInsets.all(0),
    child: (image.contains("png") || image.contains("jpeg") || image.contains("jpg"))
        ? Image.asset(image, width: width,
            height: height,
            fit: boxFit ?? BoxFit.contain,
          )
        : iconColor != null
            ? SvgPicture.asset(
                Constant.getAssetsPath(1, image),
                width: width,
                height: height,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                fit: boxFit ?? BoxFit.contain,
                matchTextDirection: requiredRTL ?? true,
              )
            : SvgPicture.asset(
                Constant.getAssetsPath(1, image),
                width: width,
                height: height,
                fit: boxFit ?? BoxFit.contain,
                matchTextDirection: requiredRTL ?? true,
              ),
  );
}

Widget getDarkLightIcon({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? isActive,
}) {
  String dark = (Constant.session.getBoolData(SessionManager.isDarkTheme)) ? "_dark" : "";
  String active = (isActive ??= false) == true ? "_active" : "";
  return defaultImg(height: height, width: width, image: "$image$active${dark}${AppAssets.icon}", iconColor: iconColor, boxFit: boxFit, padding: padding);
}

Widget setNetworkImg({
  double? height,
  double? width,
  String image = AppAssets.placeholderIcon,
  Color? iconColor,
  BoxFit? boxFit,
}) {
  if (image != "null" && image.isNotEmpty && !image.contains("http")) {
    image = "${Constant.hostUrl}storage/$image";
  }

  return image.trim().isEmpty
      ? defaultImg(image: Constant.getAssetsPath(0, "placeholder.png"), height: height, width: width, boxFit: boxFit)
      : Container(
          child: FadeInImage.assetNetwork(
            image: image,
            width: width,
            height: height,
            fit: boxFit,
            placeholder: Constant.getAssetsPath(0, "placeholder.png"),
            imageErrorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return defaultImg(
                image: Constant.getAssetsPath(0, "placeholder.png"),
                height: height,
                width: width,
                boxFit: boxFit,
              );
            },
          ),
        );
}

openBottomSheetDialog(BuildContext context, String title, var sheetWidget) {
  return showModalBottomSheet(
    backgroundColor: Theme.of(context).cardColor,
    context: context,
    isScrollControlled: true,
    shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
    builder: (context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.all(20),
              child: Center(
                child: CustomTextLabel(
                  text: title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.merge(
                        TextStyle(
                          letterSpacing: 0.5,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(start: 20, end: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: sheetWidget(context),
                ),
              ),
            ),
          ],
        );
      });
    },
  );
}

themeDialog(BuildContext context) async {
  return openBottomSheetDialog(context, getTranslatedValue(context, changeThemeLabel), themeListView);
}

Widget textFieldWidget(
    TextEditingController edtcontrl, Function validatorfunc, String lbl, TextInputType txttype, String errmsg, BuildContext context,
    {bool ishidetext = false,
    Function()? tapCallback,
    Widget? ticon,
    Widget? sicon,
    bool iseditable = true,
    int? minlines,
    int? maxlines,
    FocusNode? currfocus,
    FocusNode? nextfocus,
    BoxConstraints? prefixIconConstaint,
    Color? bgcolor,
    String? hint,
    double borderRadius = 0,
    bool floatingLbl = true,
    EdgeInsetsGeometry? contentPadding,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode}) {
  return TextFormField(
    obscureText: ishidetext,
    enabled: iseditable,
    style: TextStyle(
      color: ColorsRes.mainTextColor,
    ),
    // maxLength: 191,
    // buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => Container(),
    maxLines: maxlines,
    minLines: minlines,
    controller: edtcontrl,
    validator: (String? value) {
      return validatorfunc(value ?? "") == null ? null : errmsg;
      //return validatorfunc(value ?? "") == null ? null : errmsg;
    },
    decoration: InputDecoration(
      prefix: sicon,
      suffixIcon: ticon,
      alignLabelWithHint: true,
      fillColor: Theme.of(context).cardColor,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: ColorsRes.appColor,
          width: 1,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: ColorsRes.subTitleTextColor.withValues(alpha: 0.5),
          width: 1,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: ColorsRes.appColorRed,
          width: 1,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: ColorsRes.subTitleTextColor,
          width: 1,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: ColorsRes.subTitleTextColor.withValues(alpha: 0.5),
          width: 1,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      labelText: lbl,
      labelStyle: TextStyle(color: ColorsRes.subTitleTextColor),
      isDense: true,
      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
        (Set<WidgetState> states) {
          final Color color = states.contains(WidgetState.error) ? Theme.of(context).colorScheme.error : ColorsRes.appColor;
          return TextStyle(color: color, letterSpacing: 1.3);
        },
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    ),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: txttype,
    inputFormatters: inputFormatters ?? [],
  )/* TextFormField(
  controller: edtcontrl,
  obscureText: ishidetext,
  enabled: iseditable,
  validator: (String? value) {
    final result = validatorfunc!(value);
    print("Validation result: $result"); // For debugging
    return result; // MUST return null or error string
  },
  decoration: InputDecoration(
    labelText: lbl,
    prefix: sicon,
    suffixIcon: ticon,
    fillColor: Theme.of(context).cardColor,
    filled: true,
    errorStyle: TextStyle(
      color: Colors.red,
      fontSize: 12,
    ),
    errorMaxLines: 2,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: ColorsRes.appColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: ColorsRes.appColorRed),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: ColorsRes.subTitleTextColor),
    ),
  ),
  autovalidateMode: AutovalidateMode.onUserInteraction,
  keyboardType: txttype,
  inputFormatters: inputFormatters ?? [],
) */;
}

themeListView(BuildContext context) {
  List lblThemeDisplayNames = [
    getTranslatedValue(
      context,
      themeDisplayNamesSystemDefaultLabel,
    ),
    getTranslatedValue(
      context,
      themeDisplayNamesLightLabel,
    ),
    getTranslatedValue(
      context,
      themeDisplayNamesDarkLabel,
    ),
  ];

  return List.generate(Constant.themeList.length, (index) {
    String themeDisplayName = lblThemeDisplayNames[index];
    String themeName = Constant.themeList[index];

    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      onTap: () {
        Navigator.pop(context);
        if (Constant.session.getData(SessionManager.appThemeName) != themeName) {
          Constant.session.setData(SessionManager.appThemeName, themeName, true);

          Constant.session.setBoolData(
              SessionManager.isDarkTheme,
              index == 0
                  ? PlatformDispatcher.instance.platformBrightness == Brightness.dark
                  : index == 1
                      ? false
                      : true,
              true);
        }
      },
      leading: Icon(
        Constant.session.getData(SessionManager.appThemeName) == themeName ? Icons.radio_button_checked : Icons.radio_button_off,
        color: ColorsRes.appColor,
      ),
      title: CustomTextLabel(
        text: themeDisplayName,
        softWrap: true,
      ),
    );
  });
}

Widget homeBottomNavigation(
    {required int selectedIndex,
    required Function selectBottomMenu,
    required int totalPage,
    required BuildContext context,
    required List lblHomeBottomMenu}) {
  return BottomNavigationBar(
      items: List.generate(
        totalPage,
        (index) {
          return BottomNavigationBarItem(
            backgroundColor: Theme.of(context).cardColor,
            icon: getHomeBottomNavigationBarIcons(isActive: selectedIndex == index)[index],
            label: lblHomeBottomMenu[index].toString(),
          );
        },
      ),
      type: BottomNavigationBarType.shifting,
      currentIndex: selectedIndex,
      selectedItemColor: ColorsRes.mainTextColor,
      unselectedItemColor: ColorsRes.appColorTransparent,
      onTap: (int ind) {
        selectBottomMenu(ind);
      },
      elevation: 5);
}

List getHomeBottomNavigationBarIcons({required bool isActive}) {
  if (Constant.session.isSeller()) {
    return [
      getDarkLightIcon(image: "home", isActive: isActive, height: 24, width: 24),
      getDarkLightIcon(image: "orders", isActive: isActive, height: 30, width: 30),
      getDarkLightIcon(image: "products", isActive: isActive, height: 28, width: 28),
      getDarkLightIcon(image: "profile", isActive: isActive, height: 24, width: 24),
    ];
  } else {
    return [
      getDarkLightIcon(image: "home", isActive: isActive, height: 24, width: 24),
      getDarkLightIcon(image: "profile", isActive: isActive, height: 24, width: 24),
    ];
  }
}

getSizedBox({double? height, double? width}) {
  return SizedBox(height: height ?? 0, width: width ?? 0);
}

getProductVariantDropdownBorderBoxDecoration() {
  return BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
      border: Border(
        bottom: BorderSide(color: ColorsRes.subTitleTextColor, width: 0.5),
        top: BorderSide(color: ColorsRes.subTitleTextColor, width: 0.5),
        right: BorderSide(color: ColorsRes.subTitleTextColor, width: 0.5),
        left: BorderSide(color: ColorsRes.subTitleTextColor, width: 0.5),
      ));
}

Widget getLoadingIndicator() {
  return CircularProgressIndicator(
    backgroundColor: ColorsRes.appColorTransparent,
    color: ColorsRes.appColor,
    strokeWidth: 2,
  );
}

class CustomShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  CustomShimmer({Key? key, this.height, this.width, this.borderRadius, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: ColorsRes.shimmerBaseColor,
      highlightColor: ColorsRes.shimmerHighlightColor,
      child: Container(
        width: width,
        margin: margin ?? EdgeInsets.zero,
        height: height ?? 10,
        decoration: BoxDecoration(
          // color: ColorsRes.shimmerContainerColor,
          color: ColorsRes.shimmerContainerColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
      ),
    );
  }
}

AppBar getAppBar(
    {required BuildContext context, Widget? appBarLeading, bool? centerTitle, required Widget title, List<Widget>? actions, Color? backgroundColor}) {
  return AppBar(
    elevation: 1,
    title: title,
    centerTitle: centerTitle ?? true,
    backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
    surfaceTintColor: ColorsRes.appColorTransparent,
    actions: actions ?? [],
  );
}

class ScrollGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return AlwaysScrollableScrollPhysics(
      parent: BouncingScrollPhysics(),
    );
  }
}

Widget getProductListShimmer({required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 6,
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10, vertical: Constant.paddingOrMargin10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.7, crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        )
      : Column(
          children: List.generate(20, (index) {
            return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
              child: CustomShimmer(
                width: double.maxFinite,
                height: 125,
              ),
            );
          }),
        );
}

Widget getProductItemShimmer({required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 2,
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10, vertical: Constant.paddingOrMargin10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.7, crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        )
      : Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          child: CustomShimmer(
            width: double.maxFinite,
            height: 125,
          ),
        );
}

Widget setRefreshIndicator({required RefreshCallback refreshCallback, required Widget child}) {
  return RefreshIndicator(
    onRefresh: refreshCallback,
    child: child,
    backgroundColor: ColorsRes.appColorTransparent,
    color: ColorsRes.appColor,
    triggerMode: RefreshIndicatorTriggerMode.anywhere,
  );
}

// CategorySimmer
Widget getCategoryShimmer({required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ?? EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10, vertical: Constant.paddingOrMargin10),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        borderRadius: 8,
      );
    },
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.8, crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
  );
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

Widget getOutOfStockWidget({required double height, required double width, double? textSize, required BuildContext context}) {
  return Container(
    alignment: AlignmentDirectional.center,
    decoration: BoxDecoration(
      borderRadius: Constant.borderRadius10,
      color: ColorsRes.appColorBlack.withValues(alpha: 0.3),
    ),
    child: FittedBox(
      fit: BoxFit.none,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: Constant.borderRadius5,
          color: ColorsRes.appColorWhite,
        ),
        child: CustomTextLabel(
          jsonKey: outOfStockLabel,
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: textSize ?? 18, fontWeight: FontWeight.w400, color: ColorsRes.appColorRed),
        ),
      ),
    ),
  );
}

Widget getOverallRatingSummary({required BuildContext context, required ProductRatingData productRatingData, required String totalRatings}) {
  return Row(
    children: [
      Column(
        children: [
          CircleAvatar(
            backgroundColor: ColorsRes.appColor,
            maxRadius: 45,
            minRadius: 20,
            child: CustomTextLabel(
              text: "${productRatingData.averageRating?.toString().toDouble?.toStringAsFixed(1)}",
              style: TextStyle(
                color: ColorsRes.appColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          getSizedBox(height: 10),
          CustomTextLabel(
            text: "${getTranslatedValue(context, ratingLabel)}\n${totalRatings.toString().toInt}",
            style: TextStyle(
              color: ColorsRes.subTitleTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      Container(
        margin: EdgeInsetsDirectional.only(start: 20, end: 20),
        color: ColorsRes.subTitleTextColor,
        height: 165,
        width: 0.7,
      ),
      Expanded(
        child: Column(
          children: [
            PercentageWiseRatingBar(
              context: context,
              index: 4,
              totalRatings: productRatingData.fiveStarRating.toString().toStringToInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toStringToInt,
                starsWiseRatings: productRatingData.fiveStarRating.toString().toStringToInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 3,
              totalRatings: productRatingData.fourStarRating.toString().toStringToInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toStringToInt,
                starsWiseRatings: productRatingData.fourStarRating.toString().toStringToInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 2,
              totalRatings: productRatingData.threeStarRating.toString().toStringToInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toStringToInt,
                starsWiseRatings: productRatingData.threeStarRating.toString().toStringToInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 1,
              totalRatings: productRatingData.twoStarRating.toString().toStringToInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toString().toStringToInt,
                starsWiseRatings: productRatingData.twoStarRating.toString().toString().toStringToInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 0,
              totalRatings: productRatingData.oneStarRating.toString().toStringToInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toStringToInt,
                starsWiseRatings: productRatingData.oneStarRating.toString().toStringToInt,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget PercentageWiseRatingBar({
  required double ratingPercentage,
  required int totalRatings,
  required int index,
  required BuildContext context,
}) {
  return Column(
    children: [
      Row(
        children: [
          CustomTextLabel(
            text: "${index + 1}",
          ),
          getSizedBox(width: 5),
          Icon(
            Icons.star_rounded,
            color: ColorsRes.appColorAmber,
          ),
          getSizedBox(width: 5),
          Expanded(
            child: Container(
              height: 5,
              width: context.width * 0.4,
              decoration: BoxDecoration(
                color: ColorsRes.mainTextColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  height: 5,
                  width: (context.width * 0.34) * ratingPercentage,
                  decoration: BoxDecoration(
                    color: ColorsRes.appColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          getSizedBox(width: 10),
          CustomTextLabel(
            text: "$totalRatings",
            style: TextStyle(
              color: ColorsRes.subTitleTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      getSizedBox(height: 10),
    ],
  );
}

double calculatePercentage({required int totalRatings, required int starsWiseRatings}) {
  double percentage = 0.0;

  percentage = (starsWiseRatings * 100) / totalRatings;
  return (percentage / 100).toString().toLowerCase() == "nan" ? 0 : (percentage / 100);
}

Widget getRatingReviewItem({required ProductRatingList rating}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsetsDirectional.only(
              start: 5,
            ),
            decoration: BoxDecoration(
              color: ColorsRes.appColor,
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                CustomTextLabel(
                  text: rating.rate,
                  style: TextStyle(
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.star_rate_rounded,
                  color: ColorsRes.appColorAmber,
                  size: 20,
                )
              ],
            ),
          ),
          getSizedBox(width: 7),
          CustomTextLabel(
            text: rating.user?.name.toString() ?? "",
            style: TextStyle(color: ColorsRes.mainTextColor, fontWeight: FontWeight.w800, fontSize: 15),
            softWrap: true,
          )
        ],
      ),
      getSizedBox(height: 10),
      if (rating.review.toString().length > 100)
        ExpandableText(
          text: rating.review.toString(),
          max: 0.2,
          color: ColorsRes.subTitleTextColor,
        ),
      if (rating.review.toString().length <= 100)
        CustomTextLabel(
          text: rating.review.toString(),
          style: TextStyle(
            color: ColorsRes.subTitleTextColor,
          ),
        ),
      getSizedBox(height: 10),
      if (rating.images != null && rating.images!.length > 0)
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            runSpacing: 10,
            spacing: constraints.maxWidth * 0.017,
            children: List.generate(
              rating.images!.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, fullScreenProductImageScreen,
                        arguments: [index, rating.images?.map((e) => e.imageUrl.toString()).toList()]);
                  },
                  child: ClipRRect(
                    borderRadius: Constant.borderRadius5,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: setNetworkImg(
                      image: rating.images?[index].imageUrl ?? "",
                      width: 50,
                      height: 50,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      getSizedBox(height: 10),
      CustomTextLabel(
        text: rating.updatedAt.toString().formatDate(),
        style: TextStyle(
          color: ColorsRes.subTitleTextColor,
        ),
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

Widget OrderContainerShimmer(BuildContext context) {
  return CustomShimmer(
    width: MediaQuery.sizeOf(context).width,
    height: MediaQuery.sizeOf(context).height * 0.25,
    borderRadius: 10,
    margin: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10, end: Constant.paddingOrMargin10, bottom: Constant.paddingOrMargin10),
  );
}
