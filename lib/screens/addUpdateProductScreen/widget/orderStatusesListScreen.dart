import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class StatusesListScreen extends StatefulWidget {
  const StatusesListScreen({super.key});

  @override
  State<StatusesListScreen> createState() => _StatusesListScreenState();
}

class _StatusesListScreenState extends State<StatusesListScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => context
        .read<OrderUpdateStatusProvider>()
        .getOrdersStatuses(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: tillStatusLabel,
        ),
      ),
      body: Consumer<OrderUpdateStatusProvider>(
        builder: (context, ordersProvider, child) {
          if (ordersProvider.ordersStatusState ==
              OrderUpdateStatusState.loading) {
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
          } else if (ordersProvider.ordersStatusState ==
              OrderUpdateStatusState.loaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                ordersProvider.orderStatusesList.length - 3,
                (index) {
                  OrderStatusesData? orderStatusesData =
                      ordersProvider.orderStatusesList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, orderStatusesData);
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
                          text: "${orderStatusesData.status}",
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
