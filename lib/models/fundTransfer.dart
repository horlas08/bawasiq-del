class FundTransferData {
  String? name;
  String? mobile;
  String? address;
  String? id;
  String? deliveryBoyId;
  String? type;
  String? openingBalance;
  String? closingBalance;
  String? amount;
  String? status;
  String? message;
  String? createdAt;
  String? updatedAt;

  FundTransferData(
      {this.name,
      this.mobile,
      this.address,
      this.id,
      this.deliveryBoyId,
      this.type,
      this.openingBalance,
      this.closingBalance,
      this.amount,
      this.status,
      this.message,
      this.createdAt,
      this.updatedAt});

  FundTransferData.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    mobile = json['mobile'].toString();
    address = json['address'].toString();
    id = json['id'].toString();
    deliveryBoyId = json['delivery_boy_id'].toString();
    type = json['type'].toString();
    openingBalance = json['opening_balance'].toString();
    closingBalance = json['closing_balance'].toString();
    amount = json['amount'].toString();
    status = json['status'].toString();
    message = json['message'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }
}
