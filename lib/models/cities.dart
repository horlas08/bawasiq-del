class City {
  String? status;
  String? message;
  String? total;
  CityData? data;

  City({this.status, this.message, this.total, this.data});

  City.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null ? new CityData.fromJson(json['data']) : null;
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

class CityData {
  String? total;
  List<Cities>? cities;

  CityData({this.total, this.cities});

  CityData.fromJson(Map<String, dynamic> json) {
    total = json['total'].toString();
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String? id;
  String? name;
  String? state;
  String? formattedAddress;
  String? latitude;
  String? longitude;

  Cities({
    this.id,
    this.name,
    this.state,
    this.formattedAddress,
    this.latitude,
    this.longitude,
  });

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    state = json['state'].toString();
    formattedAddress = json['formatted_address'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state'] = this.state;
    data['formatted_address'] = this.formattedAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
