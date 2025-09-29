class WalletHistory {
  String? status;
  String? message;
  String? total;
  List<WalletHistoryData>? data;

  WalletHistory({this.status, this.message, this.total, this.data});

  WalletHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <WalletHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new WalletHistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletHistoryData {
  String? name;
  String? id;
  String? orderId;
  String? orderItemId;
  String? sellerId;
  String? type;
  String? amount;
  String? message;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? productName;
  String? variantName;

  WalletHistoryData(
      {this.name,
      this.id,
      this.orderId,
      this.orderItemId,
      this.sellerId,
      this.type,
      this.amount,
      this.message,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.productName,
      this.variantName});

  WalletHistoryData.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    id = json['id'].toString();
    orderId = json['order_id'].toString();
    orderItemId = json['order_item_id'].toString();
    sellerId = json['seller_id'].toString();
    type = json['type'].toString();
    amount = json['amount'].toString();
    message = json['message'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    productName = json['product_name'].toString();
    variantName = json['variant_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['order_item_id'] = this.orderItemId;
    data['seller_id'] = this.sellerId;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['message'] = this.message;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_name'] = this.productName;
    data['variant_name'] = this.variantName;
    return data;
  }
}
