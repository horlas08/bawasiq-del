class WithdrawalRequests {
  String? status;
  String? message;
  String? total;
  Data? data;

  WithdrawalRequests({this.status, this.message, this.total, this.data});

  WithdrawalRequests.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<WithdrawRequests>? withdrawRequests;
  String? balance;

  Data({this.withdrawRequests, this.balance});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['withdraw_requests'] != null) {
      withdrawRequests = <WithdrawRequests>[];
      json['withdraw_requests'].forEach((v) {
        withdrawRequests!.add(new WithdrawRequests.fromJson(v));
      });
    }
    balance = json['balance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.withdrawRequests != null) {
      data['withdraw_requests'] =
          this.withdrawRequests!.map((v) => v.toJson()).toList();
    }
    data['balance'] = this.balance;
    return data;
  }
}

class WithdrawRequests {
  String? id;
  String? type;
  String? name;
  String? balance;
  String? amount;
  String? message;
  String? status;
  String? remark;
  String? receiptImageUrl;
  String? deviceType;
  String? createdAt;

  WithdrawRequests(
      {this.id,
      this.type,
      this.name,
      this.balance,
      this.amount,
      this.message,
      this.status,
      this.remark,
      this.receiptImageUrl,
      this.deviceType,
      this.createdAt});

  WithdrawRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    type = json['type'].toString();
    name = json['name'].toString();
    balance = json['balance'].toString();
    amount = json['amount'].toString();
    message = json['message'].toString();
    status = json['status'].toString();
    remark = json['remark'].toString();
    receiptImageUrl = json['receipt_image_url'].toString();
    deviceType = json['device_type'].toString();
    createdAt = json['created_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['balance'] = this.balance;
    data['amount'] = this.amount;
    data['message'] = this.message;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['receipt_image_url'] = this.receiptImageUrl;
    data['device_type'] = this.deviceType;
    data['created_at'] = this.createdAt;
    return data;
  }
}
