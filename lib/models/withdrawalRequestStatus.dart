class WithdrawalRequestStatus {
  String? status;
  String? name;

  WithdrawalRequestStatus({this.status, this.name});

  WithdrawalRequestStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    name = json['name'].toString();
  }
}
