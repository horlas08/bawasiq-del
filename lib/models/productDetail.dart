import 'package:project/models/tags.dart';

class ProductDetail {
  String? status;
  String? message;
  String? total;
  ProductDetailData? data;

  ProductDetail({this.status, this.message, this.total, this.data});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null
        ? new ProductDetailData.fromJson(json['data'])
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

class ProductDetailData {
  String? id;
  String? sellerId;
  String? rowOrder;
  String? name;
  List<TagsData>? tags;
  String? taxId;
  String? brandId;
  String? slug;
  String? categoryId;
  String? indicator;
  String? manufacturer;
  String? madeIn;
  String? returnStatus;
  String? cancelableStatus;
  String? tillStatus;
  String? image;
  String? otherImages;
  String? description;
  String? status;
  String? isApproved;
  String? returnDays;
  String? type;
  String? isUnlimitedStock;
  String? codAllowed;
  String? totalAllowedQuantity;
  String? taxIncludedInPrice;
  String? fssaiLicNo;
  String? imageUrl;
  ProductDetailSeller? seller;
  List<ProductDetailImages>? images;
  List<ProductDetailVariants>? variants;
  ProductDetailCategory? category;
  ProductDetailBrand? brand;
  ProductDetailTax? tax;
  ProductDetailMadeInCountry? madeInCountry;
  String? metaTitle;
  String? metaKeywords;
  String? schemaMarkup;
  String? metaDescription;
  String? barcode;

  ProductDetailData(
      {this.id,
      this.sellerId,
      this.rowOrder,
      this.name,
      this.tags,
      this.taxId,
      this.brandId,
      this.slug,
      this.categoryId,
      this.indicator,
      this.manufacturer,
      this.madeIn,
      this.returnStatus,
      this.cancelableStatus,
      this.tillStatus,
      this.image,
      this.otherImages,
      this.description,
      this.status,
      this.isApproved,
      this.returnDays,
      this.type,
      this.isUnlimitedStock,
      this.codAllowed,
      this.totalAllowedQuantity,
      this.taxIncludedInPrice,
      this.fssaiLicNo,
      this.imageUrl,
      this.seller,
      this.images,
      this.variants,
      this.category,
      this.tax,
      this.madeInCountry,
      this.metaTitle,
      this.metaKeywords,
      this.schemaMarkup,
      this.metaDescription,
      this.barcode
  });

  ProductDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    sellerId = json['seller_id'].toString();
    rowOrder = json['row_order'].toString();
    name = json['name'].toString();
    if (json['tags'] != null && json['tags'] != "") {
      tags = <TagsData>[];
      json['tags'].forEach((v) {
        tags!.add(new TagsData.fromJson(v));
      });
    } else {
      tags = <TagsData>[];
    }
    taxId = json['tax_id'].toString();
    brandId = json['brand_id'].toString();
    slug = json['slug'].toString();
    categoryId = json['category_id'].toString();
    indicator = json['indicator'].toString();
    manufacturer = json['manufacturer'].toString();
    madeIn = json['made_in'].toString();
    returnStatus = json['return_status'].toString();
    cancelableStatus = json['cancelable_status'].toString();
    tillStatus = json['till_status'].toString();
    image = json['image'].toString();
    otherImages = json['other_images'].toString();
    description = json['description'].toString();
    status = json['status'].toString();
    isApproved = json['is_approved'].toString();
    returnDays = json['return_days'].toString();
    type = json['type'].toString();
    isUnlimitedStock = json['is_unlimited_stock'].toString();
    codAllowed = json['cod_allowed'].toString();
    totalAllowedQuantity = json['total_allowed_quantity'].toString();
    taxIncludedInPrice = json['tax_included_in_price'].toString();
    fssaiLicNo = json['fssai_lic_no'].toString();
    imageUrl = json['image_url'].toString();
    seller = json['seller'] != null
        ? new ProductDetailSeller.fromJson(json['seller'])
        : null;
    if (json['images'] != null) {
      images = <ProductDetailImages>[];
      json['images'].forEach((v) {
        images!.add(new ProductDetailImages.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <ProductDetailVariants>[];
      json['variants'].forEach((v) {
        variants!.add(new ProductDetailVariants.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new ProductDetailCategory.fromJson(json['category'])
        : null;
    brand = json['brand'] != null
        ? new ProductDetailBrand.fromJson(json['brand'])
        : null;
    tax =
        json['tax'] != null ? new ProductDetailTax.fromJson(json['tax']) : null;
    madeInCountry = json['made_in_country'] != null
        ? new ProductDetailMadeInCountry.fromJson(json['made_in_country'])
        : null;
    metaTitle = json['meta_title'] ?? "";
    metaKeywords = json['meta_keywords'] ?? "";
    schemaMarkup = json['schema_markup'] ?? "";
    metaDescription = json['meta_description'] ?? "";
    barcode = json['barcode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seller_id'] = this.sellerId;
    data['row_order'] = this.rowOrder;
    data['name'] = this.name;
    data['tags'] = this.tags;
    data['tax_id'] = this.taxId;
    data['brand_id'] = this.brandId;
    data['slug'] = this.slug;
    data['category_id'] = this.categoryId;
    data['indicator'] = this.indicator;
    data['manufacturer'] = this.manufacturer;
    data['made_in'] = this.madeIn;
    data['return_status'] = this.returnStatus;
    data['cancelable_status'] = this.cancelableStatus;
    data['till_status'] = this.tillStatus;
    data['image'] = this.image;
    data['other_images'] = this.otherImages;
    data['description'] = this.description;
    data['status'] = this.status;
    data['is_approved'] = this.isApproved;
    data['return_days'] = this.returnDays;
    data['type'] = this.type;
    data['is_unlimited_stock'] = this.isUnlimitedStock;
    data['cod_allowed'] = this.codAllowed;
    data['total_allowed_quantity'] = this.totalAllowedQuantity;
    data['tax_included_in_price'] = this.taxIncludedInPrice;
    data['fssai_lic_no'] = this.fssaiLicNo;
    data['image_url'] = this.imageUrl;
    if (this.seller != null) {
      data['seller'] = this.seller!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['tax'] = this.tax;
    data['made_in_country'] = this.madeInCountry;
    data['barcode'] = this.barcode;
    return data;
  }
}

class ProductDetailSeller {
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

  ProductDetailSeller(
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
      this.addressProofUrl});

  ProductDetailSeller.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    adminId = json['admin_id'].toString();
    name = json['name'].toString();
    storeName = json['store_name'].toString();
    slug = json['slug'].toString();
    email = json['email'].toString();
    mobile = json['mobile'].toString();
    balance = json['balance'].toString();
    storeUrl = json['store_url'].toString();
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
    taxName = json['tax_name'].toString();
    taxNumber = json['tax_number'].toString();
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
    return data;
  }
}

class ProductDetailImages {
  String? id;
  String? productId;
  String? productVariantId;
  String? image;
  String? imageUrl;

  ProductDetailImages(
      {this.id,
      this.productId,
      this.productVariantId,
      this.image,
      this.imageUrl});

  ProductDetailImages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productId = json['product_id'].toString();
    productVariantId = json['product_variant_id'].toString();
    image = json['image'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_variant_id'] = this.productVariantId;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class ProductDetailVariants {
  String? id;
  String? productId;
  String? type;
  String? status;
  String? measurement;
  String? price;
  String? discountedPrice;
  String? stock;
  String? stockUnitId;
  List<String>? images;
  Unit? unit;

  ProductDetailVariants(
      {this.id,
      this.productId,
      this.type,
      this.status,
      this.measurement,
      this.price,
      this.discountedPrice,
      this.stock,
      this.stockUnitId,
      this.images,
      this.unit});

  ProductDetailVariants.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productId = json['product_id'].toString();
    type = json['type'].toString();
    status = json['status'].toString();
    measurement = json['measurement'].toString();
    price = json['price'].toString();
    discountedPrice = json['discounted_price'].toString();
    stock = json['stock'].toString();
    stockUnitId = json['stock_unit_id'].toString();
    images = json['images'].cast<String>();
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['type'] = this.type;
    data['status'] = this.status;
    data['measurement'] = this.measurement;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    data['stock'] = this.stock;
    data['stock_unit_id'] = this.stockUnitId;
    data['images'] = this.images;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    return data;
  }
}

class Unit {
  String? id;
  String? name;
  String? shortCode;
  String? parentId;
  String? conversion;

  Unit({this.id, this.name, this.shortCode, this.parentId, this.conversion});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    shortCode = json['short_code'].toString();
    parentId = json['parent_id'].toString();
    conversion = json['conversion'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_code'] = this.shortCode;
    data['parent_id'] = this.parentId;
    data['conversion'] = this.conversion;
    return data;
  }
}

class ProductDetailCategory {
  String? id;
  String? rowOrder;
  String? name;
  String? slug;
  String? subtitle;
  String? image;
  String? status;
  String? productRating;
  String? webImage;
  String? parentId;
  String? imageUrl;
  bool? hasChild;
  bool? hasActiveChild;
  List<String>? catActiveChilds;

  ProductDetailCategory(
      {this.id,
      this.rowOrder,
      this.name,
      this.slug,
      this.subtitle,
      this.image,
      this.status,
      this.productRating,
      this.webImage,
      this.parentId,
      this.imageUrl,
      this.hasChild,
      this.hasActiveChild,
      this.catActiveChilds});

  ProductDetailCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    rowOrder = json['row_order'].toString();
    name = json['name'].toString();
    slug = json['slug'].toString();
    subtitle = json['subtitle'].toString();
    image = json['image'].toString();
    status = json['status'].toString();
    productRating = json['product_rating'].toString();
    webImage = json['web_image'].toString();
    parentId = json['parent_id'].toString();
    imageUrl = json['image_url'].toString();
    hasChild = json['has_child'];
    hasActiveChild = json['has_active_child'];
    catActiveChilds = json['cat_active_childs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['row_order'] = this.rowOrder;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['subtitle'] = this.subtitle;
    data['image'] = this.image;
    data['status'] = this.status;
    data['product_rating'] = this.productRating;
    data['web_image'] = this.webImage;
    data['parent_id'] = this.parentId;
    data['image_url'] = this.imageUrl;
    data['has_child'] = this.hasChild;
    data['has_active_child'] = this.hasActiveChild;
    data['cat_active_childs'] = this.catActiveChilds;
    return data;
  }
}

class ProductDetailBrand {
  String? id;
  String? name;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  ProductDetailBrand(
      {this.id,
      this.name,
      this.image,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.imageUrl});

  ProductDetailBrand.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    image = json['image'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class ProductDetailMadeInCountry {
  int? id;
  String? name;
  String? dialCode;
  String? code;

  ProductDetailMadeInCountry({this.id, this.name, this.dialCode, this.code});

  ProductDetailMadeInCountry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['code'] = this.code;
    return data;
  }
}

class ProductDetailTax {
  String? id;
  String? title;
  String? percentage;
  String? status;

  ProductDetailTax({this.id, this.title, this.percentage, this.status});

  ProductDetailTax.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'].toString();
    percentage = json['percentage'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['percentage'] = this.percentage;
    data['status'] = this.status;
    return data;
  }
}
