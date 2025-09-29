import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/orderDetail.dart';
import 'package:project/screens/orderDetailScreen/widget/actionButtonWidget.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List lblOrderStatusDisplayNames = [];

  @override
  void initState() {
    super.initState();
    //fetch categoryList from api
    Future.delayed(Duration.zero).then((value) {
      lblOrderStatusDisplayNames = [
        getTranslatedValue(context, orderStatusDisplayNamesAwaitingLabel),
        getTranslatedValue(context, orderStatusDisplayNamesReceivedLabel),
        getTranslatedValue(context, orderStatusDisplayNamesProcessedLabel),
        getTranslatedValue(context, orderStatusDisplayNamesShippedLabel),
        getTranslatedValue(context, orderStatusDisplayNamesOutForDeliveryLabel),
        getTranslatedValue(context, orderStatusDisplayNamesDeliveredLabel),
        getTranslatedValue(context, orderStatusDisplayNamesCancelledLabel),
        getTranslatedValue(context, orderStatusDisplayNamesReturnedLabel),
      ];

      context.read<OrderDetailProvider>().getOrderDetail(context: context, orderId: widget.orderId);
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          text: "${getTranslatedValue(context, titleOrderLabel)} #${widget.orderId}",
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: Consumer<OrderDetailProvider>(
        builder: (context, orderDetailProvider, child) {
          if (orderDetailProvider.orderDetailState == OrderDetailState.loaded ||
              orderDetailProvider.orderDetailState == OrderDetailState.silentLoading) {
            Order? order = orderDetailProvider.orderDetail.data?.order;
            List<OrderItems>? orderItems = orderDetailProvider.orderDetail.data?.orderItems;

            String customerAddress = "";
            if ((order?.customerAddress ?? "").isNotEmpty) {
              customerAddress = "${customerAddress}" + (order?.customerAddress ?? "");
            }
            if ((order?.customerLandmark ?? "").isNotEmpty) {
              customerAddress = "${customerAddress}, " + (order?.customerLandmark ?? "");
            }
            if ((order?.customerArea ?? "").isNotEmpty) {
              customerAddress = "${customerAddress}, " + (order?.customerArea ?? "");
            }

            if ((order?.customerCity ?? "").isNotEmpty) {
              customerAddress = "${customerAddress}, " + (order?.customerCity ?? "");
            }
            if ((order?.customerState ?? "").isNotEmpty) {
              customerAddress = "${customerAddress}, " + (order?.customerState ?? "");
            }
            if ((order?.customerPincode ?? "").isNotEmpty) {
              customerAddress = "${customerAddress}, " + (order?.customerPincode ?? "");
            }
            if ((order?.customerCountry ?? "").isNotEmpty) {
              customerAddress = "${customerAddress}, " + (order?.customerCountry ?? "");
            }
            return setRefreshIndicator(
              refreshCallback: () {
                return orderDetailProvider.getOrderDetail(context: context, orderId: widget.orderId);
              },
              child: Padding(
                padding: EdgeInsetsDirectional.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          if (order!.orderNote.toString().isNotEmpty) getSizedBox(height: 10),
                          if (order.orderNote.toString().isNotEmpty)
                            Container(
                              padding: EdgeInsetsDirectional.all(10),
                              decoration: BoxDecoration(
                                color: ColorsRes.appColorYellow.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorsRes.appColorYellow.withValues(alpha: 0.5), width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextLabel(
                                    jsonKey: orderNoteLabel,
                                    softWrap: true,
                                    style: TextStyle(color: ColorsRes.mainTextColor, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 10),
                                  CustomTextLabel(
                                    text: order.orderNote,
                                    softWrap: true,
                                    style: TextStyle(color: ColorsRes.mainTextColor),
                                  ),
                                ],
                              ),
                            ),
                          if (order.orderNote.toString().isNotEmpty) getSizedBox(height: 10),
                          if (Constant.viewCustomerDetail == "1")
                            CustomTextLabel(
                              jsonKey: orderDetailsLabel,
                              style: TextStyle(color: ColorsRes.appColor, fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          if (Constant.viewCustomerDetail == "1") getSizedBox(height: 10),
                          if (Constant.viewCustomerDetail == "1")
                            Container(
                              padding: EdgeInsets.all(Constant.paddingOrMargin10),
                              margin: EdgeInsetsDirectional.only(bottom: Constant.paddingOrMargin10),
                              decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (Constant.viewCustomerDetail == "1")
                                    getOrderDetailContainer(
                                        titleFlex: 5, valueFlex: 10, title: getTranslatedValue(context, userMobileLabel), value: order.mobile ?? ""),
                                  if (order.orderNote!.isNotEmpty) getSizedBox(height: 10),
                                ],
                              ),
                            ),
                          CustomTextLabel(
                            jsonKey: billingDetailsLabel,
                            style: TextStyle(color: ColorsRes.appColor, fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          getSizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(Constant.paddingOrMargin10),
                            margin: EdgeInsetsDirectional.only(bottom: Constant.paddingOrMargin10),
                            decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getOrderDetailContainer(
                                  titleFlex: 5,
                                  valueFlex: 10,
                                  title: getTranslatedValue(context, orderDateLabel),
                                  value: (order.createdAt == null || order.createdAt == "null")
                                      ? DateTime.now().toString().formatDate()
                                      : DateTime.parse(order.createdAt!).toString().formatDate(),
                                ),
                                getSizedBox(height: 10),
                                getOrderDetailContainer(
                                    titleFlex: 5,
                                    valueFlex: 10,
                                    title: getTranslatedValue(context, deliveryTimeLabel), value: order.deliveryTime ?? ""),
                                getSizedBox(height: 10),
                                getOrderDetailContainer(
                                    titleFlex: 5, valueFlex: 10, title: getTranslatedValue(context, addressLabel), value: customerAddress),
                                Constant.session.isSeller() ? getSizedBox(height: 10) : const SizedBox.shrink(),
                                Constant.session.isSeller()
                                    ? order.additionalCharges!.isNotEmpty
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                              order.additionalCharges!.length,
                                              (index) => Padding(
                                                  padding: EdgeInsetsDirectional.only(bottom: 10),
                                                  child: getOrderDetailContainer(
                                                    titleFlex: 5,
                                                    valueFlex: 10,
                                                    title: order.additionalCharges![index].title!,
                                                    value: getCurrencyFormat(double.parse(order.additionalCharges![index].amount ?? "0.0")),
                                                  )),
                                            ),
                                          )
                                        : const SizedBox.shrink()
                                    : const SizedBox.shrink(),
                                Constant.session.isSeller()
                                    ? getOrderDetailContainer(
                                        titleFlex: 5,
                                        valueFlex: 10,
                                        title: getTranslatedValue(context, deliveryChargeLabel),
                                        value: getCurrencyFormat(double.parse(order.deliveryCharge ?? "0.0")),
                                      )
                                    : const SizedBox.shrink(),
                                Constant.session.isSeller() ? getSizedBox(height: 10) : const SizedBox.shrink(),
                                Constant.session.isSeller()
                                    ? getOrderDetailContainer(
                                        titleFlex: 5,
                                        valueFlex: 10,
                                        title: getTranslatedValue(context, totalItemsAmountLabel),
                                        value: getCurrencyFormat(double.parse(order.total ?? "0.0")),
                                      )
                                    : const SizedBox.shrink(),
                                getSizedBox(height: 10),
                                getOrderDetailContainer(
                                  titleFlex: 5,
                                  valueFlex: 10,
                                  title: getTranslatedValue(context, payableAmountLabel),
                                  value: getCurrencyFormat(double.parse(order.finalTotal ?? "0.0")),
                                ),
                                getSizedBox(height: 10),
                                getOrderDetailContainer(
                                    titleFlex: 5,
                                    valueFlex: 10,
                                    title: getTranslatedValue(context, paymentMethodLabel), value: order.paymentMethod ?? ""),
                              ],
                            ),
                          ),
                          CustomTextLabel(
                            jsonKey: listOfOrderItemsLabel,
                            style: TextStyle(color: ColorsRes.appColor, fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          getSizedBox(height: 10),
                          Column(
                            children: List.generate(orderItems?.length ?? 0, (index) {
                              return getOrderItemDetailsContainer(context: context, orderItem: orderItems?[index]);
                            }),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (Constant.session.isSeller())
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  backgroundColor: Theme.of(context).cardColor,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
                                  builder: (BuildContext context) {
                                    return MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(create: (context) => DeliveryBoysProvider()),
                                        ChangeNotifierProvider(create: (context) => OrderUpdateStatusProvider()),
                                        ChangeNotifierProvider(create: (context) => OrderDetailProvider()),
                                      ],
                                      child: Consumer<DeliveryBoysProvider>(
                                        builder: (context, deliveryBoysProvider, child) {
                                          if (context.read<DeliveryBoysProvider>().deliveryBoysState == ProductDeliveryBoysState.initial) {
                                            if (deliveryBoysProvider.deliveryBoysList.isEmpty) {
                                              deliveryBoysProvider.getDeliveryBoys(
                                                selectedDeliveryBoyIndex: int.parse(
                                                  "${order.deliveryBoyId.toString().isEmpty ? "0" : order.deliveryBoyId.toString()}",
                                                ),
                                                context: context,
                                                cityId: order.cityId!,
                                              );
                                            }
                                          }
                                          return Container(
                                            padding: EdgeInsetsDirectional.only(
                                              start: Constant.paddingOrMargin15,
                                              end: Constant.paddingOrMargin15,
                                              top: Constant.paddingOrMargin15,
                                              bottom: Constant.paddingOrMargin15,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Center(
                                                  child: CustomTextLabel(
                                                    jsonKey: updateDeliveryBoyLabel,
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.titleMedium!.merge(TextStyle(letterSpacing: 0.5, color: ColorsRes.mainTextColor)),
                                                  ),
                                                ),
                                                getSizedBox(height: 10),
                                                if (deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.loaded ||
                                                    deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.loadingMore ||
                                                    deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.updating)
                                                  Column(
                                                    children: List.generate(deliveryBoysProvider.deliveryBoysList.length, (index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          deliveryBoysProvider.setSelectedIndex(
                                                            deliveryBoysProvider.deliveryBoysList[index].id.toString(),
                                                          );
                                                        },
                                                        child: Container(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10),
                                                                  child: CustomTextLabel(
                                                                    text:
                                                                        "${deliveryBoysProvider.deliveryBoysList[index].name ?? ""}(${getTranslatedValue(context, pendingOrdersLabel)} - ${deliveryBoysProvider.deliveryBoysList[index].pendingOrderCount ?? "0"})",
                                                                  ),
                                                                ),
                                                              ),
                                                              Radio(
                                                                activeColor: ColorsRes.appColor,
                                                                value: context.read<DeliveryBoysProvider>().selectedDeliveryBoy,
                                                                groupValue: deliveryBoysProvider.deliveryBoysList[index].id.toString(),
                                                                onChanged: (value) {
                                                                  deliveryBoysProvider.setSelectedIndex(
                                                                    deliveryBoysProvider.deliveryBoysList[index].id.toString(),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                if (deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.loading)
                                                  Column(
                                                    children: List.generate(8, (index) {
                                                      return CustomShimmer(
                                                        height: 30,
                                                        width: double.maxFinite,
                                                        margin: EdgeInsetsDirectional.all(10),
                                                      );
                                                    }),
                                                  ),
                                                getSizedBox(height: 10),
                                                if (deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.updating ||
                                                    deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.loaded)
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10),
                                                    child: gradientBtnWidget(
                                                      context,
                                                      10,
                                                      callback: () {
                                                        Map<String, String> params = {};
                                                        params[ApiAndParams.orderId] = order.orderId.toString();
                                                        params[ApiAndParams.deliveryBoyId] = deliveryBoysProvider.selectedDeliveryBoy.toString();

                                                        deliveryBoysProvider.updateOrdersDeliveryBoy(params: params, context: context).then((value) {
                                                          Navigator.pop(context, value);
                                                        });
                                                      },
                                                      otherWidgets: Container(
                                                        child: (deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.updating)
                                                            ? CircularProgressIndicator(color: ColorsRes.appColorWhite)
                                                            : (deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.loaded)
                                                            ? CustomTextLabel(
                                                                jsonKey: updateDeliveryBoyLabel,
                                                                softWrap: true,
                                                                style: Theme.of(context).textTheme.titleMedium!.merge(
                                                                  TextStyle(color: ColorsRes.appColorWhite, letterSpacing: 0.5, fontWeight: FontWeight.w500),
                                                                ),
                                                              )
                                                            : Container(),
                                                      ),
                                                    ),
                                                  ),
                                                if (deliveryBoysProvider.deliveryBoysState == ProductDeliveryBoysState.loading)
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.only(
                                                      start: Constant.paddingOrMargin10,
                                                      end: Constant.paddingOrMargin10,
                                                    ),
                                                    child: CustomShimmer(height: 55, width: double.maxFinite),
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  orderDetailProvider.getOrderDetail(context: context, orderId: widget.orderId);
                                });
                              },
                              child: Container(
                                alignment: AlignmentDirectional.centerStart,
                                margin: EdgeInsetsDirectional.only(end: 5),
                                padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border?.all(color: ColorsRes.appColor, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomTextLabel(
                                            jsonKey: deliveryBoyLabel,
                                            style: TextStyle(fontSize: 14, color: ColorsRes.grey),
                                            softWrap: true,
                                          ),
                                          getSizedBox(height: 2),
                                          CustomTextLabel(
                                            text:
                                                "${(order.deliveryBoyName == null || order.deliveryBoyName == "null") ? getTranslatedValue(context, notAssignLabel) : order.deliveryBoyName}",
                                            style: TextStyle(fontWeight: FontWeight.w500, color: ColorsRes.mainTextColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              if (!Constant.session.isSeller())
                                Row(
                                  children: [
                                    Expanded(
                                      child: ActionButtonWidget(
                                        buttonName: getTranslatedValue(context, callToCustomerLabel),
                                        padding: EdgeInsetsDirectional.only(bottom: 10, end: 5),
                                        voidCallback: () {
                                          launchUrlAction("tel://${order.userMobile}");
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: ActionButtonWidget(
                                        buttonName: getTranslatedValue(context, getCustomerDirectionLabel),
                                        padding: EdgeInsetsDirectional.only(bottom: 10, start: 5),
                                        voidCallback: () {
                                          launchUrlAction(
                                            "https://www.google.com/maps/dir/?api=1&destination=${order.customerLatitude},${order.customerLongitude}",
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              if (!Constant.session.isSeller())
                                Row(
                                  children: [
                                    Expanded(
                                      child: ActionButtonWidget(
                                        buttonName: getTranslatedValue(context, callToSellerLabel),
                                        padding: EdgeInsetsDirectional.only(bottom: 10, end: 5),
                                        voidCallback: () {
                                          launchUrlAction("tel://${order.sellerMobile}");
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: ActionButtonWidget(
                                        buttonName: getTranslatedValue(context, getSellerDirectionLabel),
                                        padding: EdgeInsetsDirectional.only(bottom: 10, start: 5),
                                        voidCallback: () {
                                          launchUrlAction(
                                            "https://www.google.com/maps/dir/?api=1&destination=${order.sellerLatitude},${order.sellerLongitude}",
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    backgroundColor: Theme.of(context).cardColor,
                                    context: context,
                                    isScrollControlled: true,
                                    shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
                                    builder: (BuildContext context) {
                                      return MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider(create: (context) => DeliveryBoysProvider()),
                                          ChangeNotifierProvider(create: (context) => OrderUpdateStatusProvider()),
                                          ChangeNotifierProvider(create: (context) => OrderDetailProvider()),
                                        ],
                                        child: Consumer<OrderUpdateStatusProvider>(
                                          builder: (context, ordersProvider, child) {
                                            if (context.read<OrderUpdateStatusProvider>().ordersStatusState == OrderUpdateStatusState.initial) {
                                              context.read<OrderUpdateStatusProvider>().setSelectedStatus(
                                                (int.parse(order.activeStatus.toString()) - 1).toString(),
                                              );
                                              context.read<OrderUpdateStatusProvider>().getOrdersStatuses(context: context);
                                            }
                                            return Container(
                                              padding: EdgeInsetsDirectional.only(
                                                start: Constant.paddingOrMargin15,
                                                end: Constant.paddingOrMargin15,
                                                top: Constant.paddingOrMargin15,
                                                bottom: Constant.paddingOrMargin15,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Center(
                                                    child: CustomTextLabel(
                                                      jsonKey: updateOrderStatusLabel,
                                                      softWrap: true,
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.titleMedium!.merge(TextStyle(letterSpacing: 0.5, color: ColorsRes.mainTextColor)),
                                                    ),
                                                  ),
                                                  getSizedBox(height: 10),
                                                  if (ordersProvider.ordersStatusState == OrderUpdateStatusState.loaded ||
                                                      ordersProvider.ordersStatusState == OrderUpdateStatusState.updating)
                                                    Column(
                                                      children: List.generate(ordersProvider.orderStatusesList.length/*  - 2 */, (index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            ordersProvider.setSelectedStatus(index.toString());
                                                          },
                                                          child: Container(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Padding(
                                                                    padding: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10),
                                                                    child: CustomTextLabel(
                                                                      text: ordersProvider.orderStatusesList[index].status ?? "",
                                                                    ),
                                                                  ),
                                                                ),
                                                                Radio(
                                                                  activeColor: ColorsRes.appColor,
                                                                  value: ordersProvider.selectedOrderStatus,
                                                                  groupValue: context.watch<OrderUpdateStatusProvider>().orderStatusesList[index].id,
                                                                  onChanged: (value) {
                                                                    ordersProvider.setSelectedStatus(index.toString());
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  getSizedBox(height: 10),
                                                  if (ordersProvider.ordersStatusState == OrderUpdateStatusState.loading)
                                                    Column(
                                                      children: List.generate(8, (index) {
                                                        return CustomShimmer(
                                                          height: 26,
                                                          width: double.maxFinite,
                                                          margin: EdgeInsetsDirectional.all(10),
                                                        );
                                                      }),
                                                    ),
                                                  if (ordersProvider.ordersStatusState == OrderUpdateStatusState.loaded ||
                                                      ordersProvider.ordersStatusState == OrderUpdateStatusState.updating)
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10),
                                                      child: gradientBtnWidget(
                                                        context,
                                                        10,
                                                        callback: () {
                                                          Map<String, String> params = {};
                                                          if (orderDetailProvider.orderDetail.data?.order?.otp.toString() != "0" &&
                                                              ordersProvider.selectedOrderStatus.toString() == "6") {
                                                            TextEditingController editTextController = TextEditingController();

                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return StatefulBuilder(
                                                                  builder: (BuildContext context, StateSetter setState) {
                                                                    return AlertDialog(
                                                                      backgroundColor: Theme.of(context).cardColor,
                                                                      content: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          const CustomTextLabel(
                                                                            jsonKey: 'customer_will_share_the_otp_for_delivered_the_order',
                                                                            softWrap: true,
                                                                          ),
                                                                          const SizedBox(height: 10),
                                                                          TextField(
                                                                            controller: editTextController,
                                                                            keyboardType: TextInputType.number,
                                                                            style: TextStyle(color: ColorsRes.mainTextColor),
                                                                            inputFormatters: [
                                                                              FilteringTextInputFormatter.digitsOnly,
                                                                              // Allow digits only
                                                                              LengthLimitingTextInputFormatter(6),
                                                                              // Limit to 6 digits
                                                                            ],
                                                                            decoration: InputDecoration(
                                                                              hintText: 'Enter 6-digit OTP',
                                                                              hintStyle: TextStyle(color: ColorsRes.grey),
                                                                              counterText: '',
                                                                            ),
                                                                            onChanged: (value) {
                                                                              // Update the dialog state when the input changes
                                                                              setState(() {});
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text('Cancel'),
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed: editTextController.text.length == 6
                                                                              ? () {
                                                                                  if (editTextController.text ==
                                                                                      orderDetailProvider.orderDetail.data?.order?.otp.toString()) {
                                                                                    params[ApiAndParams.orderId] = widget.orderId;
                                                                                    params[ApiAndParams.statusId] = ordersProvider.selectedOrderStatus
                                                                                        .toString();
                                                                                    params[ApiAndParams.deliveryBoyId] = order.deliveryBoyId
                                                                                        .toString();
                                                                                    ordersProvider
                                                                                        .updateOrdersStatus(params: params, context: context)
                                                                                        .then((value) {
                                                                                          Navigator.pop(context, value);
                                                                                        });
                                                                                  } else {
                                                                                    showMessage(
                                                                                      context,
                                                                                      getTranslatedValue(context, invalidOtpLabel),
                                                                                      MessageType.warning,
                                                                                    );
                                                                                  }
                                                                                }
                                                                              : null,
                                                                          child: const Text('Submit'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ).then((value) {
                                                              Navigator.pop(context, value);
                                                            });
                                                          } else {
                                                            params[ApiAndParams.orderId] = widget.orderId;
                                                            params[ApiAndParams.statusId] = ordersProvider.selectedOrderStatus.toString();
                                                            params[ApiAndParams.deliveryBoyId] = order.deliveryBoyId.toString();
                                                            ordersProvider.updateOrdersStatus(params: params, context: context).then((value) {
                                                              Navigator.pop(context, value);
                                                            });
                                                          }
                                                        },
                                                        otherWidgets: Container(
                                                          child: (ordersProvider.ordersStatusState == OrderUpdateStatusState.loaded)
                                                              ? CustomTextLabel(
                                                                  jsonKey: updateOrderStatusLabel,
                                                                  softWrap: true,
                                                                  style: Theme.of(context).textTheme.titleMedium!.merge(
                                                                    TextStyle(color: ColorsRes.appColorWhite, letterSpacing: 0.5, fontWeight: FontWeight.w500),
                                                                  ),
                                                                )
                                                              : CircularProgressIndicator(color: ColorsRes.appColorWhite),
                                                        ),
                                                      ),
                                                    ),
                                                  if (ordersProvider.ordersStatusState == OrderUpdateStatusState.loading)
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.only(
                                                        top: Constant.paddingOrMargin10,
                                                        start: Constant.paddingOrMargin10,
                                                        end: Constant.paddingOrMargin10,
                                                      ),
                                                      child: CustomShimmer(height: 55, width: double.maxFinite),
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    orderDetailProvider.getOrderDetail(context: context, orderId: widget.orderId);
                                  });
                                },
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin5),
                                  margin: EdgeInsetsDirectional.only(start: 5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border?.all(color: ColorsRes.appColor, width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomTextLabel(
                                              jsonKey: statusLabel,
                                              style: TextStyle(color: ColorsRes.grey),
                                              softWrap: true,
                                            ),
                                            getSizedBox(height: 2),
                                            CustomTextLabel(
                                              text: lblOrderStatusDisplayNames[int.parse(order.activeStatus ?? "0") - 1].toString(),
                                              style: TextStyle(fontWeight: FontWeight.w500, color: ColorsRes.mainTextColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (orderDetailProvider.orderDetailState == OrderDetailState.loading) {
            return ListView(
              padding: EdgeInsetsDirectional.all(10),
              children: [
                CustomTextLabel(
                  jsonKey: orderDetailsLabel,
                  style: TextStyle(color: ColorsRes.appColor, fontWeight: FontWeight.w500, fontSize: 20),
                ),
                getSizedBox(height: 10),
                CustomShimmer(height: 90, width: double.maxFinite, borderRadius: 10),
                getSizedBox(height: 10),
                CustomTextLabel(
                  jsonKey: billingDetailsLabel,
                  style: TextStyle(color: ColorsRes.appColor, fontWeight: FontWeight.w500, fontSize: 20),
                ),
                getSizedBox(height: 10),
                CustomShimmer(height: 220, width: double.maxFinite, borderRadius: 10),
                getSizedBox(height: 10),
                CustomTextLabel(
                  jsonKey: listOfOrderItemsLabel,
                  style: TextStyle(color: ColorsRes.appColor, fontWeight: FontWeight.w500, fontSize: 20),
                ),
                getSizedBox(height: 10),
                Column(
                  children: List.generate(
                    10,
                    (index) => CustomShimmer(height: 160, width: double.maxFinite, borderRadius: 10, margin: EdgeInsets.only(bottom: 10)),
                  ),
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  launchUrlAction(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      showMessage(context, '${getTranslatedValue(context, couldNotLaunchLabel)} $url', MessageType.error);
      throw '${getTranslatedValue(context, couldNotLaunchLabel)} $url';
    }
  }
}
