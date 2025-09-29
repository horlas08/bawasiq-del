class Brand {
  String? status;
  String? message;
  String? total;
  List<BrandData>? data;

  Brand({this.status, this.message, this.total, this.data});

  Brand.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <BrandData>[];
      json['data'].forEach((v) {
        data!.add(new BrandData.fromJson(v));
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

class BrandData {
  String? id;
  String? name;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  BrandData(
      {this.id,
      this.name,
      this.image,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.imageUrl});

  BrandData.fromJson(Map<String, dynamic> json) {
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
