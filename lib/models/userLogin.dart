class UserLogin {
  String? status;
  String? message;
  String? total;
  UserLoginData? data;

  UserLogin({this.status, this.message, this.total, this.data});

  UserLogin.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data =
        json['data'] != null ? new UserLoginData.fromJson(json['data']) : null;
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

class UserLoginData {
  UserLoginUser? user;
  String? accessToken;

  UserLoginData({this.user, this.accessToken});

  UserLoginData.fromJson(Map<String, dynamic> json) {
    user =
        json['user'] != null ? new UserLoginUser.fromJson(json['user']) : null;
    accessToken = json['access_token'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['access_token'] = this.accessToken;
    return data;
  }
}

class UserLoginUser {
  String? id;
  String? username;
  String? email;
  String? roleId;
  String? createdBy;
  String? forgotPasswordCode;
  String? fcmId;
  String? rememberToken;
  String? status;
  String? loginAt;
  String? lastActiveAt;
  String? createdAt;
  String? updatedAt;
  List<String>? allPermissions;
  String? sellerStatus;
  String? deliveryBoyStatus;
  UserLoginSeller? seller;
  Role? role;
  UserLoginDeliveryBoy? deliveryBoy;

  UserLoginUser(
      {this.id,
      this.username,
      this.email,
      this.roleId,
      this.createdBy,
      this.forgotPasswordCode,
      this.fcmId,
      this.rememberToken,
      this.status,
      this.loginAt,
      this.lastActiveAt,
      this.createdAt,
      this.updatedAt,
      this.allPermissions,
      this.sellerStatus,
      this.deliveryBoyStatus,
      this.seller,
      this.role,
      this.deliveryBoy});

  UserLoginUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    username = json['username'].toString();
    email = json['email'].toString();
    roleId = json['role_id'].toString();
    createdBy = json['created_by'].toString();
    forgotPasswordCode = json['forgot_password_code'].toString();
    fcmId = json['fcm_id'].toString();
    rememberToken = json['remember_token'].toString();
    status = json['status'].toString();
    loginAt = json['login_at'].toString();
    lastActiveAt = json['last_active_at'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    allPermissions = json['allPermissions'].cast<String>();
    sellerStatus = json['seller_status'].toString();
    deliveryBoyStatus = json['delivery_boy_status'].toString();
    seller = json['seller'] != null
        ? new UserLoginSeller.fromJson(json['seller'])
        : null;
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    deliveryBoy = json['delivery_boy'] != null
        ? new UserLoginDeliveryBoy.fromJson(json['delivery_boy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['role_id'] = this.roleId;
    data['created_by'] = this.createdBy;
    data['forgot_password_code'] = this.forgotPasswordCode;
    data['fcm_id'] = this.fcmId;
    data['remember_token'] = this.rememberToken;
    data['status'] = this.status;
    data['login_at'] = this.loginAt;
    data['last_active_at'] = this.lastActiveAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['allPermissions'] = this.allPermissions;
    data['seller_status'] = this.sellerStatus;
    data['delivery_boy_status'] = this.deliveryBoyStatus;
    if (this.seller != null) {
      data['seller'] = this.seller!.toJson();
    }
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    if (this.deliveryBoy != null) {
      data['delivery_boy'] = this.deliveryBoy!.toJson();
    }
    return data;
  }
}

class UserLoginSeller {
  String? id;
  String? adminId;
  String? name;
  String? storeName;
  String? slug;
  String? email;
  String? mobile;
  String? balance;
  String? storeUrl;
  String? logo;
  String? storeDescription;
  String? street;
  String? pincodeId;
  String? cityId;
  String? state;
  String? categories;
  String? accountNumber;
  String? bankIfscCode;
  String? accountName;
  String? bankName;
  String? commission;
  String? status;
  String? requireProductsApproval;
  String? fcmId;
  String? nationalIdentityCard;
  String? addressProof;
  String? panNumber;
  String? taxName;
  String? taxNumber;
  String? customerPrivacy;
  String? latitude;
  String? longitude;
  String? placeName;
  String? formattedAddress;
  String? forgotPasswordCode;
  String? viewOrderOtp;
  String? assignDeliveryBoy;
  String? fssaiLicNo;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? remark;
  String? changeOrderStatusDelivered;
  String? logoUrl;
  String? nationalIdentityCardUrl;
  String? addressProofUrl;
  String? categoriesArray;

  UserLoginSeller(
      {this.id,
      this.adminId,
      this.name,
      this.storeName,
      this.slug,
      this.email,
      this.mobile,
      this.balance,
      this.storeUrl,
      this.logo,
      this.storeDescription,
      this.street,
      this.pincodeId,
      this.cityId,
      this.state,
      this.categories,
      this.accountNumber,
      this.bankIfscCode,
      this.accountName,
      this.bankName,
      this.commission,
      this.status,
      this.requireProductsApproval,
      this.fcmId,
      this.nationalIdentityCard,
      this.addressProof,
      this.panNumber,
      this.taxName,
      this.taxNumber,
      this.customerPrivacy,
      this.latitude,
      this.longitude,
      this.placeName,
      this.formattedAddress,
      this.forgotPasswordCode,
      this.viewOrderOtp,
      this.assignDeliveryBoy,
      this.fssaiLicNo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.remark,
      this.changeOrderStatusDelivered,
      this.logoUrl,
      this.nationalIdentityCardUrl,
      this.addressProofUrl,
      this.categoriesArray});

  UserLoginSeller.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    adminId = json['admin_id'].toString();
    name = json['name'].toString();
    storeName = json['store_name'].toString();
    slug = json['slug'].toString();
    email = json['email'].toString();
    mobile = json['mobile'].toString();
    balance = json['balance'].toString();
    storeUrl = json['store_url']??"";
    logo = json['logo'].toString();
    storeDescription = json['store_description'].toString();
    street = json['street'].toString();
    pincodeId = json['pincode_id'].toString();
    cityId = json['city_id'].toString();
    state = json['state'].toString();
    categories = json['categories'].toString();
    accountNumber = json['account_number'].toString();
    bankIfscCode = json['bank_ifsc_code'].toString();
    accountName = json['account_name'].toString();
    bankName = json['bank_name'].toString();
    commission = json['commission'].toString();
    status = json['status'].toString();
    requireProductsApproval = json['require_products_approval'].toString();
    fcmId = json['fcm_id'].toString();
    nationalIdentityCard = json['national_identity_card'].toString();
    addressProof = json['address_proof'].toString();
    panNumber = json['pan_number'].toString();
    taxName = json['tax_name']??"";
    taxNumber = json['tax_number']??"";
    customerPrivacy = json['customer_privacy'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    placeName = json['place_name'].toString();
    formattedAddress = json['formatted_address'].toString();
    forgotPasswordCode = json['forgot_password_code'].toString();
    viewOrderOtp = json['view_order_otp'].toString();
    assignDeliveryBoy = json['assign_delivery_boy'].toString();
    fssaiLicNo = json['fssai_lic_no'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    remark = json['remark'].toString();
    changeOrderStatusDelivered =
        json['change_order_status_delivered'].toString();
    logoUrl = json['logo_url'].toString();
    nationalIdentityCardUrl = json['national_identity_card_url'].toString();
    addressProofUrl = json['address_proof_url'].toString();
    categoriesArray = json['categories_array'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin_id'] = this.adminId;
    data['name'] = this.name;
    data['store_name'] = this.storeName;
    data['slug'] = this.slug;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['balance'] = this.balance;
    data['store_url'] = this.storeUrl;
    data['logo'] = this.logo;
    data['store_description'] = this.storeDescription;
    data['street'] = this.street;
    data['pincode_id'] = this.pincodeId;
    data['city_id'] = this.cityId;
    data['state'] = this.state;
    data['categories'] = this.categories;
    data['account_number'] = this.accountNumber;
    data['bank_ifsc_code'] = this.bankIfscCode;
    data['account_name'] = this.accountName;
    data['bank_name'] = this.bankName;
    data['commission'] = this.commission;
    data['status'] = this.status;
    data['require_products_approval'] = this.requireProductsApproval;
    data['fcm_id'] = this.fcmId;
    data['national_identity_card'] = this.nationalIdentityCard;
    data['address_proof'] = this.addressProof;
    data['pan_number'] = this.panNumber;
    data['tax_name'] = this.taxName;
    data['tax_number'] = this.taxNumber;
    data['customer_privacy'] = this.customerPrivacy;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['place_name'] = this.placeName;
    data['formatted_address'] = this.formattedAddress;
    data['forgot_password_code'] = this.forgotPasswordCode;
    data['view_order_otp'] = this.viewOrderOtp;
    data['assign_delivery_boy'] = this.assignDeliveryBoy;
    data['fssai_lic_no'] = this.fssaiLicNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['remark'] = this.remark;
    data['change_order_status_delivered'] = this.changeOrderStatusDelivered;
    data['logo_url'] = this.logoUrl;
    data['national_identity_card_url'] = this.nationalIdentityCardUrl;
    data['address_proof_url'] = this.addressProofUrl;
    data['categories_array'] = this.categoriesArray;
    return data;
  }
}

class Role {
  String? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;

  Role({this.id, this.name, this.guardName, this.createdAt, this.updatedAt});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    guardName = json['guard_name'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class UserLoginDeliveryBoy {
  String? id;
  String? adminId;
  String? cityId;
  String? name;
  String? mobile;
  String? orderNote;
  String? address;
  String? bonusType;
  String? bonusPercentage;
  String? bonusMinAmount;
  String? bonusMaxAmount;
  String? balance;
  String? drivingLicense;
  String? nationalIdentityCard;
  String? dob;
  String? bankAccountNumber;
  String? bankName;
  String? accountName;
  String? ifscCode;
  String? otherPaymentInformation;
  String? status;
  String? isAvailable;
  String? fcmId;
  String? pincodeId;
  String? cashReceived;
  String? createdAt;
  String? updatedAt;
  String? remark;
  String? pendingOrderCount;

  UserLoginDeliveryBoy(
      {this.id,
      this.adminId,
      this.cityId,
      this.name,
      this.mobile,
      this.orderNote,
      this.address,
      this.bonusType,
      this.bonusPercentage,
      this.bonusMinAmount,
      this.bonusMaxAmount,
      this.balance,
      this.drivingLicense,
      this.nationalIdentityCard,
      this.dob,
      this.bankAccountNumber,
      this.bankName,
      this.accountName,
      this.ifscCode,
      this.otherPaymentInformation,
      this.status,
      this.isAvailable,
      this.fcmId,
      this.pincodeId,
      this.cashReceived,
      this.createdAt,
      this.updatedAt,
      this.remark,
      this.pendingOrderCount});

  UserLoginDeliveryBoy.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    adminId = json['admin_id'].toString();
    cityId = json['city_id'].toString();
    name = json['name'].toString();
    mobile = json['mobile'].toString();
    orderNote = json['order_note'].toString();
    address = json['address'].toString();
    bonusType = json['bonus_type'].toString();
    bonusPercentage = json['bonus_percentage'].toString();
    bonusMinAmount = json['bonus_min_amount'].toString();
    bonusMaxAmount = json['bonus_max_amount'].toString();
    balance = json['balance'].toString();
    drivingLicense = json['driving_license'].toString();
    nationalIdentityCard = json['national_identity_card'].toString();
    dob = json['dob'].toString();
    bankAccountNumber = json['bank_account_number'].toString();
    bankName = json['bank_name'].toString();
    accountName = json['account_name'].toString();
    ifscCode = json['ifsc_code'].toString();
    otherPaymentInformation = json['other_payment_information'].toString();
    status = json['status'].toString();
    isAvailable = json['is_available'].toString();
    fcmId = json['fcm_id'].toString();
    pincodeId = json['pincode_id'].toString();
    cashReceived = json['cash_received'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    remark = json['remark'].toString();
    pendingOrderCount = json['pending_order_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin_id'] = this.adminId;
    data['city_id'] = this.cityId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['order_note'] = this.orderNote;
    data['address'] = this.address;
    data['bonus_type'] = this.bonusType;
    data['bonus_percentage'] = this.bonusPercentage;
    data['bonus_min_amount'] = this.bonusMinAmount;
    data['bonus_max_amount'] = this.bonusMaxAmount;
    data['balance'] = this.balance;
    data['driving_license'] = this.drivingLicense;
    data['national_identity_card'] = this.nationalIdentityCard;
    data['dob'] = this.dob;
    data['bank_account_number'] = this.bankAccountNumber;
    data['bank_name'] = this.bankName;
    data['account_name'] = this.accountName;
    data['ifsc_code'] = this.ifscCode;
    data['other_payment_information'] = this.otherPaymentInformation;
    data['status'] = this.status;
    data['is_available'] = this.isAvailable;
    data['fcm_id'] = this.fcmId;
    data['pincode_id'] = this.pincodeId;
    data['cash_received'] = this.cashReceived;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['remark'] = this.remark;
    data['pending_order_count'] = this.pendingOrderCount;
    return data;
  }
}
