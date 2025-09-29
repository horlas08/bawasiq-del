import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/ratingsAndReview.dart';

enum RatingState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class RatingListProvider extends ChangeNotifier {
  RatingState ratingState = RatingState.initial;
  String message = '';
  List<ProductRatingList> ratings = [];
  late ProductRatingData productRatingData;
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  List<String> images = [];
  int imagesOffset = 0;
  int totalImages = 0;
  bool hasMoreImages = false;

  Future getRatingApiProvider({
    required Map<String, String> params,
    required BuildContext context,
    String? limit,
  }) async {
    if (offset == 0) {
      ratingState = RatingState.loading;
    } else {
      ratingState = RatingState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          limit ?? Constant.defaultImagesLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> ratingData =
          await getRatingsList(context: context, params: params);
      if (ratingData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(ratingData[ApiAndParams.total].toString());
        ProductRating productRating = ProductRating.fromJson(ratingData);
        productRatingData = productRating.data!;

        List<ProductRatingList> tempRatings =
            productRating.data?.ratingList ?? [];

        ratings.addAll(tempRatings);

        hasMoreData = totalData > ratings.length;
        if (hasMoreData) {
          offset += Constant.defaultImagesLoadLimitAtOnce;
        }

        ratingState = RatingState.loaded;
        notifyListeners();
      } else {
        message = ratingData[ApiAndParams.message];
        ratingState = RatingState.empty;
        notifyListeners();
      }
    }catch (e) {
      message = e.toString();
      ratingState = RatingState.error;
      notifyListeners();
      rethrow;
    }
  }
}
