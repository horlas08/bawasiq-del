import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

export 'package:geolocator/geolocator.dart';
export 'package:intl/intl.dart';

enum NetworkStatus { Online, Offline }

class Constant {
  //Add your admin panel url here with postfix slash eg. https://www.admin.panel/
  // TODO ADMIN PANEL URL HERE
  static String hostUrl = "https://taha.bawasiq.com/";

  static String packageName = "com.wrteam.bawasiq.seller";

  static String appStoreUrl = "https://testflight.apple.com/join/Bmx2ZdOf";
  static int animationDuration = 1;

  // TODO ANDROID APP URL HERE
  static String playStoreUrl = "https://play.google.com/store/apps/details?id=$packageName";

  static int minimumRequiredMobileNumberLength = 7;

  static int messageDisplayDuration = 3500; // resend otp timer

  // TODO Change this to your app name
  static String appName = "eGrocer Partner";

  // custom prompt message
  static String customPromptMessage = "Generate a detailed HTML-formatted product description based on the following custom input don\'t include image:";
  static String defaultPromptMessage(String productName) =>
      'Generate a long, engaging HTML-formatted description for a product named "$productName". Highlight its features, benefits, and unique qualities  Note:don\'t include image.';

  // TODO IOS APP URL HERE
  static String appStoreId = "app_store_id_here";
  // static String googleApiKey = "";
  static String demoMode = "0";
  static String androidApiKey = "PLACE_ANDROID_MAP_KEY";
  static String iOSApiKey = "PLACE_IOS_MAP_KEY";
  static Map cityAddressMap = {};
  static String appKey = "app";

  static GlobalKey<NavigatorState> navigatorKay = GlobalKey<NavigatorState>();

  ///Set [appLoginType] value 1 for login only sellers
  ///Set [appLoginType] value 2 for login only delivery boys
  ///Set [appLoginType] value 3 for login sellers and delivery boys both
  static int appLoginType = 3;

  static int defaultDataLoadLimitAtOnce = 20;
  static int defaultImagesLoadLimitAtOnce = 50;

  static BorderRadius borderRadius5 = BorderRadius.circular(5);
  static BorderRadius borderRadius7 = BorderRadius.circular(7);
  static BorderRadius borderRadius10 = BorderRadius.circular(10);
  static BorderRadius borderRadius13 = BorderRadius.circular(13);

  static late SessionManager session;

  static int searchHistoryListLimit = 20; // resend otp timer

  // Theme list, This system default names please do not change at all
  static List<String> themeList = ["System default", "Light", "Dark"];

  //Order statues icons
  static List<String> orderStatusIcons = [
    "order_status_all_orders" /*All Orders*/,
    "order_status_payment_pending" /*Awaiting Payment*/,
    "order_status_received" /*Received*/,
    "order_status_processed" /*Processed*/,
    "order_status_shipped" /*Shipped*/,
    "order_status_out_for_delivery" /*Out For Delivery*/,
    "order_status_delivered" /*Delivered*/,
    "order_status_cancelled" /*Cancelled*/,
    "order_status_returned" /*Returned*/
  ];

  // App Settings
  static String currency = "";
  static String currencyCode = "";
  static String currencyDecimalPoint = "0";
  static String privacyPolicy = "";
  static String termsConditions = "";
  static String appMaintenanceMode = "";
  static String appMaintenanceModeRemark = "";
  static String viewCustomerDetail = "1";
  static String sellerCommission = "0";
  static String deliveryBoyCommission = "0";
  static String enableRoadPathTracking = "0";

  static String getAssetsPath(int folder, String filename) {
    //0-image,1-svg,2-language,3-animation

    String path = "";
    switch (folder) {
      case 0:
        path = "assets/images/$filename";
        break;
      case 1:
        path = "assets/svg/$filename.svg";
        break;
      case 2:
        path = "assets/language/$filename.json";
        break;
      case 3:
        path = "assets/animation/$filename.json";
        break;
      case 4:
        path = "assets/$filename.json";
      case 5:
        path = "assets/mapTheme/$filename.json";
    }

    return path;
  }

  //Default padding and margin variables

  static double paddingOrMargin2 = 2.00;
  static double paddingOrMargin3 = 3.00;
  static double paddingOrMargin5 = 5.00;
  static double paddingOrMargin7 = 7.00;
  static double paddingOrMargin8 = 8.00;
  static double paddingOrMargin10 = 10.00;
  static double paddingOrMargin12 = 12.00;
  static double paddingOrMargin14 = 14.00;
  static double paddingOrMargin15 = 15.00;
  static double paddingOrMargin18 = 18.00;
  static double paddingOrMargin20 = 20.00;
  static double paddingOrMargin25 = 20.00;
  static double paddingOrMargin30 = 30.00;
  static double paddingOrMargin40 = 40.00;

  static Future<String> getGetMethodUrlWithParams(String mainUrl, Map params) async {
    if (params.isNotEmpty) {
      mainUrl = "$mainUrl?";
      for (int i = 0; i < params.length; i++) {
        mainUrl = "$mainUrl${i == 0 ? "" : "&"}${params.keys.toList()[i]}=${params.values.toList()[i]}";
      }
    }

    return mainUrl;
  }
}
