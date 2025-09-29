import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class ProductTypeScreen extends StatefulWidget {
  const ProductTypeScreen({super.key});

  @override
  State<ProductTypeScreen> createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends State<ProductTypeScreen> {
  late ScrollController scrollController = ScrollController()
    ..addListener(activeOrdersScrollListener);

  void activeOrdersScrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels >= nextPageTrigger) {
      if (mounted) {
        if (context.read<CountriesProvider>().hasMoreData) {
          // context.read<ProductTypeScreen>().getProductTypes(context: context);
        }
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      // context.read<CountriesProvider>().getCountries(context: context)
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: productTypeLabel,
        ),
      ),
      body: Consumer<ProductTypeProvider>(
        builder: (context, productTypeProvider, child) {
          return ListView(
            controller: scrollController,
            children: List.generate(
              productTypeProvider.productTypes.length,
              (index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                            context, productTypeProvider.productTypes[index]);
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
                            text: "${productTypeProvider.productTypes[index]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorsRes.mainTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
