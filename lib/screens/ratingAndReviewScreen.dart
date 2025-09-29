import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class RatingAndReviewScreen extends StatefulWidget {
  final String productId;

  RatingAndReviewScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<RatingAndReviewScreen> createState() => _RatingAndReviewScreenState();
}

class _RatingAndReviewScreenState extends State<RatingAndReviewScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<RatingListProvider>().hasMoreData) {
          callApi(true);
        }
      }
    }
  }

  Future callApi(bool? resetData) async {
    if (resetData == true) {
      context.read<RatingListProvider>().offset = 0;
      context.read<RatingListProvider>().ratings = [];
    }
    return context.read<RatingListProvider>().getRatingApiProvider(params: {
      ApiAndParams.productId: widget.productId,
    }, context: context);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      callApi(true);
    });

    scrollController.addListener(scrollListener);

    super.initState();
  }

  Widget customShimmerWidget(double height) {
    return CustomShimmer(
      width: context.width,
      height: height,
      margin: EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
      borderRadius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: ratingsAndReviewsLabel,
          style: TextStyle(
            color: ColorsRes.mainTextColor,
          ),
        ),
        actions: [],
      ),
      body: setRefreshIndicator(
        refreshCallback: () {
          return callApi(true);
        },
        child: Consumer<RatingListProvider>(
          builder: (context, ratingListProvider, child) {
            if (ratingListProvider.ratingState == RatingState.loading) {
              return ListView(
                children: [
                  customShimmerWidget(180),
                  customShimmerWidget(120),
                  customShimmerWidget(120),
                  customShimmerWidget(120),
                  customShimmerWidget(120),
                  customShimmerWidget(120),
                  customShimmerWidget(120),
                  customShimmerWidget(120)
                ],
              );
            } else if (ratingListProvider.ratingState == RatingState.loaded) {
              return ListView(
                shrinkWrap: true,
                controller: scrollController,
                children: [
                  Card(
                    color: Theme.of(context).cardColor,
                    surfaceTintColor: Theme.of(context).cardColor,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(10),
                      child: getOverallRatingSummary(
                        context: context,
                        productRatingData: ratingListProvider.productRatingData,
                        totalRatings: ratingListProvider.totalData.toString(),
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(ratingListProvider.ratings.length,
                        (index) {
                      ProductRatingList rating =
                          ratingListProvider.ratings[index];
                      return Card(
                        color: Theme.of(context).cardColor,
                        surfaceTintColor: Theme.of(context).cardColor,
                        margin: EdgeInsetsDirectional.only(
                            top: 10, end: 10, start: 10),
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(10),
                          child: getRatingReviewItem(
                            rating: rating,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
