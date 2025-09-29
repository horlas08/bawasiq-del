class AdditionalCharges {
  String? title;
  String? amount;

  AdditionalCharges({this.title, this.amount});

  AdditionalCharges.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['amount'] = this.amount;
    return data;
  }
}
