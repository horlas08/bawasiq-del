import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/tax.dart';

class TaxesListScreen extends StatefulWidget {
  const TaxesListScreen({super.key});

  @override
  State<TaxesListScreen> createState() => _TaxesListScreenState();
}

class _TaxesListScreenState extends State<TaxesListScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
        (value) => context.read<TaxProvider>().getTaxes(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: taxesLabel,
        ),
      ),
      body: Consumer<TaxProvider>(
        builder: (context, taxProvider, child) {
          if (taxProvider.taxesState == TaxesState.loading) {
            return Column(
              children: List.generate(
                5,
                (index) => CustomShimmer(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width,
                  borderRadius: 10,
                  margin: EdgeInsets.all(10),
                ),
              ),
            );
          } else if (taxProvider.taxesState == TaxesState.loaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                taxProvider.tax.data?.length ?? 0,
                (index) {
                  TaxesData? taxesData = taxProvider.tax.data?[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, taxesData);
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
                          text:
                              "${taxesData?.title} (${taxesData?.percentage}%)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                      ),
                    ),
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
