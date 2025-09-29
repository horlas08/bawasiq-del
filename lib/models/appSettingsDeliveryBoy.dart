class AppSettingsDeliveryBoy {
  String? status;
  String? message;
  String? total;
  AppSettingsDeliveryBoyData? data;

  AppSettingsDeliveryBoy({this.status, this.message, this.total, this.data});

  AppSettingsDeliveryBoy.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null
        ? new AppSettingsDeliveryBoyData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AppSettingsDeliveryBoyData {
  String? appName;
  String? supportNumber;
  String? supportEmail;
  String? isVersionSystemOn;
  String? currentVersion;
  String? iosIsVersionSystemOn;
  String? currency;
  String? currencyCode;
  String? decimalPoint;
  String? lowStockLimit;
  String? appModeSeller;
  String? appModeDeliveryBoy;
  String? appModeDeliveryBoyRemark;
  String? googlePlaceApiKey;
  String? privacyPolicyDeliveryBoy;
  String? termsConditionsDeliveryBoy;
  List<String>? allPermissions;
  String? apiKey;
  String? enableRoadPathTracking;

  AppSettingsDeliveryBoyData(
      {this.appName,
      this.supportNumber,
      this.supportEmail,
      this.isVersionSystemOn,
      this.currentVersion,
      this.iosIsVersionSystemOn,
      this.currency,
      this.currencyCode,
      this.decimalPoint,
      this.lowStockLimit,
      this.appModeSeller,
      this.appModeDeliveryBoy,
      this.appModeDeliveryBoyRemark,
      this.googlePlaceApiKey,
      this.privacyPolicyDeliveryBoy,
      this.termsConditionsDeliveryBoy,
      this.allPermissions,
      this.apiKey,
      this.enableRoadPathTracking});

  AppSettingsDeliveryBoyData.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'].toString();
    supportNumber = json['support_number'].toString();
    supportEmail = json['support_email'].toString();
    isVersionSystemOn = json['is_version_system_on'].toString();
    currentVersion = json['current_version'].toString();
    iosIsVersionSystemOn = json['ios_is_version_system_on'].toString();
    currency = json['currency'].toString();
    currencyCode = json['currency_code'].toString();
    decimalPoint = json['decimal_point'].toString();
    lowStockLimit = json['low_stock_limit'].toString();
    appModeSeller = json['app_mode_seller'].toString();
    appModeDeliveryBoy = json['app_mode_delivery_boy'].toString();
    appModeDeliveryBoyRemark = json['app_mode_delivery_boy_remark'].toString();
    googlePlaceApiKey = json['google_place_api_key'].toString();
    privacyPolicyDeliveryBoy = json['privacy_policy_delivery_boy'].toString();
    termsConditionsDeliveryBoy =
        json['terms_conditions_delivery_boy'].toString();
    allPermissions = json['allPermissions'].cast<String>();
    apiKey = json['apiKey'] ?? "";
    enableRoadPathTracking = json['enable_road_path_tracking'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['support_number'] = this.supportNumber;
    data['support_email'] = this.supportEmail;
    data['is_version_system_on'] = this.isVersionSystemOn;
    data['current_version'] = this.currentVersion;
    data['ios_is_version_system_on'] = this.iosIsVersionSystemOn;
    data['currency'] = this.currency;
    data['currency_code'] = this.currencyCode;
    data['decimal_point'] = this.decimalPoint;
    data['low_stock_limit'] = this.lowStockLimit;
    data['app_mode_seller'] = this.appModeSeller;
    data['app_mode_delivery_boy'] = this.appModeDeliveryBoy;
    data['app_mode_delivery_boy_remark'] = this.appModeDeliveryBoyRemark;
    data['google_place_api_key'] = this.googlePlaceApiKey;
    data['privacy_policy_delivery_boy'] = this.privacyPolicyDeliveryBoy;
    data['terms_conditions_delivery_boy'] = this.termsConditionsDeliveryBoy;
    data['allPermissions'] = this.allPermissions;
    data['apiKey'] = this.apiKey;
    data['enable_road_path_tracking'] = this.enableRoadPathTracking;
    return data;
  }
}
