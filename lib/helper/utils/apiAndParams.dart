import 'package:project/helper/utils/constant.dart';

class ApiAndParams {
  //============== api ===========
  static String apiLogin = "${Constant.hostUrl}api/login";
  static String apiDashboard = "dashboard";
  static String apiCategories = "categories";

  static String apiMainCategories = "main_categories";
  static String apiDeliveryBoys = "delivery_boys";
  static String apiManageDeliveryBoysLatLong = "manage_live_tracking";
  static String apiAppSettings = "settings";
  static String apiOrdersHistory = "orders";
  static String apiOrderStatuses = "order_statuses";
  static String apiUpdateOrderStatus = "update_status";
  static String apiUpdateOrderDeliveryBoy = "assign_delivery_boy";
  static String apiOrderById = "order_by_id";
  static String apiNotificationSettings = "mail_settings";
  static String apiNotificationSettingsUpdate = "$apiNotificationSettings/save";
  static String apiRegisterUser = "register";
  static String apiUpdateUser = "update";
  static String apiCity = "city";
  static String apiTaxes = "taxes";
  static String apiBrands = "brands";
  static String apiEditProfile = "edit";
  static String apiCities = "cities";
  static String apiUnits = "units";
  static String apiCountries = "countries";
  static String apiProducts = "get_products";
  static String apiProductsRatings = "products/ratings_list";
  static String apiTransaction = "seller_wallet_transactions";
  static String apiWithdrawalRequests = "withdrawal_requests/get";
  static String apiSendWithdrawalRequests = "withdrawal_requests/add";
  static String apiAddProduct = "products/save";
  static String apiUpdateProduct = "products/update";
  static String apiDeleteProduct = "products/delete";
  static String apiFilterByProduct = "products/product_info";
  static String apiGetProductVariants = "products/get_product_variants";
  static String apiUpdateVariantStock = "products/update_variant_stock";
  static String apiGetProductProductById = "products/product_by_id";
  static String apiGetTags = "products/tags";
  static String apiProductBulkUpload = "products/bulk_upload";
  static String apiProductBulkUpdate = "products/bulk_update";
  static String apiDownloadProductDataExcel =
      "products/download_product_data_excel";
  static String apiDownloadSampleProductFile =
      "${Constant.hostUrl}sample-file/products.csv";
  static String apiSystemLanguages = "${Constant.hostUrl}api/system_languages";
  static String apiSellerDeleteAccount = "delete_seller_account";
  static String apiDeliveryBoyDeleteAccount = "delete_delivery_boy_account";
  static String apiUpdateSellerStatus = "update_seller_status";
  static String apiGetSellerStatus = "get_seller_status";
  static String cashCollection = "cash_collection";
  static String fundTransfers = "fund_transfers";
  static String apiSellerCategoriesList = "seller_categories_list";
  static String apiGoogleGemini = "google_gemini";

  //============ api params ============

  //General params
  static String status = "status";
  static String message = "message";
  static String limit = "limit";
  static String offset = "offset";
  static String total = "total";
  static String accessToken = "access_token";
  static String data = "data";
  static String user = "user";
  static String seller = "seller";
  static String deliveryBoy = "delivery_boy";
  static String cityName = "city_name";
  static String productId = "product_id";

  //Login api params
  static String email = "email";
  static String password = "password";
  static String fcmToken = "fcm_token";
  static String platform = "platform";
  static String type = "type";
  static String typeId = "type_id";
  static String amount = "amount";

  //Register api params
  static String mobile = "mobile";
  static String confirm_password = "confirm_password";

  //Edit Profile api params
  //Seller profile data
  static String id = "id";
  static String stock = "stock";
  static String admin_id = "admin_id";
  static String name = "name";
  static String userName = "username";
  static String storeName = "store_name";
  static String slug = "slug";
  static String balance = "balance";
  static String store_url = "store_url";
  static String logo = "logo";
  static String store_description = "store_description";
  static String street = "street";
  static String pincode_id = "pincode_id";
  static String city_id = "city_id";
  static String state = "state";
  static String categories_ids = "categories_ids";
  static String categories = "categories";
  static String categoriesName = "categories_array";
  static String account_number = "account_number";
  static String ifsc_code = "ifsc_code";
  static String account_name = "account_name";
  static String bank_name = "bank_name";
  static String commission = "commission";
  static String bonusPercentage = "bonus_percentage";
  static String require_products_approval = "require_products_approval";
  static String fcm_id = "fcm_id";
  static String pan_number = "pan_number";
  static String tax_name = "tax_name";
  static String tax_number = "tax_number";
  static String customer_privacy = "customer_privacy";
  static String latitude = "latitude";
  static String longitude = "longitude";
  static String place_name = "place_name";
  static String formatted_address = "formatted_address";
  static String forgot_password_code = "forgot_password_code";
  static String view_order_otp = "view_order_otp";
  static String assign_delivery_boy = "assign_delivery_boy";
  static String created_at = "created_at";
  static String updated_at = "updated_at";
  static String deleted_at = "deleted_at";
  static String remark = "remark";
  static String logo_url = "logo_url";
  static String store_logo = "store_logo";
  static String national_identity_card_url = "national_identity_card_url";
  static String address_proof_url = "address_proof_url";
  static String address_proof = "address_proof";
  static String order_note = "order_note";
  static String address = "address";
  static String bonus = "bonus";
  static String bonusType = "bonus_type";
  static String driving_license = "driving_license";
  static String national_identity_card = "national_identity_card";
  static String national_id_card = "national_id_card";
  static String dob = "dob";
  static String bank_account_number = "bank_account_number";
  static String other_payment_information = "other_payment_information";
  static String is_available = "is_available";
  static String cash_received = "cash_received";
  static String pending_order_count = "pending_order_count";
  static String meta_title = "meta_title";
  static String meta_keywords = "meta_keywords";
  static String schema_markup = "schema_markup";
  static String meta_description = "meta_description";
  static String cities = "cities";

  //Category api params
  static String categoryId = "category_id";

  //Order update api params
  static String orderId = "order_id";
  static String orderStatus = "order_status";
  static String statusId = "status_id";
  static String deliveryBoyId = "delivery_boy_id";

  //App Settings api params
  static String currency = "currency";
  static String currencyCode = "currency_code";
  static String currencyDecimalPoint = "decimal_point";
  static String appMode = "app_mode_seller";
  static String privacyPolicy = "privacy_policy_seller";
  static String termsCondition = "terms_conditions_seller";
  static String allPermissions = "allPermissions";

  //Notification setting api params
  static String statusIds = "status_ids";
  static String mailStatuses = "mail_statuses";
  static String mobileStatuses = "mobile_statuses";

  //Language api params
  static String system_type = "system_type";
  static String is_default = "is_default";

  //Orders params
  static String startDeliveryDate = "startDeliveryDate";
  static String endDeliveryDate = "endDeliveryDate";
  static String search = "search";
  static String filter = "filter";
  static String file = "file";

  static String groupId = "group_id";
  static String startDate = "startDate";
  static String endDate = "endDate";
  static String sellerId = "seller_id";
  static String prompt = "prompt";
  static String source = "source";
}
