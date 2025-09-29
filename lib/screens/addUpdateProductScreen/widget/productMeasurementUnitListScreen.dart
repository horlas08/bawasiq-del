import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/measurementUnit.dart';

class MeasurementUnitListScreen extends StatefulWidget {
  const MeasurementUnitListScreen({super.key});

  @override
  State<MeasurementUnitListScreen> createState() =>
      _MeasurementUnitListScreenState();
}

class _MeasurementUnitListScreenState extends State<MeasurementUnitListScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => context
        .read<MeasurementUnitsProvider>()
        .getMeasurementUnits(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: measurementUnitsLabel,
        ),
      ),
      body: Consumer<MeasurementUnitsProvider>(
        builder: (context, measurementUnitsProvider, child) {
          if (measurementUnitsProvider.measurementUnitState ==
              MeasurementUnitsState.loading) {
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
          } else if (measurementUnitsProvider.measurementUnitState ==
              MeasurementUnitsState.loaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                measurementUnitsProvider.measurementUnits.length,
                (index) {
                  MeasurementUnitData? measurementUnitData =
                      measurementUnitsProvider.measurementUnits[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, measurementUnitData);
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
                          text: "${measurementUnitData.shortCode}",
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
