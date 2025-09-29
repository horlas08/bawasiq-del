class Units {
  String? status;
  String? message;
  String? total;
  List<MeasurementUnitData>? data;

  Units({this.status, this.message, this.total, this.data});

  Units.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <MeasurementUnitData>[];
      json['data'].forEach((v) {
        data!.add(new MeasurementUnitData.fromJson(v));
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

class MeasurementUnitData {
  String? id;
  String? name;
  String? shortCode;
  String? parentId;
  String? conversion;

  MeasurementUnitData(
      {this.id, this.name, this.shortCode, this.parentId, this.conversion});

  MeasurementUnitData.fromJson(Map<String, dynamic> json) {
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
