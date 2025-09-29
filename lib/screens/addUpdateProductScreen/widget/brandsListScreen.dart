import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/brand.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListState();
}

class _BrandListState extends State<BrandListScreen> {
  late ScrollController scrollController = ScrollController()
    ..addListener(activeOrdersScrollListener);

  void activeOrdersScrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<BrandProvider>().hasMoreData) {
          context.read<BrandProvider>().getBrand(
                context: context,
              );
        }
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then(
        (value) => context.read<BrandProvider>().getBrand(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: brandsLabel,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Consumer<BrandProvider>(
          builder: (context, brandProvider, child) {
            if (brandProvider.brandState == BrandState.loading) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    controller: scrollController,
                    children: [
                      Wrap(
                        runSpacing: 15,
                        spacing: constraints.maxWidth * 0.05,
                        children: List.generate(
                          18,
                          (index) {
                            return CustomShimmer(
                              width: constraints.maxWidth * 0.3,
                              height: constraints.maxWidth * 0.3,
                              borderRadius: 10,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (brandProvider.brandState == BrandState.loaded) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    controller: scrollController,
                    children: [
                      Wrap(
                        runSpacing: 15,
                        spacing: constraints.maxWidth * 0.05,
                        children: List.generate(
                          brandProvider.brands.length,
                          (index) {
                            BrandData? brandsData = brandProvider.brands[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context, brandsData);
                              },
                              child: Container(
                                width: constraints.maxWidth * 0.3,
                                height: constraints.maxWidth * 0.36,
                                decoration: DesignConfig.boxDecoration(
                                    Theme.of(context).cardColor, 8),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: setNetworkImg(
                                            image: "${brandsData.imageUrl}",
                                            width: constraints.maxWidth * 0.3,
                                            height: constraints.maxWidth * 0.3,
                                            boxFit: BoxFit.cover),
                                      ),
                                    ),
                                    CustomTextLabel(
                                      text: "${brandsData.name}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: ColorsRes.mainTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
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
