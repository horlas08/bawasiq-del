class AppSettingsSeller {
  String? status;
  String? message;
  String? total;
  AppSettingsSellerData? data;

  AppSettingsSeller({this.status, this.message, this.total, this.data});

  AppSettingsSeller.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null
        ? new AppSettingsSellerData.fromJson(json['data'])
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

class AppSettingsSellerData {
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
  String? appModeSellerRemark;
  String? googlePlaceApiKey;
  String? privacyPolicySeller;
  String? termsConditionsSeller;
  String? viewCustomerDetail;
  String? sellerCommission;
  String? apiKey;
  String? demoMode;
  String? textGenKey;

  AppSettingsSellerData({
    this.appName,
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
    this.appModeSellerRemark,
    this.googlePlaceApiKey,
    this.privacyPolicySeller,
    this.termsConditionsSeller,
    this.sellerCommission,
    this.apiKey,
    this.demoMode,
    this.textGenKey
  });

  AppSettingsSellerData.fromJson(Map<String, dynamic> json) {
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
    appModeSellerRemark = json['app_mode_seller_remark'].toString();
    googlePlaceApiKey = json['google_place_api_key'].toString();
    privacyPolicySeller = json['privacy_policy_seller'].toString();
    termsConditionsSeller = json['terms_conditions_seller'].toString();
    viewCustomerDetail = json['view_customer_detail'].toString();
    sellerCommission = json['seller_commission'].toString();
    apiKey = json['apiKey'] ?? "";
    demoMode = json['demo_mode'] ?? "0";
    textGenKey = json['text_gen_key'] ?? "";
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
    data['app_mode_seller_remark'] = this.appModeSellerRemark;
    data['google_place_api_key'] = this.googlePlaceApiKey;
    data['privacy_policy_seller'] = this.privacyPolicySeller;
    data['terms_conditions_seller'] = this.termsConditionsSeller;
    data['view_customer_detail'] = this.viewCustomerDetail;
    data['seller_commission'] = this.sellerCommission;
    data['apiKey'] = this.apiKey;
    data['demo_mode'] = this.demoMode;
    data['text_gen_key'] = this.textGenKey;
    return data;
  }
}
