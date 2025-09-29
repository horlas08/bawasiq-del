class Tax {
  String? status;
  String? message;
  String? total;
  List<TaxesData>? data;

  Tax({this.status, this.message, this.total, this.data});

  Tax.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <TaxesData>[];
      json['data'].forEach((v) {
        data!.add(new TaxesData.fromJson(v));
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

class TaxesData {
  String? id;
  String? title;
  String? percentage;
  String? status;

  TaxesData({this.id, this.title, this.percentage, this.status});

  TaxesData.fromJson(Map<String, dynamic> json) {
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
