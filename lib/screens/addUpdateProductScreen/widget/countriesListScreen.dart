import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/countries.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  late ScrollController scrollController = ScrollController()
    ..addListener(activeOrdersScrollListener);

  void activeOrdersScrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    // var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if(scrollController.position.maxScrollExtent == scrollController.offset){// if (scrollController.position.pixels >= nextPageTrigger) {
      if (mounted) {
        if (!context.read<CountriesProvider>().isLoading && context.read<CountriesProvider>().hasMoreData) {//if (context.read<CountriesProvider>().hasMoreData) {
          context.read<CountriesProvider>().getCountries(context: context);
        }
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        context.read<CountriesProvider>().getCountries(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: countriesLabel,
        ),
      ),
      body: Consumer<CountriesProvider>(
        builder: (context, countriesProvider, child) {
          if (countriesProvider.countriesState == CountriesState.loading) {
            return ListView(
              children: List.generate(
                20,
                (index) => CustomShimmer(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width,
                  borderRadius: 10,
                  margin: EdgeInsets.all(10),
                ),
              ),
            );
          } else if (countriesProvider.countriesState ==
                  CountriesState.loaded ||
              countriesProvider.countriesState == CountriesState.loadingMore) {
            return ListView(
              controller: scrollController,
              children: List.generate(
                countriesProvider.countriesList.length,
                (index) {
                  CountriesData? countriesData =
                      countriesProvider.countriesList[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, countriesData);
                        },
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorsRes.appColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: CustomTextLabel(
                              text: "${countriesData.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsRes.mainTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (index ==
                              (countriesProvider.countriesList.length - 1) &&
                          countriesProvider.countriesState ==
                              CountriesState.loadingMore)
                        CustomShimmer(
                          height: 60,
                          width: MediaQuery.sizeOf(context).width,
                          borderRadius: 10,
                          margin: EdgeInsets.all(10),
                        ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
