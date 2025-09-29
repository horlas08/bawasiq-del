class FilterProducts {
  String? status;
  String? message;
  String? total;
  FilterProductsData? data;

  FilterProducts({this.status, this.message, this.total, this.data});

  FilterProducts.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null
        ? new FilterProductsData.fromJson(json['data'])
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

class FilterProductsData {
  List<FilterProductsDataProducts>? products;

  FilterProductsData({this.products});

  FilterProductsData.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <FilterProductsDataProducts>[];
      json['products'].forEach((v) {
        products!.add(new FilterProductsDataProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterProductsDataProducts {
  String? productId;
  String? id;
  String? sellerId;
  String? rowOrder;
  String? name;
  String? tags;
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
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? sellerName;
  String? tillStatusName;
  String? productVariantId;
  String? price;
  String? discountedPrice;
  String? measurement;
  String? pvStatus;
  String? stock;
  String? stockUnitId;
  String? shortCode;
  String? stockUnit;

  FilterProductsDataProducts(
      {this.productId,
      this.id,
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
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.sellerName,
      this.tillStatusName,
      this.productVariantId,
      this.price,
      this.discountedPrice,
      this.measurement,
      this.pvStatus,
      this.stock,
      this.stockUnitId,
      this.shortCode,
      this.stockUnit});

  FilterProductsDataProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'].toString();
    id = json['id'].toString();
    sellerId = json['seller_id'].toString();
    rowOrder = json['row_order'].toString();
    name = json['name'].toString();
    tags = json['tags'].toString();
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
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    sellerName = json['seller_name'].toString();
    tillStatusName = json['till_status_name'].toString();
    productVariantId = json['product_variant_id'].toString();
    price = json['price'].toString();
    discountedPrice = json['discounted_price'].toString();
    measurement = json['measurement'].toString();
    pvStatus = json['pv_status'].toString();
    stock = json['stock'].toString();
    stockUnitId = json['stock_unit_id'].toString();
    shortCode = json['short_code'].toString();
    stockUnit = json['stock_unit'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['seller_name'] = this.sellerName;
    data['till_status_name'] = this.tillStatusName;
    data['product_variant_id'] = this.productVariantId;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    data['measurement'] = this.measurement;
    data['pv_status'] = this.pvStatus;
    data['stock'] = this.stock;
    data['stock_unit_id'] = this.stockUnitId;
    data['short_code'] = this.shortCode;
    data['stock_unit'] = this.stockUnit;
    return data;
  }
}
