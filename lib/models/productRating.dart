class ProductRating {
  String? status;
  String? message;
  String? total;
  ProductRatingData? data;

  ProductRating({this.status, this.message, this.total, this.data});

  ProductRating.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null
        ? new ProductRatingData.fromJson(json['data'])
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

class ProductRatingData {
  String? averageRating;
  String? oneStarRating;
  String? twoStarRating;
  String? threeStarRating;
  String? fourStarRating;
  String? fiveStarRating;
  List<ProductRatingList>? ratingList;

  ProductRatingData(
      {this.averageRating,
      this.oneStarRating,
      this.twoStarRating,
      this.threeStarRating,
      this.fourStarRating,
      this.fiveStarRating,
      this.ratingList});

  ProductRatingData.fromJson(Map<String, dynamic> json) {
    averageRating = json['average_rating'].toString();
    oneStarRating = json['one_star_rating'].toString();
    twoStarRating = json['two_star_rating'].toString();
    threeStarRating = json['three_star_rating'].toString();
    fourStarRating = json['four_star_rating'].toString();
    fiveStarRating = json['five_star_rating'].toString();
    if (json['rating_list'] != null) {
      ratingList = <ProductRatingList>[];
      json['rating_list'].forEach((v) {
        ratingList!.add(new ProductRatingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.averageRating;
    data['one_star_rating'] = this.oneStarRating;
    data['two_star_rating'] = this.twoStarRating;
    data['three_star_rating'] = this.threeStarRating;
    data['four_star_rating'] = this.fourStarRating;
    data['five_star_rating'] = this.fiveStarRating;
    if (this.ratingList != null) {
      data['rating_list'] = this.ratingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductRatingList {
  String? id;
  String? productId;
  String? userId;
  String? rate;
  String? review;
  String? status;
  String? updatedAt;
  ProductRatingUser? user;
  List<ProductRatingImages>? images;

  ProductRatingList(
      {this.id,
      this.productId,
      this.userId,
      this.rate,
      this.review,
      this.status,
      this.updatedAt,
      this.user,
      this.images});

  ProductRatingList.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productId = json['product_id'].toString();
    userId = json['user_id'].toString();
    rate = json['rate'].toString();
    review = json['review'].toString();
    status = json['status'].toString();
    updatedAt = json['updated_at'].toString();
    user = json['user'] != null
        ? new ProductRatingUser.fromJson(json['user'])
        : null;
    if (json['images'] != null) {
      images = <ProductRatingImages>[];
      json['images'].forEach((v) {
        images!.add(new ProductRatingImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    data['rate'] = this.rate;
    data['review'] = this.review;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductRatingUser {
  String? id;
  String? name;
  String? profile;

  ProductRatingUser({this.id, this.name, this.profile});

  ProductRatingUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    profile = json['profile'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile'] = this.profile;
    return data;
  }
}

class ProductRatingImages {
  String? id;
  String? productRatingId;
  String? image;
  String? imageUrl;

  ProductRatingImages(
      {this.id, this.productRatingId, this.image, this.imageUrl});

  ProductRatingImages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productRatingId = json['product_rating_id'].toString();
    image = json['image'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_rating_id'] = this.productRatingId;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
